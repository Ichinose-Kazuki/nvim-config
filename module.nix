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
    extraSpecialArgs = { inherit inputs; };
  };
in
{
  options.myNvim = {
    enable = lib.mkEnableOption "my neovim configuration";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = nixvimPkg;
      description = "The built neovim package (before sandboxing).";
    };
  };
}
