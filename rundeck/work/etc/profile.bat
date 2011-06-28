set RDECK_HOME=/tmp/rdeck

set RDECK_BASE=/tmp/rdeck

set JAVA_HOME=/usr/local/diablo-jdk1.6.0/jre

:: Unsetting JRE_HOME to ensure there is no conflict with JAVA_HOME
(set JRE_HOME=)

set Path=%JAVA_HOME%\bin;%RDECK_HOME%\tools\bin;%Path%

set RDECK_SSL_OPTS="-Djavax.net.ssl.trustStore=%RDECK_BASE%\etc\truststore -Djavax.net.ssl.trustStoreType=jks -Djava.protocol.handler.pkgs=com.sun.net.ssl.internal.www.protocol"