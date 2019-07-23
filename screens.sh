#!/bin/bash
# grab args
scriptname=$0
MODE="all"
LAPTOP_DISPLAY="eDP-1"
LAB_DISPLAY1="DP-1-8"
LAB_DISPLAY2="DP-1-1-8"
DESK_DISPLAY1="DP-1-2"
DESK_DISPLAY2="DP-2-1"

while [[ $# -gt 0 ]]
do
key="$1"
case $key in 
    -h|--help)
    echo "${scriptname} usage:"
    echo ' -h | --help: show this help.'
    echo ' -l | --laptop: only use laptop display, turn off all others.'
    echo ' -n | --nolaptop | -m | --monitors: turn off laptop display, only use monitors.'
    echo ' -a | --all: use all displays.'
    exit 0
    ;;
    -l|--laptop)
    MODE="laptop"
    shift
    ;;
    -n|--nolaptop|-m|--monitors)
    MODE="monitors"
    shift
    ;;
    -a|--all)
    MODE="all"
    shift
    ;;
esac
done

# turn off all the displays first...
xrandr --output ${LAPTOP_DISPLAY} --off
xrandr --output ${LAB_DISPLAY1} --off
xrandr --output ${LAB_DISPLAY2} --off
xrandr --output ${DESK_DISPLAY1} --off
xrandr --output ${DESK_DISPLAY2} --off

if [ "${MODE}" = "all" ]; then
    echo "Attempting to use all displays..."
    if xrandr | grep -q "${LAB_DISPLAY1} connected"; then
        # lab workspace
        # should always be daisy chained....
        xrandr --output ${LAB_DISPLAY1} --auto
        xrandr --output ${LAB_DISPLAY2} --auto --right-of ${LAB_DISPLAY1}
        xrandr --output ${LAPTOP_DISPLAY} --auto --below ${LAB_DISPLAY1}
    elif xrandr | grep -q "${DESK_DISPLAY1} connected"; then
        # desk workspace
        xrandr --output ${DESK_DISPLAY1} --auto 
        xrandr --output ${DESK_DISPLAY2} --auto --left-of ${DESK_DISPLAY1}
        xrandr --output ${LAPTOP_DISPLAY} --auto --below ${DESK_DISPLAY2}
    else
        # no other displays...
        xrandr --output ${LAB_DISPLAY1} --off
        xrandr --output ${LAB_DISPLAY2} --off
        xrandr --output ${DESK_DISPLAY1} --off
        xrandr --output ${DESK_DISPLAY2} --off
        xrandr --output ${LAPTOP_DISPLAY} --auto
    fi
elif [ "${MODE}" = "laptop" ]; then
    echo "Attempting to use laptop display..."
    xrandr --output ${LAB_DISPLAY1} --off
    xrandr --output ${LAB_DISPLAY2} --off
    xrandr --output ${DESK_DISPLAY1} --off
    xrandr --output ${DESK_DISPLAY2} --off
    xrandr --output ${LAPTOP_DISPLAY} --auto
elif [ "${MODE}" = "monitors" ]; then 
    echo "Attempting to use monitors..."
    if xrandr | grep -q "${LAB_DISPLAY1} connected"; then
        # lab workspace
        # should always be daisy chained....
        xrandr --output ${LAB_DISPLAY1} --auto
        xrandr --output ${LAB_DISPLAY2} --auto --right-of ${LAB_DISPLAY1}
        xrandr --output ${LAPTOP_DISPLAY} --off
    elif xrandr | grep -q "${DESK_DISPLAY1} connected"; then
        # desk workspace
        xrandr --output ${DESK_DISPLAY1} --auto 
        xrandr --output ${DESK_DISPLAY2} --auto --left-of ${DESK_DISPLAY1}
        xrandr --output ${LAPTOP_DISPLAY} --off
    else
        echo "No other displays attached!"
    fi
fi
