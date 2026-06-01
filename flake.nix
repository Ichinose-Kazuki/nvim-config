{
  description = "Standalone neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-scrollbar = {
      url = "github:petertriho/nvim-scrollbar";
      flake = false;
    };
    namu-nvim = {
      url = "github:bassamsdata/namu.nvim";
      flake = false;
    };
    git-graph-nvim = {
      url = "github:isakbm/gitgraph.nvim";
      flake = false;
    };
    incline-nvim = {
      url = "github:b0o/incline.nvim";
      flake = false;
    };
    nvim-spectre = {
      url = "github:nvim-pack/nvim-spectre";
      flake = false;
    };
    grug-far-nvim = {
      url = "github:MagicDuck/grug-far.nvim";
      flake = false;
    };
    telescope-live-grep-args = {
      url = "github:nvim-telescope/telescope-live-grep-args.nvim";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    {
      homeManagerModules.default = import ./module.nix { inherit inputs; };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
          inherit pkgs;
          module = {
            imports = [ ./nixvim ];
          };
          extraSpecialArgs = {
            inherit inputs;
            myNvimCfg = {
              fileExplorer = "oil";
              colorscheme = "vscode";
              lsp.servers = [
                "lua_ls"
                "nil_ls"
                "ts_ls"
                "html"
                "cssls"
                "jsonls"
                "pyright"
                "clangd"
                "bashls"
                "yamlls"
              ];
              plugins = {
                git.enable = true;
                zen.enable = true;
                dashboard.enable = true;
              };
            };
          };
        };
        formatter = pkgs.nixfmt;
      }
    );
}
