#!/bin/bash

TOMCAT_VERSION=7.0.52

TOMCAT_FILE=apache-tomcat-$TOMCAT_VERSION

INSTALL_PATH=~/java

mkdir $INSTALL_PATH

cd $INSTALL_PATH

if [ ! -f $INSTALL_PATH/tomcat ]; then
    wget http://mirrors.sonic.net/apache/tomcat/tomcat-7/v$TOMCAT_VERSION/bin/$TOMCAT_FILE.tar.gz
    tar -xf $TOMCAT_FILE.tar.gz
    ln -s $INSTALL_PATH/$TOMCAT_FILE $INSTALL_PATH/tomcat
fi

mkdir -p $INSTALL_PATH/custom-tomcat/{bin,conf,logs,work,webapps,temp}

cp -v $INSTALL_PATH/tomcat/conf/server.xml $INSTALL_PATH/tomcat/conf/tomcat-users.xml $INSTALL_PATH/custom-tomcat/conf/


