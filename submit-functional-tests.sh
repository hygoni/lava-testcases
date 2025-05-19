#!/bin/bash

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

	hash=$(sha1sum _submit.yaml | cut -c 1-6)
	scp ./_submit.yaml hyeyoo@$LAVA_IP:/tmp/job-$hash.yaml
	ssh hyeyoo@$LAVA_IP "lavacli \
	--uri http://hyeyoo:$LAVA_TOKEN@localhost/RPC2/ jobs submit /tmp/job-$hash.yaml"
	ssh hyeyoo@$LAVA_IP "rm /tmp/job-$hash.yaml"

	rm _submit.yaml
done

echo done.
