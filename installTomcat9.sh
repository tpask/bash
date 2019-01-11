# installs Tomcat

tomcatUri="https://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.14/bin/apache-tomcat-9.0.14.tar.gz"
tarBall=`echo $tomcatUri |awk -F "/" '{print $NF}'`
tomcatVer=$(echo $tarBall |sed "s/\.tar\.gz//")

yum -y install java-1.8.0-openjdk-devel

useradd -m -U -d /opt/tomcat -s /bin/bash tomcat

wget $tomcatUri
if [ -f $tarBall ] ; then 
  tar -xvzf $tarBall
  mkdir -p /opt/tomcat
  mv $tomcatVer /opt/tomcat/
  ln -s /opt/tomcat/$tomcatVer /opt/tomcat/latest
  chown -R tomcat: /opt/tomcat
  chmod +x /opt/tomcat/latest/bin/*.sh
else
  echo "can't download tar file from $tomcatUri. tomcat not installed"
  exit 1
fi
#I have not had time to write a tomcat.service for systemctl that works correctly. 
#if you are able to write one that works for centos7 please share.
#make tomcat init.d
cat <<EOT > /etc/init.d/tomcat
#!/bin/bash
#
# tomcatd       Start Tomcat server
#
# chkconfig: - 80 20
# description: Tomcat Web Application Server
#
# processname: tomcat
# pidfile: /var/run/tomcat.pid

### BEGIN INIT INFO
# Provides: tomcat
# Required-Start: $network $syslog
# Required-Stop: $network $syslog
# Default-Start:
# Default-Stop:
# Short-Description: Start tomcat server
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

prog=tomcat
RETVAL=$?
lockfile=/var/lock/subsys/$prog

# Tomcat init Variables
# for additional tomcat config please use setenv

#CATALINA_HOME is the location of the bin files of Tomcat
export CATALINA_HOME="/opt/tomcat/latest"
#CATALINA_PID is the location of the PID file
export CATALINA_PID="/var/run/$prog.pid"
#TOMCAT_USER is the default user of tomcat
TOMCAT_USER=tomcat
#SHUTDOWN_VERBOSE Whether to annoy the user with "attempting to shut down" messages or not
SHUTDOWN_VERBOSE="false"
#SHUTDOWN_WAIT Time to wait in seconds, before killing process
SHUTDOWN_WAIT="20"

# Start of the script
start() {
    echo -n $"Starting $prog: "
    touch $CATALINA_PID
    chown $TOMCAT_USER $CATALINA_PID
    daemon --user $TOMCAT_USER "$CATALINA_HOME/bin/catalina.sh" start
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch $lockfile
    return $RETVAL
}

stop() {
    echo -n $"Shutting down $prog: "
    daemon --user $TOMCAT_USER "$CATALINA_HOME/bin/catalina.sh" stop
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f $lockfile
    return $RETVAL
}

rhstatus(){
    status -p "$CATALINA_PID" $prog
}

case $1 in
    start)
        start
    ;;
    stop)
        stop
    ;;
    restart)
        stop
        start
    ;;
    status)
        rhstatus
    ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
    ;;
esac
exit 0

EOT

# enable tomcat service
chkconfig --add tomcat
service tomcat start

