#!/bin/bash

get_battery() {
  case "$(uname -s)" in
  Darwin)
    # macOS
    pmset -g batt | grep -Eo "\d+%" | cut -d% -f1
    ;;
  Linux)
    # Check if running in WSL
    if grep -qi microsoft /proc/version; then
      # WSL - no battery access
      echo "N/A"
      return
    fi

    # Regular Linux
    if [ -f /sys/class/power_supply/BAT0/capacity ]; then
      cat /sys/class/power_supply/BAT0/capacity
    elif command -v acpi &>/dev/null; then
      acpi -b | grep -Eo "[0-9]+%" | cut -d% -f1
    else
      echo "N/A"
    fi
    ;;
  *)
    echo "N/A"
    ;;
  esac
}

battery=$(get_battery)

if [ "$battery" != "N/A" ]; then
  echo "${battery}% |"
else
  echo ""
fi
