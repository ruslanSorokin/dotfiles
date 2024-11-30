def "gpg ring export" []: nothing -> nothing {
  gpg --output subkeys.sec.gpg --armor --export-secret-subkeys $env.USER_GPG_MASTER_KEY
  gpg --output master.sec.gpg --armor --export-secret-key $env.USER_GPG_MASTER_KEY
  gpg --output master.pub.gpg --armor --export $env.USER_GPG_MASTER_KEY
}

def "gpg key new-main" []: nothing -> nothing {
  def gen [
    --dry
  ] {
    let cmd_parts = [
      gpg
      --expert
      --cert-notation
      type='Global'
      --quick-generate-key $"'($env.USER_NAME) <($env.USER_EMAIL)>'" ed25519 'sign,cert' 1y
    ]

    let cmd = ($cmd_parts | str join ' ')

    print 'Executing: ' $cmd
    if not $dry { run $cmd }
  }

  gen --dry; if not (proceed) { return }; gen
  gpg ring export
}

# Generates a new gpg sub-key for this machine.
def "gpg key add-sub" [
  --encryption (-e) # generate key with encryption capability
]: nothing -> nothing {
  def gen [
    --dry
  ] {
    let cmd_parts = if $encryption {
      [
      gpg
      --expert
      --cert-notation
      type='Global'
      --quick-add-key ($env.USER_GPG_MASTER_KEY) cv25519 encrypt 6m
      ]

    } else {
      [
      gpg
      --expert
      --cert-notation
      type='Machine-Local'
      --cert-notation
      machine="($env.MACHINE_NAME)"
      --quick-add-key ($env.USER_GPG_MASTER_KEY) ed25519 sign 6m
      ]
    }

    let cmd = ($cmd_parts | str join ' ')

    print 'Executing: ' $cmd
    if not $dry { run $cmd }
  }

  gen --dry; if not (proceed) { return }; gen
  gpg ring export
}

def "gpg upgrade-dir" [
  dir: string
]: nothing -> nothing {
  if not (dir | path exists) {
    error make {msg: "Directory doesn't exist"}
  }

  chown -R $"(whoami):(whoami)" $dir
  chown 600 $"($dir)/*"
  chown 700 $dir
}

def "gpg reload" [] nothing -> nothing { gpgconf --kill gpg-agent }

# Generates a new ssh key for this machine.
def "ssh new-key" [
  file: string
  comment: string = ""
]: nothing -> nothing {
  def gen [
    --dry
  ] {
    let cmd_parts = [
      ssh-keygen
      -a 128
      -t ed25519
      -f ("~/.ssh/keys" | path join $file)
      -C $"'($comment)'"
    ]

    let cmd = ($cmd_parts | str join ' ')

    print 'Executing: ' $cmd
    if not $dry { run $cmd }
  }

  gen --dry; if not (proceed) { return }; gen
}


# Calls the `cmd`.
def run [cmd: string] { nu -c $cmd }

def proceed [
  msg: string = "Are you sure you want to proceed?" # question to ask
] {
  if ([yes, no] | input list $msg) == no {
    print "Cancelled"
    return false
  }

  print "Proceeding..."
  return true
}
