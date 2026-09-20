{ pkgs,
  writeShellApplication,
}:

pkgs.writeShellApplication {
  name = "waybar-mediaplayer";

  runtimeInputs = [
    pkgs.playerctl
    pkgs.coreutils
  ];

  text = ''
    if ! playerctl status >/dev/null 2>&1; then
      exit 0
    fi

    STATUS=$(playerctl status)
    ARTIST=$(playerctl metadata artist 2>/dev/null)
    TITLE=$(playerctl metadata title 2>/dev/null)

    if [ "$STATUS" = "Playing" ]; then
      ICON="▶ "
    elif [ "$STATUS" = "Paused" ]; then
      ICON="⏸ "
    else
      ICON="⏹ "
    fi

    if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
      OUTPUT="$ARTIST - $TITLE"
    elif [ -n "$TITLE" ]; then
      OUTPUT="$TITLE"
    else
      OUTPUT="Unknown Track"
    fi

    echo "''${ICON}''${OUTPUT}" | cut -c1-40
  '';
}