#!/bin/bash
if ! which dialog > /dev/null; then
   echo -e "Command not found! Installing Dialog! \c"
   sudo apt-get install dialog
fi
if ! which nano > /dev/null; then
   echo -e "Command not found! Installing Nano. \c"
   sudo apt-get install nano
fi
if ! which nano > /dev/null; then
   echo -e "Command not found! Installing Lynx. \c"
   sudo apt-get install lynx
fi
if ! which htop > /dev/null; then
   echo -e "Command not found! Installing htop. \c"
   sudo apt-get install htop
fi
# Going to store temp nano files here for now
mkdir nano_temp
cd nano_temp/

INPUT=/tmp/menu.sh.$$

# get text editor or fall back to vi_editor
editor=/usr/bin/nano
browser=/usr/bin/lynx
processinfo=/usr/bin/htop
# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

#Date and time stuff TODO
DATE=date +"%m-%d-%y"

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

#
#Install Simple Linux Menu as default ssh screen when logging into remote console. 
#

function install_menu() {
mkdir -p ~/.menu
#Included both possiblities of using bash.
echo "~/.menu.sh" > ~/.bash_profile
echo "~/.menu.sh" > ~/.bashrc
cat menu.sh > ~/.menu.sh
dialog --clear --backtitle "Simple Linux Menu" $date \
--msgbox "Simple Linux Menu set as default ssh screen when logging in.\n You can now safely remove menu.sh, its new location is ~/.menu folder." 0 0
chmod +x ~/.menu.sh

main_menu

}

#
# Purpose.  Main Menu.
#

function main_menu() {

dialog --clear --backtitle "Simple Linux Menu" \
--title "[ MENU ]" \
--cancel-label "Exit" \
--menu "Simple Linux Menu. \n\
Please use the arrow keys to select an option." 20 70 6 \
Lynx "Lynx Simple Text Based Browser" \
Nano "Nano Text Editor" \
Disk "Disk Usage Information" \
HTOP "Process, cpu and memory information" \
Install "Install Menu as default bash screen" \
Exit "Exit to the shell" 2>"${INPUT}"
menuitem=$(<"${INPUT}")


# make decsion
case $menuitem in
	Lynx) $browser;;
	Nano) $editor;;
	Disk)         result=$(df -h / 2> /dev/null)
        display_result "Home Space Utilization (All Users)";;
	HTOP) $processinfo;;
	Install) install_menu;;
	Exit) clear; sleep 2; echo "Bye"; exit;;
esac


}


#
# set infinite loop
#
while true
do
### display main menu ###
main_menu
done
# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT

