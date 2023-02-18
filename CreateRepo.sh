 #!/bin/bash

# https://mariushosting.com/synology-basic-command-lines-for-dsm-7/
# https://www.taniarascia.com/how-to-create-and-use-bash-scripts/
# https://gist.github.com/Nilpo/8ed5e44be00d6cf21f22

#Pre setup
<< 'MULTILINE-COMMENT'
    1. Install app "Git Server" to NAS.
    1.1 Add permission for users in "Git Server".
    2. Create folder "git" and setup permission for users.
    3. Open SSH acces to NAS.
    4. Create acess by SSH KEY
        https://gist.github.com/Nilpo/8ed5e44be00d6cf21f22
    
    5. Create task on NAS to startup site after NAS loaded.

MULTILINE-COMMENT

#projname="mysite"
echo "Enter Your project name"
read projname

echo "Enter branch name to checkout (master or main)"
# branch="master "
read branch


# Varieble
user="$(whoami)"
# host_name="$(hostname)"
host_name="$(ifconfig ovs_eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
port=${SSH_CLIENT##* }
gitfolderpath="/volume1/git"
webfolderpath="/volume1/web"
projname="testsite"
branch="main"




# Check 'git' directory to exist
if [ -d "$gitfolderpath" ] 
then
    echo "Directory $gitfolderpath exists." 

    # Setting up a Bare Repository 

    echo "Create git repo"
    git init --bare --shared $gitfolderpath/$projname.git
    # git config --global init.defaultBranch $branch
    git branch -m main


    echo "GIT_WORK_TREE=/volume1/web/testsite git checkout -qf" >> /volume1/git/testsite/hooks/post-receive
    echo "GIT_WORK_TREE=$webfolderpath/$projname git checkout -qf [--detach] [$branch]" >> $gitfolderpath/$projname.git/hooks/post-receive
    chmod +x $gitfolderpath/$projname.git/hooks/post-receive
    echo "File 'post-receive' created"

    # Edit Git config
    # echo '[remote "nas"] ' >> $gitfolderpath/$projname.git/config
    # echo "url = ssh://$user@$host_name:$port$gitfolderpath/$projname.git" >> $gitfolderpath/$projname.git/config
    # echo "fetch = +refs/heads/*:refs/remotes/nas/*" >> $gitfolderpath/$projname.git/config

    # echo "Config file modified"

    # Created folder for website
    mkdir $webfolderpath/$projname
    echo "Folder '$projname' for website created"


    # Setup file for PC

    echo 'Git Rero Created'
    # ssh://git@github.com:D6V6S/testsite.git

    # git remote add origin git@github.com:D6V6S/testsite.git
    # git branch -M main
    # git push -u origin main

    echo "git clone ssh://$user@$host_name:$port$gitfolderpath/$projname.git" >> $gitfolderpath/file.log
    # echo "git init" >> $gitfolderpath/file.log

    echo "git remote rename origin nas" >> $gitfolderpath/file.log
    echo "git remote add origin ssh://git@github.com:D6V6S/$projname.git" >> $gitfolderpath/file.log

    echo "ADD FILE TO PROJECT" >> $gitfolderpath/file.log
    echo "git add -A" >> $gitfolderpath/file.log
    echo "git commit -m 'first'" >> $gitfolderpath/file.log
    echo "git push -u nas master" >> $gitfolderpath/file.log


else
    echo "Error: Directory $gitfolderpath does not exists."
    echo "Plese: Pre setup."
    exit
fi

# …or create a new repository on the command line
# echo "# testsite" >> README.md
# git init
# git add README.md
# git commit -m "first commit"
# git branch -M main
# git remote add origin https://github.com/D6V6S/testsite.git
# git push -u origin main

# …or push an existing repository from the command line

# git remote add origin https://github.com/D6V6S/testsite.git
# git branch -M main
# git push -u origin main