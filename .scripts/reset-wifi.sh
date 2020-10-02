#!/bin/bash

cd /etc
sudo ln -sf /run/resolvconf/resolv.conf
sudo /etc/init.d/network-manager restart
cd -
