#Modified version of this:
#https://github.com/NoLooseEnds/Scripts/blob/master/R710-IPMI-TEMP/R710-IPMITemp.sh
#This keeps the cooling fans quiet on a Dell R710 server
#!/usr/bin/env bash

# ----------------------------------------------------------------------------------
# Script for checking the temperature reported by the ambient temperature sensor, 
# and if deemed to high send the raw IPMI command to enable dynamic fan control.
#
# Requires ipmitool – apt-get install ipmitool
# Tested on Ubuntu 17.04
# ----------------------------------------------------------------------------------


# IPMI DEFAULT R710 SETTINGS
# Modify to suit your needs.
IPMIHOST=192.1.1.1
IPMIUSER=root
IPMIPW=rootpassword

# TEMPERATURE
# Change this to the temperature in celcius you are comfortable with. 
# If it goes above it will send raw IPMI command to enable dynamic fan control
MAXTEMP=37

# This variable sends a IPMI command to get the temperature, and outputs it as two digits.
# Do not edit unless you know what you do.
TEMP=$(ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1)

file="/home/pi/Desktop/counter.txt"
read -d $'\x04' count < "$file"



if [[ $TEMP > $MAXTEMP ]];
  then
    printf "Temperature is too high! ($TEMP C) Activating dynamic fan control!" | systemd-cat -t R710-IPMI-TEMP
    echo "Temperature is too high! ($TEMP C) Activating dynamic fan control!"
    let "count++"
echo $count >"/home/pi/Desktop/counter.txt"
echo $TEMP >"/home/pi/Desktop/temp.txt"

    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x01
  else
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x09
    printf "Temperature is OK ($TEMP C)" | systemd-cat -t R710-IPMI-TEMP
    echo "Temperature is OK ($TEMP C)"
    let "count++"
echo $count >"/home/pi/Desktop/counter.txt"
echo $TEMP >"/home/pi/Desktop/temp.txt"

fi


