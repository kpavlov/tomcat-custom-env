#!/bin/bash

mkdir -v ~/java

cd ~/java

wget http://mirrors.sonic.net/apache/tomcat/tomcat-7/v7.0.52/bin/apache-tomcat-7.0.52.tar.gz

tar -xf apache-tomcat-7.0.52.tar.gz

ln -s ~/java/apache-tomcat-7.0.52 ~/java/tomcat
