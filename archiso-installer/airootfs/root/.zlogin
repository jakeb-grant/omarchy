#!/bin/bash
#
# Auto-launch the Minimal Hyprland configurator on boot
#

# Only run once
if [ -z "$CONFIGURATOR_RAN" ]; then
  export CONFIGURATOR_RAN=1
  /usr/local/bin/minimal-hyprland-configurator
fi
