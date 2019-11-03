#!/bin/bash
if ! which dialog > /dev/null; then
   echo -e "Command not found! Install? (y/n) \c"
   read
   if "$REPLY" = "y"; then
      sudo apt-get install dialog
   fi
fi
if ! which nano > /dev/null; then
   echo -e "Command not found! Install? (y/n) \c"
   read
   if "$REPLY" = "y"; then
      sudo apt-get install nano
   fi
fi


INPUT=/tmp/menu.sh.$$

# get text editor or fall back to vi_editor
editor=/usr/bin/nano

# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM



#
#Install LSGSM as default ssh screen when logging into remote console. 
#

function install_menu() {
mkdir -p ~/.menu
#Included both possiblities of using bash.
echo "~/.menu.sh" > ~/.bash_profile
echo "~/.menu.sh" > ~/.bashrc
cat menu.sh > ~/.menu.sh
dialog --clear --backtitle "Simple Linux Menu" \
--msgbox "Simple Linux Menu set as default ssh screen when logging in.\n You can now safely remove menu.sh, its new location is ~/.menu folder." 0 0
chmod +x ~/.menu.sh

main_menu

}

function lynx() {
if ! which lynx > /dev/null; then
   echo -e "Lynx not found, installing. \c"
      sudo apt-get install lynx
fi

lynx

}
#
# Purpose.  Main Menu.
#

function main_menu() {

dialog --clear --backtitle "Simple Linux Menu" \
--title "[ MENU ]" \
--menu "Simple Linux Menu. \n\
Please use the arrow keys to select an option." 20 70 6 \
Lynx "Install packages need to use this script" \
MineOS "Install multiuser and administration commands" \
Single "Single user and administration commands" \
Install "Install this script as default ssh screen" \
Exit "Exit to the shell" 2>"${INPUT}"
menuitem=$(<"${INPUT}")


# make decsion 
case $menuitem in
	Lynx) lynx;;
	MineOS) mineos_menu;;
	Single) single_menu;;
	Install) install_lsgsm;;
	Exit) clear; sleep 2; echo "Bye"; exit;;
esac


}


#
#Purpose. MineOS install and admin menu.
#
function mineos_menu() {
dialog --clear --backtitle "Linux Shell Game Server Manager" \
--title "[ MineOS Menu ]" \
--menu "You can use the UP/DOWN arrow keys, the first \n\
letter of the choice as a hot key, or the \n\
number keys 1-9 to choose an option.\n\
Choose the TASK" 20 70 6 \
"Install MineOS" "Auto Installs MineOS - Requires SUDO!!" \
Backup "Backup Minecraft Servers" \
Start "Start Minecraft Servers" \
Stop "Stop Minecraft Servers" \
Editor "Start a text editor" \
Return "Return to Main Menu" 2>"${INPUT}"

menuitem=$(<"${INPUT}")


# make decsion 
case $menuitem in
	"Install MineOS") install_mineos;;
	Backup) backup_mc;;
	Start) start_mc;;
	Stop) stop_mc;;
	Editor) $editor;;
	Return) main_menu;;
esac


}

#
# Purpose. Single user setup and admin menu.
#
function single_menu() {
dialog --clear --backtitle "Linux Shell Game Server Manager" \
--title "[ Single User Menu ]" \
--menu "You can use the UP/DOWN arrow keys, the first \n\
letter of the choice as a hot key, or the \n\
number keys 1-9 to choose an option.\n\
Choose the TASK" 20 70 6 \
Install "Installs a single instance of vanilla mc to user directory" \
EULA "Accept the EULA required by Minecraft" \
Return "Return to Main Menu" 2>"${INPUT}"

menuitem=$(<"${INPUT}")


# make decsion 
case $menuitem in
	Install) install_vmc;;
	EULA) accept_eula;;
	Return) main_menu;;
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

