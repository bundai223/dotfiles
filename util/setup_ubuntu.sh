#! /bin/bash

PATH_TO_HERE=`dirname $0`
ABS_PATH=`cd $PATH_TO_HERE && pwd`
echo $ABS_PATH

sudo apt-get update
sudo apt-get install git ssh zsh

bash $ABS_PATH/setup.sh

