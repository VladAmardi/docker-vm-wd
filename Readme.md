# Docker-VM (www-data)

Little infrastructure for create virtual machine, built on the basis of docker-in-docker.
Has an integrated SSH server,
as well as a series of utilities for administrators
(such as git-client, htop, telnet, mtr and other).

## Configuration

### .env file
Available variables in the .env file:
```
HOST_NAME=virtual-machine
SSH_PORT=2224
WEB_PORT=80
````

### SSH
Content of /root/.ssh directory stored in the volume.
To modify keys, you may need to mount the volume to the host directory with the keys,
or enter to VM and edit it inside.
