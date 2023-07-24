#!/bin/sh
echo ">building image..."
sudo docker build -t $1 .
echo ">verifying images..."
sudo docker images
echo ">done."
