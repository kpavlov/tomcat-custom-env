#!/bin/bash

TOMCAT_VERSION=7.0.52

TOMCAT_FILE=apache-tomcat-$TOMCAT_VERSION

INSTALL_PATH=~/java

mkdir $INSTALL_PATH

cd $INSTALL_PATH

ENV_PATH=$INSTALL_PATH/custom-tomcat2

if [ ! -f $INSTALL_PATH/tomcat ]; then
	echo "Tomcat not found at $INSTALL_PATH/tomcat"
	if [ ! -f $TOMCAT_FILE.tar.gz ]; then
		echo "Downloading Tomcat binary"
    	wget http://mirrors.sonic.net/apache/tomcat/tomcat-7/v$TOMCAT_VERSION/bin/$TOMCAT_FILE.tar.gz
    fi
    echo "Extracting Tomcat binary to $INSTALL_PATH/$TOMCAT_FILE"
    tar -xf $TOMCAT_FILE.tar.gz
    ln -s $INSTALL_PATH/$TOMCAT_FILE $INSTALL_PATH/tomcat
else 
	echo "Tomcat found at $INSTALL_PATH/tomcat"
fi

mkdir -p $ENV_PATH/{bin,conf,logs,work,webapps,temp}

cp -v $INSTALL_PATH/tomcat/conf/server.xml $INSTALL_PATH/tomcat/conf/tomcat-users.xml $ENV_PATH/conf/

echo "Execute: export CATALINA_BASE=$ENV_PATH"

echo "Then run tomcat with command: $INSTALL_PATH/tomcat/bin/catalina.sh run"


