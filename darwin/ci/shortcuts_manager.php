#!/usr/bin/env php
<?php

// Determine which command has been called.
$cmd = (!empty($argv[1])) ? strtolower($argv[1]) : null;

// If an invalid number of arguments has been passed (or if no argument
// was given at all), display help information.
if ($argc < 2 || $argc > 3 || !in_array($cmd, ['save', 'load'])) {

    echo <<<HELP
A small tool to automatically export and import custom macOS keyboard shortcuts.

Usage:

  save [path]

  Use the 'save' command to create a JSON file of your existing shortcuts.
  If no target path is provided, a file named 'keyboard_shortcuts.json'
  will be created in the current directory.

  load [path]

  The 'load' command uses a JSON file to register shortcuts on the system.
  If no source path is provided, the command will expect to find a file
  named 'keyboard_shortcuts.json' in the current directory.


HELP;


} elseif ($cmd === 'save') {

    // Get the list of apps that have custom keyboard shortcuts.
    $command = 'defaults read com.apple.universalaccess "com.apple.custommenu.apps"';

    // Ensure that we do have defined keyboard shortcuts.
    exec($command.' 2>&1 >/dev/null', $_, $returnStatus);

    if ($returnStatus !== 0) {
        say('You don’t seem to have any custom keyboard shortcut defined in System Preferences.');
        exit(1);
    }

    $appIdentifiers = shell_exec($command);
    $allShortcuts = [];

    // Get the list of shortcuts that exist for each registered application.
    foreach (plistArrayToPhpArray($appIdentifiers) as $i => $identifier) {

        $shortcuts = shell_exec("defaults read {$identifier} NSUserKeyEquivalents");

        $allShortcuts[$identifier] = plistDictToPhpArray($shortcuts);
    }

    // Convert what we got to JSON and save it to disk.
    $json = json_encode($allShortcuts, JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE);
    $path = determinePath();

    file_put_contents($path, $json);

    // Display some stats.
    list($appCount, $shortcutCount) = getCounts($allShortcuts);
    say("Found {$shortcutCount} keyboard shortcuts for {$appCount} applications.");
    say("Keyboard shortcuts have been saved to {$path}");


} elseif ($cmd === 'load') {

    $path = determinePath();

    if (!is_readable($path)) {
        say("Cannot find anything at path '{$path}'.");
        say("Use 'help' command to get usage info.");
        exit(1);
    }

    say("Importing keyboard shortcuts from '{$path}'.");

    $allShortcuts = json_decode(file_get_contents($path), $assoc = true);

    foreach ($allShortcuts as $identifier => $shortcuts) {

        say("Importing shortcuts for {$identifier}.");

        $dict = phpArrayToPlistDict($shortcuts);

        // Register the list of shortcuts for the current application.
        shell_exec("defaults write {$identifier} NSUserKeyEquivalents '{$dict}'");

        registerAppIfNeeded($identifier);
    }

    // Restart the defaults server.
    shell_exec('killall cfprefsd');

    // Display some stats.
    list($appCount, $shortcutCount) = getCounts($allShortcuts);
    say("Registered {$shortcutCount} keyboard shortcuts for {$appCount} applications.");
}


exit(0);


/**
 * Echo a string to the standard output.
 *
 * @param  string  $something
 *
 * @return void
 */
function say($something)
{
    echo $something.PHP_EOL;
}

/**
 * Convert a plist array to a indexed PHP array.
 *
 * @param  string  $value  The string representing the plist array
 *
 * @return array
 */
function plistArrayToPhpArray($value)
{
    $items = [];

    preg_match_all('#"(.*)"#', $value, $items);

    if ($items) {
        return $items[1];
    }

    return $items;
}

/**
 * Convert a plist dictionary to an associative PHP array.
 *
 * @param  string  $value  The string representing the plist dictionary
 *
 * @return array
 */
function plistDictToPhpArray($value)
{
    $items = [];
    preg_match_all('#(.+) = "(.*)"#', $value, $items);

    if ($items) {
        // Create an array containing menu labels
        // as keys and shortcut codes as values.
        return array_combine(
            array_map('normalizeLabel', $items[1]),
            array_map('normalizeShortcut', $items[2])
        );
    }

    return $items;
}

/**
 * Convert a shortcut label to a human-friendly representation.
 *
 * @param  string  $label
 *
 * @return string
 */
function normalizeLabel($label)
{
    // Trim and unescape.
    $label = trim(stripslashes($label), " \"");

    // Convert \uXXXX sequences to Unicode characters.
    return codePointToUnicode($label);
}

/**
 * Convert a shortcut label to a macOS-friendly representation.
 *
 * @param  string  $label
 *
 * @return string
 */
function denormalizeLabel($label)
{
    // Convert \uXXXX sequences to Unicode characters.
    return unicodeToCodePoint($label);
}

/**
 * Convert a shortcut to a human-friendly representation.
 *
 * @param  string  $shortcut
 *
 * @return string
 */
