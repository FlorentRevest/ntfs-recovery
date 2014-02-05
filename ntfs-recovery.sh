#! /bin/bash

# Copyright © 2014 Florent Revest <florent.revest666@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING file for more details.

copydir()
{
    mkdir -p $3                                                    # Create destDir if it doesn't exist
    IFS=$'\n'                                                      # Used to parse the ntfsls output

    for file in $(sudo ntfsls -F -f $1 -p $2); do                  # For each entries of the dir
        if [ "${file: -1:1}" = "/" ]; then                         # Check if it is a directory
            if [ "$file" != "./" ] && [ "$file" != "../" ]; then   # And if it is a subdirectory
                echo -e "\033[33mEnter subdirectory:" $2\/${file%/} "\033[0m"
                copydir $1 $2\/${file%/} $3\/${file%/}             # Explore it recursively
            fi
        else                                                       # Else (if it's just a file)
            echo "Copy:" $file
            sudo ntfscat -q $1 $2\/$file > $3\/$file               # Copy it
            if [ $? != 0 ] -o [ ! -e $1 ]; then                    # If it fails and the device is unmounted
                echo -e "\033[31mFatal error when copying" $file "wait five second for the remount of the device\033[0m"
                sleep 5                                            # Wait for the remount
            fi
        fi
    done
}

if [ $# -ne 3 ]; then                                               # Check the command usage
    echo "Usage: `basename $0` deviceFile deviceDir destinationDir"
    echo "Example: `basename $0` /dev/sdb1 Users/usr/Pictures Pictures-backup"
    exit $E_BADARGS
fi

if [ ! -e $1 ]; then                                                # Check the presence of the device file
    echo "Error:" $1 " doesn't exist"
    exit $E_BADARGS
fi

copydir $1 ${2%/} ${3%/}                                            # Start the copy loop

