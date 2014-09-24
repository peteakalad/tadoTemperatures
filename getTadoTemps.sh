#!/bin/sh
#login using sessions/token
# ** Replace YOUR_USERNAME and YOUR_PASSWORD below with your Tado credentials **
wget --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" --keep-session-cookies --post-data="j_username=YOUR_USERNAME&j_password=YOUR_PASSWORD" https://my.tado.com/j_spring_security_check --save-cookies /tmp/tadocookie.txt -O /tmp/tadologin.out > /dev/null 2>&1
#Get the thermostat settings xml (inc temperatures)
wget --header="Content-Type: application/x-www-form-urlencoded; charset=UTF-8" --header="X-Requested-With: XMLHttpRequest" --load-cookies /tmp/tadocookie.txt https://my.tado.com/mobile/1.4/getThermostatSettings -O /tmp/tadotemps.xml > /dev/null 2>&1
#Get out the temps from the xml
THERMOSTAT_TEMP=$(cat /tmp/tadotemps.xml | jq -r '.temperatures.externalTempSensor')
CONTROL_BOX_TEMP=$(cat /tmp/tadotemps.xml | jq -r '.temperatures.box')
#Print out temps to 1 decimal place
printf "Kitchen: %0.1f°C\n" $CONTROL_BOX_TEMP
printf "Living Room: %0.1f°C\n" $THERMOSTAT_TEMP
