#!/bin/bash
sudo -E kubectl port-forward svc/my 80:80 --address='0.0.0.0'
