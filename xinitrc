#!/bin/sh
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
xrandr --dpi 128

export _JAVA_AWT_WM_NONREPARENTING=1

cd "$HOME"
# source $HOME/.zprofile

# Java application
wmname LG3D
AWT_TOOLKIT=MToolkit; export AWT_TOOLKIT
#xsetroot -solid black

IMAGE="$HOME/Pictures/wallpaper.jpg"

if [ -f $IMAGE ]; then
  feh --bg-scale $IMAGE --bg-fill
else
  # xsetroot -solid slategray
  xsetroot -solid '#005577'
fi

xautolock -time 10 -locker slock &

xset b 0
xset r rate 250 40

dwmstatus &
dunst &
parcellite &

while true; do
  dwm > ~/.dwm.log 2>&1
done
