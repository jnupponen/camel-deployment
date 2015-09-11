# Camel Deployment
This project demonstrates different ways to run and deploy Camel routes. The app itself is a simple Spring-based Camel route that prints greetings based on configured Camel Properties. There are comments on the [pom.xml](pom.xml) so you know which part is responsible for each command. You don't have to read every part, just read [At first](#at-first) and then you can skip to a part that interests you.

  * [At first](#at-first)
  * [Different Deployments](#different-deployments)
    * [Run Camel route in command line](#run-camel-route-in-command-line)
    * [Run Camel route in Eclipse IDE](#run-camel-route-in-eclipse-ide)
    * [Run Camel route as a standalone Java application](#run-camel-route-as-a-standalone-java-application)
    * [Deploy Camel route in Apache Karaf as OSGi bundle](#deploy-camel-route-in-apache-karaf-as-osgi-bundle)
      * [Deploy Camel route in Apache Karaf as OSGi bundle, the long version](#deploy-camel-route-in-apache-karaf-as-osgi-bundle-the-long-version)
    * [Deploy Camel route in Heroku](#deploy-camel-route-in-heroku)
    * [Deploy Camel route in Docker](#deploy-camel-route-in-docker)
  * [Configuring Camel routes with Camel Properties in each deployment](#configuring-camel-routes-with-camel-properties-in-each-deployment)
    * [Choosing which configuration to use in Docker and Heroku](#choosing-which-configuration-to-use-in-docker-and-heroku)
    * [Choosing which configuration to use in Karaf](#choosing-which-configuration-to-use-in-karaf)
  * [At the End](#at-the-end)


## At first
**Prerequisites:** Running these deployment examples requires you to have at least following software installed
- Java JDK 7 or Java JDK 8
- Maven 3
- Git
 
Linux operating system is assumed but the process is probably similar (but not exactly the same) on other OSes.

Clone this repository and change into cloned directory.
```shell
git clone git@github.com:jnupponen/camel-deployment.git
cd camel-deployment
```
or
```shell
git clone https://github.com/jnupponen/camel-deployment.git
cd camel-deployment
```

## Different Deployments
### Run Camel route in command line
There are two options: first one is to use [exec-maven-plugin](http://www.mojohaus.org/exec-maven-plugin/) like this
```shell
mvn compile exec:java
```
and the other option is using [camel-maven-plugin](http://camel.apache.org/camel-maven-plugin.html) like this
```shell
mvn clean camel:run
```
The difference between these two is that that exec-maven-plugin requires that you have class with main-method and have configured it to exec-maven-plugin in pom.xml like this
```xml
<mainClass>com.example.MainApp</mainClass>
```
The camel-maven-plugin doesn't need [MainApp.java](src/main/java/com/example/MainApp.java) since the plugin creates automatically similar main-method where it runs the route.


### Run Camel route in Eclipse IDE
First you must import the camel-deployment project into Eclipse like this
- Right click Project Explorer and click **Import...**
- Select **Existing Maven project** and click **next**
- Click **Browse**, open **camel-deployment** folder and click **OK**
- pom.xml should be already selected so click **Finish**

Then you can run route in Eclipse by double-clicking MainApp.java in the Project Explorer and clicking **Run** button from the command line (circled red in the image). After that you see Camel route starting in your Eclipse Console. 

![How to run in Eclipse](https://s3-eu-west-1.amazonaws.com/camel-deployment/eclipse.png "Eclipse IDE")


### Run Camel route as a standalone Java application
By using [maven-assembly-plugin](http://maven.apache.org/plugins/maven-assembly-plugin/) Maven is able to group all required dependencies into one large jar file which can be then executed everywhere where Java Runtime Environment is available. You can use this option like this
```shell
mvn clean package
java -jar target/*-jar-with-dependencies.jar
```
If you copy the jar file that was created to any environment where you have JRE installed you can run your Camel route with that single *'java -jar \<file>'* line above.

### Deploy Camel route in Apache Karaf as OSGi bundle
You can package Camel routes as OSGi bundles with [maven-bundle-plugin](http://felix.apache.org/documentation/subprojects/apache-felix-maven-bundle-plugin-bnd.html). OSGi bundles can be deployed into OSGi container such as [Apache Karaf](http://karaf.apache.org/). I've created a helper script that will install Karaf into camel-deployment folder and deploy this project to it. You can get started by
```shell
mvn clean install
bash deploy-to-karaf.sh
apache-karaf/bin/client
```
If you get "Failed to get the session" error when you put in *apache-karaf/bin/client* command then just wait a bit and try again. Karaf is not just fully started yet. When you are able to connect (after 10 seconds maybe) you will be greeted with Karaf console like this:
```
        __ __                  ____      
       / //_/____ __________ _/ __/      
      / ,<  / __ `/ ___/ __ `/ /_        
     / /| |/ /_/ / /  / /_/ / __/        
    /_/ |_|\__,_/_/   \__,_/_/         

  Apache Karaf (3.0.4)

Hit '<tab>' for a list of available commands
and '[cmd] --help' for help on a specific command.
Hit 'system:shutdown' to shutdown Karaf.
Hit '<ctrl-d>' or type 'logout' to disconnect shell from current session.

karaf@root()> 
```
Input this command to view the Camel route in Karaf logs in real time
```
karaf@root()> log:tail
```

#### Deploy Camel route in Apache Karaf as OSGi bundle, the long version
If you are curious what just happened or want to make the similar steps by hand then here they are.
- First download, extract, start and connect to Karaf:
```shell
mvn clean install
wget http://www.nic.funet.fi/pub/mirrors/apache.org/karaf/3.0.4/apache-karaf-3.0.4.tar.gz -O apache-karaf.tar.gz
mkdir apache-karaf
tar xvf apache-karaf.tar.gz --strip 1 -C apache-karaf/
apache-karaf/bin/start
apache-karaf/bin/client
```
- Then in Karaf shell insert Camel feature repository url, install camel-core and camel-spring features, and finally install our own camel-deployment-bundle. The '-s' parameter in 'bundle:install' means that bundle will be started after installation.
```
karaf@root()> feature:repo-add mvn:org.apache.camel.karaf/apache-camel/2.15.3/xml/features
karaf@root()> feature:install camel-core
karaf@root()> feature:install camel-spring
karaf@root()> bundle:install -s mvn:com.example/camel-deployment-bundle/1.0-SNAPSHOT
karaf@root()> log:tail
```
What is different here compared to the [deploy-to-karaf.sh](deploy-to-karaf.sh) script is that the script is using for convenience deployable [Karaf archive](https://karaf.apache.org/manual/latest/users-guide/kar.html) file [lib/camel-deployment-karaf-dependencies-kar-1.0-SNAPSHOT.kar](lib/camel-deployment-karaf-dependencies-kar-1.0-SNAPSHOT.kar) that installs camel-core and camel-spring features so one don't have input those commands by hand. Also the script installs compiled bundle from target folder where as this method installs the same bundle from local Maven repository.

If you are interested in the Kar archive used then you can see the source in [camel-deployment-kar](https://github.com/jnupponen/camel-deployment-kar) project.

### Deploy Camel route in Heroku
Heroku is company that offers Platform-as-a-Service runtimes for different programming languages. You must register first (registering is free and running this example won't cost you anything). Sign up in here [https://www.heroku.com/](https://www.heroku.com/). After that you must install Heroku toolbelt. Here is guide for Debian family of Linuxes but you can check for other platforms here [https://toolbelt.heroku.com/](https://toolbelt.heroku.com/).

Change *\<arbitrary-application-name>* with name of your own, e.g. "my-cool-camel-heroku-deployment". Also if you don't live in Europe you can consider using another region than 'eu' (the default is 'us').
```shell
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
heroku login
heroku create <arbitrary-application-name> --region eu
mvn clean heroku:deploy
heroku ps:scale worker=1        # Start the Heroku instance (dyno)
heroku logs --tail
```
If you would rather use *'git push heroku master'* deployment then there is option and guide for that in [**Procfile**](Procfile).

### Deploy Camel route in Docker
[Docker](https://www.docker.com/) in a container service that runs on top of Linux (kind of like a virtual machine but without the virtualization). If you want to deploy your Camel routes in Docker container you must set up Docker first like this (this guide is for Ubuntu 14.04, for other platforms see [https://docs.docker.com/installation/](https://docs.docker.com/installation/)).
```shell
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER        # Allows you to run Docker without sudo.
exec su -l $USER                     # Will refresh user group so no logout needed.
```
Then you can create and deploy your Camel route in Docker using [docker-maven-plugin](https://github.com/spotify/docker-maven-plugin) like this
```shell
mvn clean package docker:build
docker run -t -i example
```

## Configuring Camel routes with Camel Properties in each deployment
There is simple configuration included to this example because setting environment specific variables is something that comes across a lot. The example uses [Camel Properties Component](http://camel.apache.org/properties.html) that is shipped with camel-core. The route in this example is as simple as this
```java
// Print happy greeting every five seconds.
// To who depends on Camel Properties with key 'friend'.
from("timer://mytimer?period=5s")
    .log("Hello, {{friend}}!");
```
Camel Properties component is configured as follows
```xml
<bean id="properties" class="org.apache.camel.component.properties.PropertiesComponent">
    <property name="location" value=
    "classpath:dev.properties,
    classpath:${env:RUN_PROPERTIES}.properties,
    file:${karaf.home}/etc/com.example.cfg"/>
    <property name="ignoreMissingLocation" value="true"/>
</bean>
```
So by default Camel will use [dev.properties](src/main/resources/dev.properties) and the output of the route is 
```
Hello, me!
``` 

If there is Environment variable RUN_PROPERTIES set like this
```shell
export RUN_PROPERTIES=prod
```
then the Camel tries to read [prod.properties](src/main/resources/prod.properties) from the classpath. Please note that resolving Camel properties is not dynamic so you must restart Camel which ever way you where running it if you have changed the properties.

The third definition *file:${karaf.home}/etc/com.example.cfg* is Karaf and OSGi ConfigurationAdmin specific. If there is *karaf.home* JVM environment variable set Camel will read configuration from there (and it is set when you run Karaf in JVM).

### Choosing which configuration to use in Docker and Heroku
In Docker you can start the container image with '-e' parameter that will pass environment variables to the container like this
```shell
docker run -e RUN_PROPERTIES=prod -t -i example
```

In Heroku you can set environment variables like this
```shell
heroku config:set RUN_PROPERTIES=prod
heroku logs --tail
```

After these changes you see the output of the route changing to
```
Hello, you!
``` 

### Choosing which configuration to use in Karaf
Karaf will also use RUN_PROPERTIES environment variable if it is set but there is also other possibility with Karaf.
 
The *karaf.home* JVM variable points to Karaf installation directory which in our example is something like */home/<user>/camel-deployments/apache-karaf/* depending where you cloned this project. In Karaf's *etc* folder every '.cfg' ending file is considered to hold Key-Value-properties and OSGi ConfigurationAdmin will make those properties available for OSGi bundles.

So if you create file etc/com.example.cfg with line like this
```
friend = Camel
```
and input this command to Karaf console
```
karaf@root()> bundle:refresh camel-deployment-bundle
karaf@root()> log:tail
```
you see that route starts printing "Hello, Camel!". Nice thing about this etc/com.example.cfg file is that if you are using [Hawtio](http://hawt.io/getstarted/index.html) for managing your Karaf installation then you can access that file from Hawtio web interface.


## At the End
This project is supposed to be as a starting point if you are wondering how to deploy your Camel application to various systems. The example is not too complex by design but there is still enough to get you started. I've included the use of Properties Component because it is something you probably need right on in the real life. I also wanted to use Spring to configure CamelContext since that is something that will get you a long way especially with OSGi bundles when you don't have to add components, type converters, etc by hand in CamelContext.
