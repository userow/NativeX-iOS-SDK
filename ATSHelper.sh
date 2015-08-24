#!/bin/bash

# Copyright (c) 2015 NativeX, LLC. All rights reserved.

showUsage ()
{
    echo "ATSHelper.sh"
    echo "App Transport Security helper script"
    echo "Copyright (c) 2015 NativeX, LLC"
    echo ""
    echo "usage: "
    echo "   ./ATSHelper.sh --disable-ats path/to/your/app/info.plist"
    echo "        - Disables App Transport Security in the given info.plist file"
    echo "   ./ATSHelper.sh --whitelist-ats path/to/your/app/info.plist"
    echo "        - Whitelists NativeX's domains in the given info.plist file"
    echo ""
}

showError() { echo "-- ERROR: $1 ---"; }

#commandline var checks
if [ "$1" == "--disable-ats" ]; then
    ATSMODE=0
elif [ "$1" == "--whitelist-ats" ]; then
    ATSMODE=1
else
    showError "Unknown command: $1"
    showUsage
    exit
fi

if [ "$2" == "" ]; then
    # missing plist file
    showError "info.plist file not defined!"
    showUsage
    exit
fi

PLISTFILE=$2

#check plist file exists
if [ ! -f $PLISTFILE ]; then
    showError "cannot find file $PLISTFILE"
    showUsage
    exit
fi

#check for PlistBuddy
if [ ! -f /usr/libexec/PlistBuddy ]; then
    showError "Unable to find /usr/libexec/PlistBuddy application; you might need to apply App Transport Security exceptions manually.."
    exit
fi

# PlistBuddy helper functions
pbexist() {
    #echo "pbexist($1)"
    /usr/libexec/PlistBuddy -c "Print $1" $PLISTFILE &>/dev/null
    if [ "$?" == 0 ]; then
        PEX=1
    else
        PEX=0
    fi
}
pb() {
    #echo "pb($1)"
    /usr/libexec/PlistBuddy -c "$1" $PLISTFILE
}
pbAddDict() {
    #echo "pbAddDict($1)"
    pbexist $1
    if [ $PEX == 0 ]; then
        echo "adding $1 dict"
        pb "Add $1 dict"
    fi
}
pbSetAddBool() {
    #echo "pbSetAddBool($1 $2)"
    pbexist "$1"
    if [ $PEX == 1 ]; then
        echo "setting $1 = $2"
        pb "Set $1 $2"
    else
        echo "adding $1 = $2"
        pb "Add $1 bool $2"
    fi
}

#echo "plist file:$PLISTFILE"
#echo "atsmode=$ATSMODE"

if [ $ATSMODE == 0 ]; then
    echo "Disabling App Transport Security for $PLISTFILE:"

    # add NSAppTransportSecurity if it doesn't exist
    pbAddDict ":NSAppTransportSecurity"

    # add/set NSAllowsArbitraryLoads bool value to true
    pbSetAddBool ":NSAppTransportSecurity:NSAllowsArbitraryLoads" "true"

elif [ $ATSMODE == 1 ]; then
    echo "Whitelisting NativeX's domains, leaving App Transport Security to its existing value for $PLISTFILE"

    # add NSAppTransportSecurity if it doesn't exist
    pbAddDict ":NSAppTransportSecurity"
    # we're doing nothing with NSAllowsArbitraryLoads.. if they have it set already, don't change it..
    #pbSetAddBool ":NSAppTransportSecurity:NSAllowsArbitraryLoads" "true"

    # add NSExceptionDomains
    pbAddDict ":NSAppTransportSecurity:NSExceptionDomains"

    # whitelist appclick.co
    pbAddDict ":NSAppTransportSecurity:NSExceptionDomains:appclick.co"
    pbSetAddBool ":NSAppTransportSecurity:NSExceptionDomains:appclick.co:NSExceptionAllowsInsecureHTTPLoads" "true"
    pbSetAddBool ":NSAppTransportSecurity:NSExceptionDomains:appclick.co:NSIncludesSubdomains" "true"

    # whitelist nativex.com
    pbAddDict ":NSAppTransportSecurity:NSExceptionDomains:nativex.com"
    pbSetAddBool ":NSAppTransportSecurity:NSExceptionDomains:nativex.com:NSExceptionAllowsInsecureHTTPLoads" "true"
    pbSetAddBool ":NSAppTransportSecurity:NSExceptionDomains:nativex.com:NSIncludesSubdomains" "true"

    # whitelist w3i.com
    pbAddDict ":NSAppTransportSecurity:NSExceptionDomains:w3i.com"
    pbSetAddBool ":NSAppTransportSecurity:NSExceptionDomains:w3i.com:NSExceptionAllowsInsecureHTTPLoads" "true"
    pbSetAddBool ":NSAppTransportSecurity:NSExceptionDomains:w3i.com:NSIncludesSubdomains" "true"

else
    showError "Unknown command mode... Something is wrong!!"
    showUsage
    exit
fi

echo ""
echo "New NSAppTransportSecurity setting:"
pb "Print :NSAppTransportSecurity"
