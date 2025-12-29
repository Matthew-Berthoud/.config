return {
  cmd = { 'typescript-language-server', '--stdio' },
  init_options = {
    preferences = { maximumHoverLength = 1e6 },
  },
  on_attach = function(client)
    -- Disable ts_ls formatting so Prettier handles it
    client.server_capabilities.documentFormattingProvider = false
  end,
}
