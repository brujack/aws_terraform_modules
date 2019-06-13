#!/bin/bash
# HOSTNAME
echo "Setting hostname to ${instance_hostname}"
hostname ${instance_hostname}
echo "${instance_hostname}" > /etc/hostname
