# bastion
Bastion is a wrapper for FreeBSD bastille - it's bastille templates on steroids and your templates are plain bash so you can DWTFYW !  No limits

Based on ideas from a similar script for Incus/LXD and Dockerfile, and frustration with the limitations of bastille templates, this script is born.

Supports all of the bastille CLI commands (not just a subset like bastille template) and as bastion just adds shell commands and your bastion build file is a bash shell script, you can put whatever logic in there that you like.
Works on the principle that a build file is focussed on one jail, therefore there is no need to repeat the jail name on every command like the bastille CLI commands.
Execute the command JAIL <jailname> and all bastille commands that take a jail name as the first parameter no longer need it
The bastille CLI keyword becomes uppercase, jail name as first parameter is ommitted, and all other parameters are the same as bastille CLI commands

Examples:
CREATE 14.1-RELEASE 10.0.0.1 bastille0
PKG install --yes samba416
STOP
DESTROY
