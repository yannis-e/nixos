{
  writeShellApplication,
  libsixel,
  fzf,
  coreutils,
  hyprpaper,
}:

writeShellApplication {
  name = "wall-picker";

  runtimeInputs = [
    libsixel
    fzf
    coreutils
    hyprpaper
  ];

  text = ''
    # IPC must be enabled inside hyprpaper.conf
    bgdir="$XDG_DATA_HOME/walls/"
    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}"
    wallpaper="$state_dir/wallpaper"

    mkdir -p "$state_dir"

    bgfile=$(
      find "$bgdir" -maxdepth 1 -type f -printf "%f\n" 2>/dev/null |
        fzf \
          --height 100% \
          --preview "img2sixel -w 80 -q low \"$bgdir/{}\" 2>/dev/null" \
          --preview-window=right:75%:wrap
    )

    if [ -z "$bgfile" ]; then
      echo "No wallpaper selected..."
      exit 1
    fi

    ln -sf "$bgdir/$bgfile" "$wallpaper"

    hyprctl hyprpaper wallpaper ",$wallpaper"
  '';
}