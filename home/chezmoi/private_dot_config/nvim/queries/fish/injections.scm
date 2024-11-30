((comment) @injection.content
  (#set! injection.language "comment"))

(command
  name: (word) @_cmd
  (#eq? @_cmd "printf")
  argument: (double_quote_string) @injection.content
  (#set! injection.language "printf")
  (#set! injection.include-children)
)
