{ inputs }:
{
  config,
  lib,
  ...
}:
{
  imports = [ (import ./core.nix { inherit inputs; }) ];

  config.home.packages = lib.mkIf config.myNvim.enable [
    config.myNvim.finalPackage
  ];
}
