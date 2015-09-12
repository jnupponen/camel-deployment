# Vagrant environment for running this tutorial
This folder has [Vagrantfile](Vagrantfile) that starts Ubuntu 14.04 operating system in virtual environment and installs all required prerequisites automatically.

**Prerequisites:**
- Vagrant [http://www.vagrantup.com/downloads.html](http://www.vagrantup.com/downloads.html)
- VirtualBox [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

## Usage
```shell
git clone https://github.com/jnupponen/camel-deployment.git
cd camel-deployment/vagrant/
vagrant up
vagrant ssh
```
The *vagrant ssh* command will take you into virtual Ubuntu environment. Clone this repository into that environment also and you are ready to continue this tutorial:
```shell
git clone https://github.com/jnupponen/camel-deployment.git
cd camel-deployment
```

After that you can continue to follow [Different Deployments](https://github.com/jnupponen/camel-deployment#different-deployments).

**Note!** If asked password in Vagrant environment, the default password is 'vagrant'.

**Note!** There is no X window system installed so you must skip the part about running Camel in Eclipse.
