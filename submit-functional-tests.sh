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
	sed -i "s/TREE_NAME_VALUE/\"$TREE_NAME\"/g" _submit.yaml
	sed -i "s/GCOV_FILE_NAME_VALUE/\"$GCOV_FILE_NAME\"/g" _submit.yaml
	lavacli \
	--uri https://hyeyoo:$TOKEN@$HOST/RPC2/ jobs submit _submit.yaml \
	--timeout 1200
	rm _submit.yaml
done

echo done.
