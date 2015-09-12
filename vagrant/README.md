# Vagrant environment for running this tutorial
This folder has [Vagrantfile](Vagrantfile) that starts Ubuntu 14.04 operating system in virtual environment and installs all required prerequisites automatically.

## Usage
```shell
vagrant up
vagrant ssh

git clone https://github.com/jnupponen/camel-deployment.git
cd camel-deployment
```

After that you can continue to follow [Different Deployments](#different-deployments).

**Note!** If asked password in Vagrant environment, the default password is 'vagrant'.

**Note!** There is no X window system installed so you must skip the part about running Camel in Eclipse.
