return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "[C]ode [F]ormat buffer",
      },
    },
    opts = {
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 1000,
      },
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
}
