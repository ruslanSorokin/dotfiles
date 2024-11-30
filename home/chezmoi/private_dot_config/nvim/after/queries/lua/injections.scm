; extends

; --{{ if .os.isDarwin }}
; ...
; --{{ end }}
(comment
  content: (comment_content) @injection.content
  (#contains? @injection.content "{{" "}}")
  (#set! injection.language "gotmpl")
  (#set! injection.combined)
)

; local homebrewPrefix = "{{ .os.Posix.HomebrewPrefix }}"
(string
  content: (string_content) @injection.content
  (#contains? @injection.content "{{" "}}")
  (#set! injection.language "gotmpl")
  (#set! injection.combined)
)

; wezterm quick_select_patterns
(assignment_statement
  (variable_list
    name:
      (dot_index_expression
        table: (identifier)
        field: (identifier) @_field
      )
  )
  (expression_list
    value: 
      (table_constructor
        (comment
          content: (comment_content)
        )
        (field
          value:
          (string
            content: (string_content) @injection.content
          )
        )
      )
  )
  (#eq? @_field "quick_select_patterns")
  (#set! injection.language "regex")
)
