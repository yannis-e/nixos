{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.cfg.programs.emacs.enable =
    mkEnableOption "Emacs with Doom Emacs and Org mode";

  config = mkIf config.cfg.programs.emacs.enable {
    hj.packages = with pkgs; [
      emacs
    ];

    hj.files = {
      ".config/doom/config.el".source =
        "${inputs.dotfiles}/doom/.config/doom/config.el";

      ".config/doom/init.el".source =
        "${inputs.dotfiles}/doom/.config/doom/init.el";

      ".config/doom/packages.el".source =
        "${inputs.dotfiles}/doom/.config/doom/packages.el";
    };

    environment.sessionVariables.PATH = [
      "$HOME/.config/emacs/bin"
    ];
  };
}