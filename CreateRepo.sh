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
    6. Inftall "npm install pm2 -g"
    7. Create Git repo on GitHub
    8. Copy Scrypt to NAS. "chmod +x CreateRepo.sh" + "/volume1/git/CreateRepo.sh"

MULTILINE-COMMENT

echo "Enter Your project name"
read projname
# projname="mysite"

# echo "Enter branch name to checkout (master or main)"
# read branch
# branch="main"


# Variables
user="$(whoami)"
host_ip="$(ifconfig ovs_eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
port=${SSH_CLIENT##* }
gitfolderpath="/volume1/git"
webfolderpath="/volume1/web"
branch="main"
# projname="testsite"
# host_name="$(hostname)"


# Check 'git' directory to exist
if [ -d "$gitfolderpath" ] 
then
    # Setting up a Bare Repository 

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

    # Setup file for PC

    echo 'NAS Git Rero Created'

    # Script to create Git Rero on GitHub - next version
    # https://github.com/cli/cli#installation
    # https://cli.github.com/manual/gh_repo_create

    echo "#Install and connect 'GitHub CLI'" >> $gitfolderpath/$projname.log
    
    echo "gh repo create $projname --public --clone" >> $gitfolderpath/$projname.log
    
    echo "#ADD 'test' FILE TO PROJECT" >> $gitfolderpath/$projname.log
    echo '"This is a test" >> ./$projname/Testfile.txt' >> $gitfolderpath/$projname.log

    # Edit Git config Lihux
    echo "#Edit Git config Lihux" >> $gitfolderpath/$projname.log

    echo "echo '[remote 'nas']' >> ./$projname/.git/config" >> $gitfolderpath/$projname.log
    echo "echo 'url = ssh://$user@$host_ip:$port$gitfolderpath/$projname.git' >> ./$projname/.git/config" >> $gitfolderpath/$projname.log
    echo "echo 'fetch = +refs/heads/*:refs/remotes/nas/*' >> ./$projname/.git/config" >> $gitfolderpath/$projname.log

    # Edit Git config Windows
    echo "#Edit Git config Windows" >> $gitfolderpath/$projname.log

    echo "Add-Content $projname\.git\config '[remote 'nas']'" >> $gitfolderpath/$projname.log
    echo "Add-Content $projname\.git\config 'url = ssh://$user@$host_ip:$port$gitfolderpath/$projname.git' " >> $gitfolderpath/$projname.log
    echo "Add-Content $projname\.git\config 'fetch = +refs/heads/*:refs/remotes/nas/*' " >> $gitfolderpath/$projname.log

    echo "cd $projname" >> $gitfolderpath/$projname.log
    echo "git add ." >> $gitfolderpath/$projname.log
    echo "git commit -m 'first'" >> $gitfolderpath/$projname.log
    echo "git push -u nas master" >> $gitfolderpath/$projname.log
    echo "git push -u origin master" >> $gitfolderpath/$projname.log


else
    echo "Error: Directory $gitfolderpath does not exists."
    echo "Plese: Pre setup."
    exit
fi
