{ pkgs, ... }:

{
  # User definition and permissions
  users.users.yannis = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "dialout" "plugdev" "input" ];
    packages = with pkgs; [
      tree
    ];
  };
}