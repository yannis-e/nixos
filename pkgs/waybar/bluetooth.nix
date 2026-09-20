{ pkgs, writeShellApplication, }:

pkgs.writeShellApplication {
  name = "waybar-bluetooth";

  runtimeInputs = [
    pkgs.bluez
    pkgs.gawk
    pkgs.coreutils
  ];

  text = ''
    POWER_STATUS=$(bluetoothctl show | awk '/Powered:/ {print $2}')

    if [[ "$POWER_STATUS" == "yes" ]]; then
      mapfile -t CONNECTED_MACS < <(
        bluetoothctl devices Connected | awk '{print $2}'
      )

      TOTAL_DEVICES=''${#CONNECTED_MACS[@]}

      if [ "$TOTAL_DEVICES" -gt 0 ]; then
        FIRST_MAC="''${CONNECTED_MACS[0]}"

        FIRST_NAME=$(
          bluetoothctl info "$FIRST_MAC" |
            awk -F': ' '/Name:/ {print $2}' |
            head -n1
        )

        [ -z "$FIRST_NAME" ] && FIRST_NAME="Unknown"

        [[ ''${#FIRST_NAME} -gt 16 ]] &&
          FIRST_NAME="''${FIRST_NAME:0:16}.."

        if [ "$TOTAL_DEVICES" -gt 1 ]; then
          REMAINING_COUNT=$((TOTAL_DEVICES - 1))
          OUTPUT_TEXT="$FIRST_NAME (+$REMAINING_COUNT)"
        else
          OUTPUT_TEXT="$FIRST_NAME"
        fi

        echo "<span color='#8be9fd'>󰂱 $OUTPUT_TEXT</span>"
      else
        echo "<span color='#f1fa8c'>󰂯 Idle</span>"
      fi
    else
      echo "<span color='#ff5555'>󰂲 Off</span>"
    fi
  '';
}