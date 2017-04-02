#!/bin/sh

cd ../model/
if ./build.sh ; then
  cd ../servlet/api
  if sudo javac -cp .:../../../lib/*:../../../classes/ *.java -d ../../../classes/ ; then
    cd ../pages
    if sudo javac -cp .:../../../lib/*:../../../classes/ *.java -d ../../../classes/ ; then
      #sudo service tomcat7 restart
      sudo /Library/Tomcat/bin/catalina.sh stop
      sudo /Library/Tomcat/bin/catalina.sh start
    fi
  fi
fi
    
