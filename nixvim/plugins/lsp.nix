{ myNvimCfg, ... }:
let
  enabled = name: builtins.elem name myNvimCfg.lsp.servers;
in
{
  plugins.lsp = {
    enable = true;

    keymaps = {
      silent = true;
      diagnostic = {
        "<leader>cd" = "open_float";
        "[d" = "goto_prev";
        "]d" = "goto_next";
        "<leader>cl" = "setloclist";
      };
      lspBuf = {
        "gd" = "definition";
        "gD" = "declaration";
        "gr" = "references";
        "gi" = "implementation";
        "gt" = "type_definition";
        "K" = "hover";
        "<leader>ca" = "code_action";
        "<leader>rn" = "rename";
        "<leader>cs" = "signature_help";
      };
    };

    servers = {
      lua_ls = {
        enable = enabled "lua_ls";
        settings.Lua = {
          diagnostics.globals = [ "vim" ];
          workspace.checkThirdParty = false;
        };
      };

      nil_ls.enable = enabled "nil_ls";
      nixd.enable = enabled "nixd";

      ts_ls.enable = enabled "ts_ls";
      html.enable = enabled "html";
      cssls.enable = enabled "cssls";
      jsonls.enable = enabled "jsonls";

      pyright.enable = enabled "pyright";

      clangd.enable = enabled "clangd";

      bashls.enable = enabled "bashls";

      yamlls.enable = enabled "yamlls";
    };
  };
}
