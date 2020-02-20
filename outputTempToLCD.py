#Python script to Output Dell server temperature to an LCD panel
#Running on Raspbery Pi, requires DellFanMonitor.sh
import I2C_LCD_driver
from time import *
import sys

mylcd = I2C_LCD_driver.lcd()

counter = open("/home/pi/Desktop/counter.txt", "r")

countervar = counter.readline()
temp = open("/home/pi/Desktop/temp.txt", "r")
tempvar = temp.read(2)

mylcd.lcd_display_string("HOST: ENTER-SERVER-NAME", 1)
mylcd.lcd_display_string(tempvar+" Degrees C", 2)
mylcd.lcd_display_string("Number of checks:",3)
mylcd.lcd_display_string("#" +countervar, 4)
