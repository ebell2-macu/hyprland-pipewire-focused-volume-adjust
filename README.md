# hyprland-pipewire-focused-volume-adjust
A neat script to adjust the focused windows volume using media keys

## Usage in hyprland.conf
```
bindle=SUPER, XF86AudioRaiseVolume, exec, <script_location>/hpfva.sh 0.5+
bindle=SUPER, XF86AudioLowerVolume, exec, <script_location>/hpfva.sh 0.5-
bindle=SUPER, XF86AudioMute, exec, <script_location>/hpfva.sh toggle
```
