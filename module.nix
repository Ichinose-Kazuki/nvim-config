{ inputs }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myNvim;
  
  # Home Manager 側の設定値 (cfg) を受け取って Nixvim をビルドする
  nixvimPkg = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
    inherit pkgs;
    module = {
      imports = [ ./nixvim ];
      
      # Nixvim 側のオプションに Home Manager 側の値を流し込む
      myNvim = {
        fileExplorer = cfg.fileExplorer;
        lsp.servers = cfg.lsp.servers;
      };
    };
    extraSpecialArgs = { inherit inputs; };
  };
in
{
  # Home Manager 側に公開するオプションを定義する
  options.myNvim = {
    enable = lib.mkEnableOption "my neovim configuration";

    fileExplorer = lib.mkOption {
      type = lib.types.enum [ "neo-tree" "oil" ];
      default = "oil";
      description = "File explorer plugin to use";
    };

    lsp.servers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "lua_ls" "nil_ls" "nixd" "ts_ls" "html" "cssls"
        "jsonls" "pyright" "clangd" "bashls" "yamlls"
      ];
      description = "LSP servers to enable";
    };

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = nixvimPkg;
      description = "The built neovim package.";
    };
  };

  # myNvim.enable が true のとき、ビルドした Neovim パッケージをインストールする
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
