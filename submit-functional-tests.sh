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
	sed -i "s/BUILD_ID_VALUE/${BUILD_ID//\//\\/}/g" _submit.yaml

	lavacli \
	--uri http://hyeyoo:$LAVA_TOKEN@lava.kerneltesting.org/RPC2/ jobs submit _submit.yaml
	rm _submit.yaml
done

echo done.
