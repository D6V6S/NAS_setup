# Create Git repository on Synology NAS

# PRE SET UP

## NAS

0. Lan cable mast be connected to first ethernet port(eth0).
1. Install app "Git Server" to NAS. Add permission for users in "Git Server".
2. Create folder "git" and set up permission for users.
3. Open SSH access to NAS. You can change the standard port (22) to your own.
4. Create access by [SSH KEY](https://gist.github.com/Nilpo/8ed5e44be00d6cf21f22#setting-up-passwordless-ssh-access-).
    - [Setup SSH Authentication for Git Bash on Windows](https://gist.github.com/bsara/5c4d90db3016814a3d2fe38d314f9c23)
5. Connect to server by SSH and install [PM2](https://www.npmjs.com/package/pm2) by command "sudo npm install pm2 -g".
6. Copy Scripts to NAS, make executable.
    - "/volume1/git/CreateRepo.sh" + "sudo chmod +x CreateRepo.sh"
    - "/volume1/git/CreateAutoStart.sh" + "sudo chmod +x CreateAutoStart.sh"
7.  Run script "CreateAutoStart.sh"
    - "sudo /volume1/git/CreateAutoStart.sh"

## PC

1. Install and set up [GitHub CLI](https://github.com/cli/cli#installation) on PC.

# USE

1. Start script on NAS "/volume1/git/CreateRepo.sh".
2. Enter name of new project.
    - Created file "*project name*-ForPC.sh"
    - Created file "*project name*-autostart.sh" in folder "/volume1/git/scripts", to start web site when NAS will be reboot.
3. Copy file "/volume1/git/*project name*-ForPC.sh" to PC projects folder.
4. Run script "*project name*-ForPC.sh"
    - Created and copy new *public* repository on GitHub with name "*project name*";
    - Created "README.md" file;
    - Add connect info about NAS to Git config file; 
    - Make first commit and push to NAS (git push -u nas master) and GitHub (git push -u origin master).

# Links
```
https://mariushosting.com/synology-basic-command-lines-for-dsm-7/
https://www.taniarascia.com/how-to-create-and-use-bash-scripts/
https://gist.github.com/Nilpo/8ed5e44be00d6cf21f22
https://gist.github.com/bsara/5c4d90db3016814a3d2fe38d314f9c23
```