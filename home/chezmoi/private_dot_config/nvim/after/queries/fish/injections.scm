; extends

; eval "printf "%s" $x"
((command
  name: (word) @func_name
  argument: [(double_quote_string)(single_quote_string)] @injection.content)
  (#any-of? @func_name "eval" )
  (#set! injection.language "fish")
  (#offset! @injection.content 0 1 0 -1))

; #{{ if .os.isDarwin }}
; ...
; #{{ end }}
((comment) @injection.content
  (#lua-match? @injection.content "^#{{")
  (#set! injection.language "gotmpl")
  (#set! injection.combined)
  (#offset! @injection.content 0 1 0 0)
)

; source "{{ .os.Posix.HomebrewPrefix }}"
([(double_quote_string)(single_quote_string)] @injection.content
  (#contains? @injection.content "{{" "}}")
  (#set! injection.language "gotmpl")
)
