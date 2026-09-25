vim.lsp.enable({ 'lua_ls', 'gopls' })

vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }

vim.diagnostic.config({virtual_text = true})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspCompletion', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client and client:supports_method('textDocument/completion') then
      local provider = client.server_capabilities.completionProvider
      local chars = provider.triggerCharacters or {}

      for char in ('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'):gmatch('.') do
        if not vim.tbl_contains(chars, char) then
          table.insert(chars, char)
        end
      end

      provider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
      })
    end
  end,
})

vim.cmd("set completeopt+=noselect")

