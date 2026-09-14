{ pkgs, ... }:

{
  # User definition and permissions
  users.users.yannis = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel" 
      "networkmanager" 
      "video" 
      "dialout" 
      "plugdev" 
      "input" 
      "audio"
      "gamemode"  # Gives access to GameMode performance optimizations
    ];
    packages = with pkgs; [
      tree
    ];
  };
}