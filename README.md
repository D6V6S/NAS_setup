# PRE SETUP

## NAS

0. Lan cable mast connected to first ethernet port(eth0).
1. Install app "Git Server" to NAS. Add permission for users in "Git Server".
2. Create folder "git" and setup permission for users.
3. Open SSH access to NAS.
4. Create access by [SSH KEY](https://gist.github.com/Nilpo/8ed5e44be00d6cf21f22#setting-up-passwordless-ssh-access-).
5. Install "sudo npm install pm2 -g"
6. Copy Scripts to NAS, make executable.
    - "/volume1/git/CreateRepo.sh" + "sudo chmod +x CreateRepo.sh"
    - "/volume1/git/CreateAutoStart.sh" + "sudo chmod +x CreateAutoStart.sh"
7.  Run script "CreateAutoStart.sh"
    - "sudo /volume1/git/CreateAutoStart.sh"

## PC

1. Install and connect [GitHub CLI](https://github.com/cli/cli#installation) on PC.

# USE

1. Start script on NAS "sudo /volume1/git/CreateRepo.sh".
2. Enter name of new project.
3. Copy file "/volume1/git/*projname*-ForPC.sh" to PC projects folder.
4. Run script "*projname*-ForPC.sh"

# Links
```
https://mariushosting.com/synology-basic-command-lines-for-dsm-7/
https://www.taniarascia.com/how-to-create-and-use-bash-scripts/
https://gist.github.com/Nilpo/8ed5e44be00d6cf21f22
```
