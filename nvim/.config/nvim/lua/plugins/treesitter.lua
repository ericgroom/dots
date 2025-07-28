return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup {
        ensure_installed = { "lua", "vim", "vimdoc", "typescript", "javascript", "nix", "elixir", "swift", "caddy" },
        ignore_install = {},
        sync_install = false,
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        }
      }
    end
  }
}
