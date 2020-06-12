#!/bin/sh

cd phenoman_test
javac -cp phenoman-0.3.3.jar MIBE.java
java -cp "phenoman-0.3.3.jar:." MIBE
