{ pkgs,
  writeShellApplication,
}:

pkgs.writeShellApplication {
  name = "waybar-battery";

  runtimeInputs = [
    pkgs.coreutils
  ];

  text = ''
    BAT_DIR="/sys/class/power_supply/BAT0"

    if [ ! -d "$BAT_DIR" ]; then
      BAT_DIR="/sys/class/power_supply/BAT1"
    fi

    if [ ! -d "$BAT_DIR" ]; then
      echo "<span color='#ff5555'>󰂭 No Bat</span>"
      exit 0
    fi

    CAPACITY=$(cat "$BAT_DIR/capacity")
    STATUS=$(cat "$BAT_DIR/status")

    if [[ "$STATUS" == "Charging" ]]; then
      if [ "$CAPACITY" -le 20 ]; then
        ICON="󰢜"
      elif [ "$CAPACITY" -le 50 ]; then
        ICON="󰂇"
      elif [ "$CAPACITY" -le 80 ]; then
        ICON="󰂉"
      else
        ICON="󰂅"
      fi

      COLOR="#f1fa8c"
      TEXT="$ICON $CAPACITY%"

    elif [[ "$STATUS" == "Full" ]]; then
      ICON="󰁹"
      COLOR="#50fa7b"
      TEXT="$ICON $CAPACITY%"

    else
      if [ "$CAPACITY" -le 10 ]; then
        ICON="󰂎"
        COLOR="#ff5555"
        TEXT="$ICON $CAPACITY% LOW!"
      elif [ "$CAPACITY" -le 20 ]; then
        ICON="󰁺"
        COLOR="#ff5555"
        TEXT="$ICON $CAPACITY%"
      elif [ "$CAPACITY" -le 30 ]; then
        ICON="󰁻"
        COLOR="#f8f8f2"
        TEXT="$ICON $CAPACITY%"
      elif [ "$CAPACITY" -le 50 ]; then
        ICON="󰁽"
        COLOR="#f8f8f2"
        TEXT="$ICON $CAPACITY%"
      elif [ "$CAPACITY" -le 80 ]; then
        ICON="󰁿"
        COLOR="#f8f8f2"
        TEXT="$ICON $CAPACITY%"
      else
        ICON="󰁹"
        COLOR="#f8f8f2"
        TEXT="$ICON $CAPACITY%"
      fi
    fi

    echo "<span color='$COLOR'>$TEXT</span>"
  '';
}