#!/bin/bash

#  to start

# sudo chmod +x /volume1/git/CreateAutoStart.sh
# sudo /volume1/git/CreateAutoStart.sh


# Variables
startScript="/usr/local/etc/rc.d/SiteAutoStart.sh"
# startScript="/volume1/git/SiteAutoStart.sh" #for test
websiteScriptDir="/volume1/git/scripts"

# Create dir for scripts

mkdir -p $websiteScriptDir

# Delete "SiteAutoStart.sh", if exist

rm -f $startScript

## Create Autostart for websites

echo "#!/bin/sh
case \$1 in
    start)
        # start all scripts in a folder
		for f in $websiteScriptDir/*.sh; do
			bash "\$f"
		done
		echo "Website scripts start"
    ;;
esac
exit 0" >> $startScript

## Make the script executable

sudo chmod +x $startScript

## Test the script to ensure it runs correctly

# sudo $startScript start
# sudo /volume1/git/SiteAutoStart.sh start

## If the script runs correctly, enable it to run on startup

sudo chmod 755 $startScript

## Create start server log script
rm -f $websiteScriptDir/AutoStartLog.sh

echo "#!/bin/sh
echo \"Server start - \$(date +'%F %T %Z')\" >> $websiteScriptDir/AutoStartLog.log
" >> $websiteScriptDir/AutoStartLog.sh
