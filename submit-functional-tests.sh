#!/bin/bash

# Get environment variables
TOKEN=$(cat ./env/jenkins.token)
HOST=$(cat ./env/jenkins.host)

if [ -z "$KERNEL" ]; then
	echo No '$KERNEL' variable set
	exit 1
fi

# Run all functional tests
for job in $(ls ./lava-jobs-functional/*.yaml);
do
	echo Submitting $job...
	sed "s/KERNEL/${KERNEL//\//\\/}/g" $job > _submit.yaml
	lavacli \
	--uri http://hyeyoo:$TOKEN@$HOST/RPC2/ jobs submit _submit.yaml
	rm _submit.yaml
done

echo done.
