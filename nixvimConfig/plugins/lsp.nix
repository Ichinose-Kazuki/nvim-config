{
  myNvimCfg,
  lib,
  ...
}:
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

    servers = lib.recursiveUpdate
      (lib.genAttrs myNvimCfg.lsp.servers (name: { enable = true; }))
      {
        lua_ls.settings.Lua = {
          diagnostics.globals = [ "vim" ];
          workspace.checkThirdParty = false;
        };
      };
  };
}
