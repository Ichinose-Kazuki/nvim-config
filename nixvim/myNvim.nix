{ lib, ... }:
{
  options.myNvim = {
    fileExplorer = lib.mkOption {
      type = lib.types.enum [
        "neo-tree"
        "oil"
      ];
      default = "oil";
      description = "File explorer plugin to use";
    };

    lsp.servers = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "lua_ls"
          "nil_ls"
          "nixd"
          "ts_ls"
          "html"
          "cssls"
          "jsonls"
          "pyright"
          "clangd"
          "bashls"
          "yamlls"
        ]
      );
      default = [
        "lua_ls"
        "nil_ls"
        "nixd"
        "ts_ls"
        "html"
        "cssls"
        "jsonls"
        "pyright"
        "clangd"
        "bashls"
        "yamlls"
      ];
      description = "LSP servers to enable";
    };
  };
}
