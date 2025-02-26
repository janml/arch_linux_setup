# date +'%Y-%m-%d %X'

battery_status="BAT $(cat /sys/class/power_supply/BAT0/capacity)% ($(cat /sys/class/power_supply/BAT0/status))"
datetime="$(date +'%Y-%m-%d %X')"

# Print the status line
echo "$battery_status | $datetime"
