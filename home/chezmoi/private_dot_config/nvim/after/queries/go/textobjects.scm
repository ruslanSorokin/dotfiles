; extends

(
 short_var_declaration
        left: (
          expression_list
            (identifier) @variable.inner
            ","? @_end
            (#make-range! "variable.outer" @variable.inner @_end)
        )
        right: (_)
)
