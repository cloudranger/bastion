# bastion

"A bastion is a structure projecting outward from the curtain wall of a fortification such as a bastille"

Bastion is a wrapper for FreeBSD bastille - it is bastille templates on steroids.
Your templates (build files)  are just plain bash so you can DWTFYW with no limits

Based on ideas from a similar script for Incus/LXD and Dockerfile, and frustration with the limitations of bastille templates, this script is born.

Supports all of the bastille CLI commands (not just a subset like bastille template) and as bastion just adds bastille commands to the shell, your bastion build file is just a bash script, so you can put whatever logic you want in there.

It works on the principle that a build file is focussed primarily on building one jail, therefore there is no need to repeat the jail name on every command like the bastille CLI commands.

Execute the command 'JAIL <jailname>' and all bastille commands that take a jail name as the first parameter no longer need it.
The bastille CLI keyword becomes uppercase, jail name as first parameter is ommitted, and all other parameters are the same as bastille CLI commands so are completely familiar

Examples:
 * CREATE 14.1-RELEASE 10.0.0.1 bastille0
 * PKG install --yes samba416
 * STOP
 * DESTROY

The bastille CLI command set is extended with a few additional commands for convenience
(to be documented)

Dependencies
 * bash
 * bashtools

Why create a dependency on bash ?

Bash is much richer than bourne shell and allows much more robust scripts to be written, such as local variables, readonly variables, arrays etc.
The scripts follow the google bash coding guidelines for maximin standardisation
Bastion makes use of bashtools which is of course written in bash
 
