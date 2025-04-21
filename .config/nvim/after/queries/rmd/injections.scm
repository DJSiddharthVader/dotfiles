(fenced_code_block
  (info_string
    (language) @_lang)
  (code_fence_content) @injection.content
  (#set-lang-from-info-string! @_lang))

((latex) @injection.content
  (#set! injection.language "latex")
  (#set! injection.combined))

((r) @injection.content
  (#set! injection.language "r")
  (#set! injection.combined))

((bash) @injection.content
  (#set! injection.language "bash")
  (#set! injection.combined))

(rchunk
  (renv_content) @injection.content
  (#set! injection.language "r")
  (#set! injection.combined))
