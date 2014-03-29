# Specifying JMX settings
# Consider adding -Djava.rmi.server.hostname=<host ip>
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.port=9004 \
    -Dcom.sun.management.jmxremote.ssl=false \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Djava.rmi.server.hostname=$IP"