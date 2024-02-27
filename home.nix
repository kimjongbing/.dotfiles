{ config, pkgs, ... }:

{
  home.username = "deishuu";
  home.homeDirectory = "/home/deishuu";
  home.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    discord
    vscode
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
