{ inputs }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myNvim;

  nixvimPkg = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
    inherit pkgs;
    module = {
      imports = [ ./nixvim ];
    };
    extraSpecialArgs = {
      inherit inputs;
      myNvimCfg = cfg;
    };
  };
in
{
  options.myNvim = {
    enable = lib.mkEnableOption "my neovim configuration";

    fileExplorer = lib.mkOption {
      type = lib.types.enum [ "neo-tree" "oil" ];
      default = "oil";
      description = "File explorer plugin to use";
    };

    colorscheme = lib.mkOption {
      type = lib.types.enum [ "vscode" "tokyonight" "catppuccin" ];
      default = "vscode";
      description = "Colorscheme to use";
    };

    lsp.servers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "lua_ls" "nil_ls" "nixd" "ts_ls" "html" "cssls"
        "jsonls" "pyright" "clangd" "bashls" "yamlls"
      ];
      description = "LSP servers to enable";
    };

    plugins = {
      git.enable = lib.mkEnableOption "git plugins (gitsigns, gitgraph)" // { default = true; };
      zen.enable = lib.mkEnableOption "zen-mode and no-neck-pain plugins" // { default = true; };
      dashboard.enable = lib.mkEnableOption "dashboard (alpha)" // { default = true; };
    };

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = nixvimPkg;
      description = "The built neovim package.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
