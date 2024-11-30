; extends

; #{{ if .os.isDarwin }}
; ...
; #{{ end }}
((comment) @injection.content
  (#contains? @injection.content "{{" "}}")
  ; BUG: for some reason parser tries to parse a string inside a comment
  (#not-contains? @injection.content "chezmoi:template:")
  (#set! injection.language "gotmpl")
  (#set! injection.combined)
)

; source "{{ .os.Posix.HomebrewPrefix }}"
(string
  (string_content) @injection.content
  (#contains? @injection.content "{{" "}}")
  (#set! injection.language "gotmpl")
)

((raw_string) @injection.content
  (#contains? @injection.content "{{" "}}")
  (#set! injection.language "gotmpl")
)
