# Specifying JMX settings
# Consider adding -Djava.rmi.server.hostname=<host ip>
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.port=$JMX_PORT \
    -Dcom.sun.management.jmxremote.ssl=false \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Djava.rmi.server.hostname=$IP"