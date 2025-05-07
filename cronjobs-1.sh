#!/bin/bash

# Select date using Zenity calendar picker and store into a variable
selected_date=$(zenity --calendar --title="Select Date" --date-format="%Y-%m-%d")
if [ -z "$selected_date" ]; then
    zenity --error --text="No date selected. Exiting."
    exit 1
fi

# Select time (12-hour format) with zenity using --entry with HH:MM format and store into a variable
selected_time=$(zenity --entry --title="Select Time" --text="Enter time in HH:MM format (12-hour):")
if [[ ! "$selected_time" =~ ^(0[1-9]|1[0-2]):[0-5][0-9]$ ]]; then
    zenity --error --text="Invalid time format. Exiting."
    exit 1
fi

# Select AM or PM with zenity --list and check to make sure it was selected
am_pm=$(zenity --list --title="Select AM or PM" --column="Option" "AM" "PM")
if [ -z "$am_pm" ]; then
    zenity --error --text="No AM/PM selected. Exiting."
    exit 1
fi

# Convert 12-hour time to 24-hour time
hour=$(echo "$selected_time" | cut -d':' -f1)
minute=$(echo "$selected_time" | cut -d':' -f2)
if [ "$am_pm" == "PM" ] && [ "$hour" -ne 12 ]; then
    hour=$((hour + 12))
elif [ "$am_pm" == "AM" ] && [ "$hour" -eq 12 ]; then
    hour=0
fi

# Select script file using zenity and store it in a variable
script_file=$(zenity --file-selection --title="Select Script File")
if [ -z "$script_file" ]; then
    zenity --error --text="No script file selected. Exiting."
    exit 1
fi

# Ask if the scheduled script needs DISPLAY and XAUTHORITY variables
use_display=$(zenity --question --text="Does the script need DISPLAY and XAUTHORITY variables?" --ok-label="Yes" --cancel-label="No")
if [ $? -eq 0 ]; then
    display="DISPLAY=:0"
    xauthority="XAUTHORITY=/home/$USER/.Xauthority"
else
    display=""
    xauthority=""
fi

# Select repetition schedule using Zenity --list
repetition=$(zenity --list --title="Select Repetition Schedule" --column="Option" "Once a day" "Once a week" "Once a month" "Once a year")
if [ -z "$repetition" ]; then
    zenity --error --text="No repetition schedule selected. Exiting."
    exit 1
fi

# Calculate day and month for the initial run
day=$(date -d "$selected_date" '+%d')
month=$(date -d "$selected_date" '+%m')
weekday=$(date -d "$selected_date" '+%u')

# Use a case to define cron job schedule based on user's selection
case "$repetition" in
    "Once a day")
        cron_schedule="$minute $hour * * *"
        ;;
    "Once a week")
        cron_schedule="$minute $hour * * $weekday"
        ;;
    "Once a month")
        cron_schedule="$minute $hour $day * *"
        ;;
    "Once a year")
        cron_schedule="$minute $hour $day $month *"
        ;;
    *)
        zenity --error --text="Invalid repetition schedule. Exiting."
        exit 1
        ;;
esac

# Add the cron job
cron_command="$display $xauthority bash $script_file"
(crontab -l 2>/dev/null; echo "$cron_schedule $cron_command") | crontab -

# Show confirmation
zenity --info --text="Cron job successfully added!"
