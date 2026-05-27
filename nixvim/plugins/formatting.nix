{ ... }:
{
  plugins.conform-nvim = {
    enable = true;

    settings = {
      formatters_by_ft = {
        lua = [ "stylua" ];
        python = [ "ruff_format" ];
        javascript = [
          [
            "prettierd"
            "prettier"
          ]
        ];
        typescript = [
          [
            "prettierd"
            "prettier"
          ]
        ];
        javascriptreact = [
          [
            "prettierd"
            "prettier"
          ]
        ];
        typescriptreact = [
          [
            "prettierd"
            "prettier"
          ]
        ];
        json = [
          [
            "prettierd"
            "prettier"
          ]
        ];
        markdown = [
          [
            "prettierd"
            "prettier"
          ]
        ];
        yaml = [
          [
            "prettierd"
            "prettier"
          ]
        ];
        html = [
          [
            "prettierd"
            "prettier"
          ]
        ];
        css = [
          [
            "prettierd"
            "prettier"
          ]
        ];
        nix = [ "nixpkgs-fmt" ];
        sh = [ "shfmt" ];
        c = [ "clang-format" ];
        cpp = [ "clang-format" ];
      };

      notify_on_error = true;
    };
  };

  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cf";
      action.__raw = ''
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end
      '';
      options = {
        desc = "Format buffer";
        silent = true;
      };
    }
  ];
}
