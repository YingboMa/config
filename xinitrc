#!/bin/sh
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
xrandr --dpi 96

export _JAVA_AWT_WM_NONREPARENTING=1

cd "$HOME"
# source $HOME/.zprofile

# Java application
wmname LG3D
AWT_TOOLKIT=MToolkit; export AWT_TOOLKIT
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
set _JAVA_AWT_WM_NONREPARENTING=1 in /etc/profile.d/jre.sh
#xsetroot -solid black

IMAGE="$HOME/Pictures/wallpaper.jpg"

if [ -f $IMAGE ]; then
  feh --bg-scale $IMAGE --bg-fill
else
  # xsetroot -solid slategray
  xsetroot -solid '#005577'
fi

xautolock -time 10 -locker slock &

export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx

xset b 0
xset r rate 150 70

dwmstatus &
dunst &
fcitx &
parcellite &

while true; do
  dwm > ~/.dwm.log 2>&1
done
