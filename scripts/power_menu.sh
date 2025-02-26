options="Shutdown\nExit sway"

choice=$(echo -e $options | rofi -dmenu -i -p "Power menu" -theme Arc-Dark -theme-str "listview { scrollbar: false; }" -font "mono 12")

case $choice in
	"Shutdown") poweroff ;;
	"Exit sway") sway exit ;;
esac
