#!/usr/bin/env bash
#Par exemple pour wirehark
export DISPLAY=:0.0
ssh -Y ec2-user@10.8.100.82
for i in {1..3} ; do bash -c "xclock &" ; done ;
