{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf getExe;

  cfg = config.cfg.programs.zsh;
in
{
  options.cfg.programs.zsh.enable =
    mkEnableOption "zsh";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      enableGlobalCompInit = false;
      enableLsColors = false;

      histFile = "$XDG_DATA_HOME/zsh/zsh_history";
      histSize = 10000;

      promptInit = ''
        fpath+=(${pkgs.pure-prompt}/share/zsh/site-functions)
        autoload -U promptinit
        promptinit
        prompt pure
      '';

      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      setOptions = [
        "AUTO_CD"
        "GLOBDOTS"
        "HIST_IGNORE_ALL_DUPS"
        "HIST_FIND_NO_DUPS"
        "HIST_IGNORE_SPACE"
        "INC_APPEND_HISTORY"
      ];

      shellAliases = {
        rg = getExe pkgs.ripgrep;

        cat = "${getExe pkgs.bat} -p";

        ls = "${getExe pkgs.eza} --group-directories-first";
        la = "ls -a";
        ll = "ls -lah";
        lt = "${getExe pkgs.eza} --tree --group-directories-first";

        wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";
        die = "pkill -9";
      };

      shellInit = ''
        zsh-newuser-install() { :; }
      '';

      interactiveShellInit = ''
        bindkey -e

        bindkey "\e[5~" beginning-of-line
        bindkey "\e[6~" end-of-line
        bindkey "^[[3~" delete-char
        bindkey '^H' backward-kill-word
        bindkey '^[[3;5~' kill-word

        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        bindkey "^Z" undo
        bindkey "^Y" redo

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
        WORDCHARS='*?_.[]~=&;!$%^(){}<>|'

        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

        bindkey "''${key[Up]}" history-substring-search-up
        bindkey "''${key[Down]}" history-substring-search-down

        fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)
        autoload -U compinit
        compinit
      '';
    };

    programs.fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };

    users.users.${config.cfg.core.username}.shell = pkgs.zsh;

    environment.sessionVariables = {
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
    };
  };
}