function normalizeShortcut($shortcut)
{
    // Replace special characters by their real symbol key.
    $symbols = [
        '@' => "\u{2318}",// ⌘ command
        '~' => "\u{2325}",// ⌥ option
        '$' => "\u{21E7}",// ⇧ shift
    ];
    $str = str_replace(array_keys($symbols), array_values($symbols), $shortcut);

    // Convert \uXXXX sequences to Unicode characters.
    $str = codePointToUnicode($str);

    // Make letters in shortcuts appear uppercased.
    $str = mb_strtoupper($str);

    // Handle special case of double quotes.
    $str = str_replace('\"', '"', $str);

    return $str;
}

/**
 * Convert a shortcut to a macOS-friendly representation.
 *
 * @param  string  $shortcut
 *
 * @return string
 */
function denormalizeShortcut($shortcut)
{
    // Replace symbols by special characters.
    $symbols = [
        '@' => "\u{2318}",// ⌘ command
        '~' => "\u{2325}",// ⌥ option
        '$' => "\u{21E7}",// ⇧ shift
    ];
    $str = str_replace(array_values($symbols), array_keys($symbols), $shortcut);

    // Handle special case of double quotes.
    $str = str_replace('"', '__DOUBLE_QUOTE_PLACEHOLDER__', $str);

    // Convert Unicode characters to \uXXXX sequences.
    $str = unicodeToCodePoint($str);

    $str = str_replace('__DOUBLE_QUOTE_PLACEHOLDER__', '\\"', $str);

    return $str;
}

/**
 * Convert \Uxxxx sequences to actual Unicode characters.
 *
 * @param  string  $str
 *
 * @return string
 */
function codePointToUnicode($str)
{
    // Hack to prevent a stupid PCRE error.
    // Using \U or \\U to begin the regex below makes PCRE incorrectly
    // think that we’re trying to use some specific mode. So we’re
    // just removing the backslashes before running the regex.
    $str = str_replace('\U', 'U', stripslashes($str));

    // Some replacement magic.
    // http://stackoverflow.com/a/1805845
    return html_entity_decode(
        preg_replace("#U([0-9a-fA-F]{4})#", "&#x\\1;", $str
    ), ENT_NOQUOTES, 'UTF-8');
}

/**
 * Convert Unicode characters to \Uxxxx sequences.
 *
 * @param  string  $str
 *
 * @return string
 */
function unicodeToCodePoint($str)
{
    // Clever trick to convert non-ASCII characters
    // to code points. Probably not the fastest
    // way, but fast enough and super simple!
    // http://stackoverflow.com/a/7107750
    $str = json_encode($str);

    // Code points have to use a capital U letter
    // in order to be recognized by macOS.
    $str = preg_replace('#u([0-9a-fA-F])#', 'U\\1', $str);

    // We then make sure to remove the surrounding
    // double quotes generated by json_encode().
    return trim($str, '"');
}

/**
 * Convert an associative PHP array to a plist dictionary.
 *
 * @param  array  $array  The array to convert
 *
 * @return string
 */
function phpArrayToPlistDict($array)
{
    $dict = '';

    foreach ($array as $label => $shortcut) {

        $label = denormalizeLabel($label);
        $shortcut = denormalizeShortcut($shortcut);

        $dict .= "\"{$label}\" = \"{$shortcut}\";";
    }

    return '{'.$dict.'}';
}

/**
 * Add an application identifier to the 'com.apple.universalacces'
 * file if it is not already there.
 *
 * @param  string  $identifier
 *
 * @return void
 */
function registerAppIfNeeded($identifier)
{
    // Get the current list of registered applications.
    $command = 'defaults read com.apple.universalaccess "com.apple.custommenu.apps"';

    $registeredIdentifiers = shell_exec($command);

    // Add the identifier only if it does not exist yet.
    // Having duplicates in this list makes System Preferences crash!
    if (!in_array($identifier, plistArrayToPhpArray($registeredIdentifiers))) {
        shell_exec('defaults write com.apple.universalaccess "com.apple.custommenu.apps" -array-add "'.$identifier.'"');
    }
}

/**
 * Find out which path has been provided or fall back on a default one.
 *
 * @return string
 */
function determinePath()
{
    global $argv;

    $path = (!empty($argv[2])) ? $argv[2] : './keyboard_shortcuts.json';

    // Add an extension to the path in case it’s missing.
    return ensureJsonExtension($path);
}

/**
 * Append a JSON extension on a given path if none is there already.
 *
 * @param  string  $path
 *
 * @return string
 */
function ensureJsonExtension($path)
{
    return (substr($path, -5) === '.json') ? $path : $path.'.json';
}

/**
 * Count the number of applications and shortcuts in the given list.
 *
 * @param  array  $shortcuts
 *
 * @return array  An indexed array containing two values. The first is
 *                the number of applications and the second is the
 *                total number of shortcuts in the list.
 */
function getCounts($shortcuts)
{
    $appCount = count($shortcuts);

    $shortcutCount = array_reduce($shortcuts, function ($carry, $item) {
        return $carry + count($item);
    }, 0);

    return [$appCount, $shortcutCount];
}
