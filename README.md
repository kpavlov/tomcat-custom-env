tomcat-custom-env
=================

Tomcat Custom Configuration Example.

# Establishing Customizable Tomcat Configuration

Deploying to [Apache Tomcat](http://tomcat.apache.org) often requires making changes to default configuration. 
These changes are often environment specific.
Also, when upgrading a Tomcat to new version you need to be sure that all your custom changes have not been lost and were applied to new configuration.

To deal with all that stuff Tomcat via separation of the configuration.

Here is a step-by-step instruction how to establish custom tomcat configuration.

## 1. Installing tomcat
You download Tomcat distribution binary and extract it to some folder.
I put it to `~/java/apache-tomcat-7.0.52`.
It is desirable to create a symlink to it. It would allow to switch to another version of tomcat without changing your scripts
    
    ln -s ~/java/apache-tomcat-7.0.52 ~/java/tomcat
    
As alternative, you may install a tomcat from packages.

## 2. Create a folder to keep your custom configuration

1. Create a folder where you custom configuration will be located.
  
    mkdir -p ~/java/custom-tomcat/{bin,conf,logs,work,webapps,temp}

2. Copy default `server.xml`, `tomcat-users.xml` configuration file to custom location. If you already have a customized `server.xml` then put it there
         
	cp -v ~/java/tomcat/conf/server.xml ~/java/tomcat/conf/tomcat-users.xml ~/java/custom-tomcat/conf/

3. Set system property `$CATALINA_BASE` referring to base directory for resolving dynamic portions of a Catalina installation. 
   
     export CATALINA_BASE="~/java/custom-tomcat"

Now you can start the Tomcat and see that it uses your custom configuration folder:

    $ ./catalina.sh run
    Using CATALINA_BASE:   /Users/maestro/java/custom-tomcat 
    Using CATALINA_HOME:   /Users/maestro/java/tomcat
    Using CATALINA_TMPDIR: /Users/maestro/java/custom-tomcat/temp
    ...
 
## 3. Tomcat runtime parameters customization
 
To specify JVM options to be used when tomcat server is run, create a bash script `$CATALINA_BASE/bin/setenv.sh`. 
It will keep environment variables referred in `catalina.sh` script to keep your customizations separate.

Define `$CATALINA_OPTS` inside `setenv.sh`.  Include here and not in JAVA_OPTS all options, that should only be used by Tomcat itself, not by the stop process, the version command etc. Examples are heap size, GC logging, JMX ports etc.

Example `setenv.sh`:

    echo "Setting parameters from $CATALINA_BASE/bin/setenv.sh"
    echo "_______________________________________________"
    
    export CATALINA_OPTS="$CATALINA_OPTS -Xms1024m"

    export CATALINA_OPTS="$CATALINA_OPTS -Xmx1025m"
    
    export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxPermSize=256m"
    
    export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseParallelGC"
    
    export CATALINA_OPTS="$CATALINA_OPTS -server"
    
    export CATALINA_OPTS="$CATALINA_OPTS -XX:+DisableExplicitGC"
    
    # Check for application specific parameters at startup
    if [ -r "$CATALINA_BASE/bin/appenv.sh" ]; then
      . "$CATALINA_BASE/bin/appenv.sh"
    fi
     
    echo "Using CATALINA_OPTS:"
    for arg in $CATALINA_OPTS
    do
        echo ">> " $arg
    done
    echo ""
     
    echo "Using JAVA_OPTS:"
    for arg in $JAVA_OPTS
    do
        echo ">> " $arg
    done
    
    echo "_______________________________________________"
    echo ""
        

 
## 4. Migrate logging to Logback

Tomcat is configured to use Apache Commons Logging API by default.
If you are using [slf4j][slf4j] in your application and familiar with [Logback][logback], then it is reasonable to migrate your tomcat configuration to logback too.


## Links

- http://hwellmann.blogspot.com/2012/11/logging-with-slf4j-and-logback-in.html
- https://gist.github.com/terrancesnyder/986029 - example setenv.sh with defaults set for minimal time spent in garbage collection
- http://terranceasnyder.com/2011/05/tomcat-best-practices/ - Tomcat Best Practices
 

  [slf4j]: http://slf4j.org
  [logback]: http://logback.qos.ch
