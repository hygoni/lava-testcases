#!/bin/bash

# Get environment variables
TOKEN=$(cat ./env/jenkins.token)
HOST=$(cat ./env/jenkins.host)

# Run all functional tests
for job in $(ls ./lava-jobs-functional/*.yaml);
do
	echo Submitting $job...
	cp $job _submit.yaml
	
	lavacli \
	--uri http://hyeyoo:$TOKEN@$HOST/RPC2/ jobs submit _submit.yaml
	rm _submit.yaml
done

echo done.
