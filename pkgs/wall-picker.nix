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
        fzf --height 100% \
          --preview "img2sixel --width 1200 --height auto -q low \"$bgdir/{}\" 2>/dev/null" \
          --preview-window=right:75%:wrap
    )

    # Check if wallpaper was selected
    if [ -z "$bgfile" ]; then
      echo "No wallpaper selected..."
      exit 1
    fi

    # Update wallpaper symlink
    ln -sf "$bgdir/$bgfile" "$wallpaper"

    # Reload wallpaper in Hyprpaper
    hyprctl hyprpaper wallpaper ",$wallpaper"
  '';
}