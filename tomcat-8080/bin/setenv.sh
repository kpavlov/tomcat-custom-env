echo "Setting parameters from $CATALINA_BASE/bin/setenv.sh"
echo "_______________________________________________"

# Default Ports
export HTTP_PORT=8080
export HTTPS_PORT=8443
export AJP_PORT=8009
export SHUTDOWN_PORT=8005

# The hotspot server JVM has specific code-path optimizations
# which yield an approximate 10% gain over the client version.
export CATALINA_OPTS="$CATALINA_OPTS -server"

# discourage address map swapping by setting Xms and Xmx to the same value
# http://confluence.atlassian.com/display/DOC/Garbage+Collector+Performance+Issues
export CATALINA_OPTS="$CATALINA_OPTS -Xms512m -Xmx512m"

# Increase maximum perm size for web base applications to 4x the default amount
# http://wiki.apache.org/tomcat/FAQ/Memoryhttp://wiki.apache.org/tomcat/FAQ/Memory
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxPermSize=256m"

# Oracle Java as default, uses the serial garbage collector on the
# Full Tenured heap. The Young space is collected in parallel, but the
# Tenured is not. This means that at a time of load if a full collection
# event occurs, since the event is a 'stop-the-world' serial event then
# all application threads other than the garbage collector thread are
# taken off the CPU. This can have severe consequences if requests continue
# to accrue during these 'outage' periods. (specifically webservices, webapps)
# [Also enables adaptive sizing automatically]
export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseParallelGC"

# This is interpreted as a hint to the garbage collector that pause times
# of <nnn> milliseconds or less are desired. The garbage collector will
# adjust the  Java heap size and other garbage collection related parameters
# in an attempt to keep garbage collection pauses shorter than <nnn> milliseconds.
# http://java.sun.com/docs/hotspot/gc5.0/ergo5.html
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxGCPauseMillis=1500"

# Verbose GC
export CATALINA_OPTS="$CATALINA_OPTS -verbose:gc"
export CATALINA_OPTS="$CATALINA_OPTS -Xloggc:$CATALINA_BASE/logs/gc.log"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+PrintGCDetails"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+PrintGCDateStamps"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+PrintGCApplicationStoppedTime"

# Disable remote (distributed) garbage collection by Java clients
# and remove ability for applications to call explicit GC collection
export CATALINA_OPTS="$CATALINA_OPTS -XX:+DisableExplicitGC"

# Prefer IPv4 over IPv6 stack
export CATALINA_OPTS="$CATALINA_OPTS -Djava.net.preferIPv4Stack=true"

# Set Java Server TimeZone to UTC
export CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=UTC"

# IP ADDRESS OF CURRENT MACHINE
if hash ip 2>&-
then
    IP=`ip addr show | grep 'global eth[0-9]' | grep -o 'inet [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+' | grep -o '[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+'`
else
    IP=`ifconfig | grep 'inet [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+.*broadcast' | grep -o 'inet [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+' | grep -o '[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+'`
fi

# Check for application specific parameters at startup
if [ -r "$CATALINA_BASE/bin/appenv.sh" ]; then
  . "$CATALINA_BASE/bin/appenv.sh"
fi

# Specifying JMX settings
if [ -z $JMX_PORT ]; then
    echo "JMX Port not specified. JMX interface disabled.\n"
else
	echo "JMX interface is enabled on port $JMX_PORT\n"
    # Consider adding -Djava.rmi.server.hostname=<host ip>
	export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote \
	    -Dcom.sun.management.jmxremote.port=$JMX_PORT \
	    -Dcom.sun.management.jmxremote.ssl=false \
	    -Dcom.sun.management.jmxremote.authenticate=false \
	    -Djava.rmi.server.hostname=$IP"
fi

# Export ports
export CATALINA_OPTS="$CATALINA_OPTS -Dport.http=$HTTP_PORT"
export CATALINA_OPTS="$CATALINA_OPTS -Dport.shutdown=$SHUTDOWN_PORT"
export CATALINA_OPTS="$CATALINA_OPTS -Dport.https=$HTTPS_PORT"
export CATALINA_OPTS="$CATALINA_OPTS -Dport.ajp=$AJP_PORT"

export JAVA_ENDORSED_DIRS="$CATALINA_BASE/endorsed:$CATALINA_HOME/endorsed"

export CLASSPATH="$CATALINA_BASE/lib/jul-to-slf4j-1.7.6.jar:$CLASSPATH"  
export CLASSPATH="$CATALINA_BASE/lib/slf4j-api-1.7.6.jar:$CLASSPATH" 
export CLASSPATH="$CATALINA_BASE/lib/logback-classic-1.1.1.jar:$CLASSPATH"  
export CLASSPATH="$CATALINA_BASE/lib/logback-core-1.1.1.jar:$CLASSPATH"

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
