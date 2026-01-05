return {
  cmd = { 'typescript-language-server', '--stdio' },
  init_options = {
    preferences = { maximumHoverLength = 1e6 },
    root_dir = vim.fs.dirname(vim.fs.find({ 'package.json', '.git' }, { upward = true })[1]),
  },
}
