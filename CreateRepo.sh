 #!/bin/bash

echo "Enter Your project name"
read projname

# Variables
user="$(whoami)"
host_ip="$(ifconfig ovs_eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
port=${SSH_CLIENT##* }
gitfolderpath="/volume1/git"
webfolderpath="/volume1/web"
branch="master"
# host_name="$(hostname)"


# Check 'git' directory to exist
if [ -d "$gitfolderpath" ] 
then
    # Setting up a Repository 

    echo "Create git repo"
    git init --bare --initial-branch $branch --shared $gitfolderpath/$projname.git
       
    # Create 'post-receive' file.
    # echo "GIT_WORK_TREE=$webfolderpath/$projname git checkout -qf [--detach] [$branch]" >> $gitfolderpath/$projname.git/hooks/post-receive
    #GIT_WORK_TREE=$webfolderpath/$projname git checkout -qf
    echo "
    # the work tree, where the checkout/deploy should happen
    TARGET=\"$webfolderpath/$projname\"

    # the location of the .git directory
    GIT_DIR=\"$gitfolderpath/$projname.git\"

    branch=\"$branch\"

    while read oldrev newrev ref
    do
        # only checking out the master (or whatever branch you would like to deploy)
        if [ \"\$ref\" = \"refs/heads/\$branch\" ];
        then
                echo "Ref \$ref received. Deploying \$branch branch on server..."
                git --work-tree=\"\$TARGET\" --git-dir=\"\$GIT_DIR\" checkout -f \"\$branch\"
        else
                echo "Ref \$ref received. Doing nothing: only the \$branch branch may be deployed on this server."
        fi
    done
    
    " >> $gitfolderpath/$projname.git/hooks/post-receive
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
    echo \"Site '$projname' start at \$(date +'%F %T %Z')\" >> AutoStartLog.log
    " >> /volume1/git/scripts/$projname-autostart.sh

else
    echo "Error: Directory $gitfolderpath does not exists."
    echo "Plese: Pre setup."
    exit
fi
