 #!/bin/bash

echo "Enter Your project name"
read projname

# Variables
user="$(whoami)"
host_ip="$(ifconfig ovs_eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
port=${SSH_CLIENT##* }
gitfolderpath="/volume1/git"
webfolderpath="/volume1/web"
branch="main"
# host_name="$(hostname)"


# Check 'git' directory to exist
if [ -d "$gitfolderpath" ] 
then
    # Setting up a Repository 

    echo "Create git repo"
    git init --bare --initial-branch main --shared $gitfolderpath/$projname.git
       
    # Create 'post-receive' file.
    # echo "GIT_WORK_TREE=$webfolderpath/$projname git checkout -qf [--detach] [$branch]" >> $gitfolderpath/$projname.git/hooks/post-receive
    echo "GIT_WORK_TREE=$webfolderpath/$projname git checkout -qf" >> $gitfolderpath/$projname.git/hooks/post-receive
    chmod +x $gitfolderpath/$projname.git/hooks/post-receive
    echo "File 'post-receive' created"  
   
    # Created folder for website

    mkdir $webfolderpath/$projname
    echo "Folder '$projname' for website created"

    echo "NAS Git Rero Created"

    # Setup file for PC

    echo " #!/bin/bash
    gh repo create $projname --public --clone

    #ADD 'README' FILE TO PROJECT

    echo \"Repo '$projname' \" >> ./$projname/README.md

    #Edit Git config Lihux

    echo '[remote \"nas\"]' >> ./$projname/.git/config
    echo '  url = ssh://$user@$host_ip:$port$gitfolderpath/$projname.git' >> ./$projname/.git/config
    echo '  fetch = +refs/heads/*:refs/remotes/nas/*' >> ./$projname/.git/config

    # First test commit, add 'README.md'
    cd $projname
    git add .
    git commit -m 'README'
    git push -u nas master
    git push -u origin master

    " >> $gitfolderpath/$projname-ForPC.sh

    echo "File for PC created - $gitfolderpath/$projname-ForPC.sh"

    # Setup file to autostart web site

    echo " #!/bin/bash
    cd $webfolderpath/$projname
    npm run start
    " >> /volume1/git/scripts/$projname-autostart.sh

else
    echo "Error: Directory $gitfolderpath does not exists."
    echo "Plese: Pre setup."
    exit
fi
