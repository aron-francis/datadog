#!/bin/bash

INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query 'Reservations[*].Instances[*].InstanceId' --output text)
CPU_UTIL=$(aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name CPUUtilization --dimensions Name=InstanceId,Value=$INSTANCE_ID --start-time $(date -u -d '1 day ago' +%FT%TZ) --end-time $(date -u +%FT%TZ) --period 86400 --statistics Average --query 'Datapoints[0].Average' --output text)

if (( $(echo "$CPU_UTIL < 10.0" |bc -l) )); then
  aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID --instance-type "{\"Value\": \"t3.nano\"}"
fi

