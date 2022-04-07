#!/bin/bash
while true
do
sudo -E kubectl port-forward svc/my 80:80 --address='0.0.0.0'
sleep 2
done
