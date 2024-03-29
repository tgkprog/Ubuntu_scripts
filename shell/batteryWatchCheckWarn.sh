#!/bin/bash

# lots of help from https://askubuntu.com/a/603322/165511 how to call pssuspend without password and others...
#also thank you to other entries on if else for expressions, var increment...

#Script to make it run on start up, saved to $HOME/.config/autostart/batteryMonitor.desktop:
#[Desktop Entry]
#Type=Application
#Exec=/path/bin/batwatch.sh
#Hidden=false
#NoDisplay=false
#Name=Battery Monitor Script
#start up script end

#checking script
# Check if the battery is connected
if [ -e /sys/class/power_supply/BAT1 ]; then

    # this line is for debugging mostly. Could be removed
    #notify-send --icon=info "STARTED MONITORING BATERY"
    #zenity --warning --text "STARTED MONITORING BATERY"
RED='\033[0;31m'
NC='\033[0m' # No Color
warnFew=0
warnOnce=0
            CAPACITY_Full=$( cat /sys/class/power_supply/BAT1/uevent | grep -i capacity | cut -d'=' -f2 )
		
		((warnFew++))
		echo "Level complate :"$CAPACITY_Full " warn once int "$warnFew" warn once "$warnOnce
    while true;do   
            # Get the capacity and level
        CAPACITY_Full=$( cat /sys/class/power_supply/BAT1/uevent | grep -i capacity | cut -d'=' -f2 )

	CAPACITYarray=($CAPACITY_Full)
	#CAPACITYarray=[100,100]
	CAPACITY=${CAPACITYarray[0]}
	STATUS=$(  cat /sys/class/power_supply/BAT1/uevent | grep -i status | cut -d'=' -f2 )
	echo " Start while loop with status $STATUS; Capacity : $CAPACITY_Full"
        echo "Level :$CAPACITY; Status :$STATUS. Warn int :$warnFew.  Warn once :$warnOnce"
        echo "Me 	/home/t/code/github/ubu/batwatch.sh"
        if(($warnOnce<2)); then
        	 if [[ "$STATUS" == "Discharging" ]]; then
			((warnOnce++))
			if(($warnOnce==1)); then
	        		echo -n $'\eg';echo -n $'\a'
	        		ffplay -v 0 -nodisp -autoexit '/home/t/Music/battery discharging.flac' 
				ffplay -v 0 -nodisp -autoexit '/home/t/Music/battery discharging.flac' 
			
	        		notify-send -t 4 "Battery" "Is discharging"
	        		zenity --warning --text "Battery discharging, $CAPACITY%! (1)"

        		fi
	        fi
        fi
         
        if (($CAPACITY<=90 && $warnFew<30))   
        then
                if [[ "$STATUS" == "Discharging" ]]; then
	        	((warnFew++))
	        	if((((($warnFew%10))==2))); then
	        		echo "Discharging warn few is " $warnFew
	        		echo -n $'\eg';echo -n $'\a'
	        		ffplay -v 0 -nodisp -autoexit '/home/t/Music/battery discharging.flac' 	        		
	        		zenity --warning --text "battery discharging, $CAPACITY%!"

	        	fi
	        fi

        fi
        if (($CAPACITY>=30)); then  if [[ "$STATUS" != "Discharging" ]]; then
        	warnOnce=0;
        	warnFew=0;
        	echo "reset warns"
        fi; fi;
        if (($CAPACITY<8))
        then  
            #notify-send --urgency=critical --icon=dialog-warning "LOW BATTERY! SUSPENDING IN 30 sec"
             if [[ "$STATUS" == "Discharging" ]]
            then
	        echo -n $'\eg';echo -n $'\a'
	        ffplay -v 0 -nodisp -autoexit '/home/t/Music/lowbattery.flac'            
            	zenity --warning --text "Low battery! Suspending IN 20 sec"
            	
            	sleep 20
            	STATUS=$(  cat /sys/class/power_supply/BAT1/uevent | grep -i status | cut -d'=' -f2 )
            	if [[ "$STATUS" != "Discharging" ]]; then
            	
            		gnome-screensaver-command -l && sudo pm-suspend
            	else
            		echo "Not Discharging now, after sleep, so will not try to suspend. Status : $STATUS"
            	fi
            	
            else
            
            	echo "batery low but status $STATUS font-color:red"
            fi
        elif (($CAPACITY>=8 && $CAPACITY<=90))
        then 
        	echo "10s+ in if $CAPACITY"
        else
        	echo "ok charge"                    
        fi 
        echo "end if"
    sleep 10
    done
fi
