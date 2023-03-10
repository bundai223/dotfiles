vim.g.vim_vue_plugin_config = {
  syntax = {
    template = { 'html' },
    script = { 'javascript', 'typescript' },
    style = { 'css', 'scss' },
    i18n = { 'json', 'yaml' },
    route = 'json',
  },
  full_syntax = { 'json' },
  initial_indent = { 'i18n', 'i18n.json', 'yaml' },
  attribute = 1,
  keyword = 1,
  foldexpr = 1,
  debug = 0,
}

-- let g:vim_vue_plugin_config = {
--       \'syntax': {
--       \   'template': ['html', 'pug'],
--       \   'script': ['javascript', 'typescript', 'coffee'],
--       \   'style': ['css', 'scss', 'sass', 'less', 'stylus'],
--       \   'i18n': ['json', 'yaml'],
--       \   'route': 'json',
--       \},
--       \'full_syntax': ['json'],
--       \'initial_indent': ['i18n', 'i18n.json', 'yaml'],
--       \'attribute': 1,
--       \'keyword': 1,
--       \'foldexpr': 1,
--       \'debug': 0,
--       \}
