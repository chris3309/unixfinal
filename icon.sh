#!/bin/bash

# Use Zenity to prompt user to select the script (.sh file) to run and store in a variable


# If no script is selected, exit


# Use Zenity to prompt user to select an image to use as the icon and store in a variable


# If no image is selected, exit



# Use Zenity to prompt user to enter a name for the desktop entry and store in a variable


# If no name is entered, use a default name


# Define the path for the .desktop file (in the current directory) and store in a variable


# Create the .desktop file using echo commands
# You can echo the content with the variables that you created
# using all the variables that were stored for path
# and zenity. The first line will be redirected >
# the following lines will be added with >>


# Copy the .desktop file to the user's desktop


# Make the .desktop file executable


# Use Zenity to notify user that the .desktop file has been created and moved
#!/bin/bash

# Prompt user to select the script (.sh file) to run
script_path=$(zenity --file-selection --title="Select Script to Run" --file-filter='*.sh')

# If no script is selected, exit
if [ -z "$script_path" ]; then
    zenity --error --text="No script selected. Exiting."
    exit 1
fi

# Prompt user to select an image to use as the icon
icon_path=$(zenity --file-selection --title="Select Icon Image" --file-filter='*.png *.jpg *.jpeg *.svg *.ico')

# If no image is selected, exit
if [ -z "$icon_path" ]; then
    zenity --error --text="No icon selected. Exiting."
    exit 1
fi

# Prompt user to enter a name for the desktop entry
desktop_name=$(zenity --entry --title="Desktop Entry Name" --text="Enter name for the desktop entry:")

# If no name entered, use default name
if [ -z "$desktop_name" ]; then
    desktop_name="MyDesktopEntry"
fi

# Define path for .desktop file
desktop_file="$(pwd)/${desktop_name}.desktop"

# Create .desktop file
echo "[Desktop Entry]" > "$desktop_file"
echo "Type=Application" >> "$desktop_file"
echo "Name=$desktop_name" >> "$desktop_file"
echo "Exec=bash '$script_path'" >> "$desktop_file"
echo "Icon=$icon_path" >> "$desktop_file"
echo "Terminal=true" >> "$desktop_file"

# Copy .desktop file to desktop
cp "$desktop_file" "$HOME/Desktop/"

# Make .desktop file executable
chmod +x "$HOME/Desktop/${desktop_name}.desktop"

# Notify user
zenity --info --text="Desktop entry '$desktop_name' has been created and moved to the Desktop."
