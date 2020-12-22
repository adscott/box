#!/bin/bash

set -e

yum install -y docker docker-compose
groupadd docker
usermod -aG docker vagrant
systemctl enable docker
