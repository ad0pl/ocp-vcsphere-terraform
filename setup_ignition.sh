#!/bin/bash

echo "Creating Manifests"
openshift-install create manifests --dir=install_dir/

if [ -d ./install_dir/manifests ]; then
	echo "Marking master pods as not receving work"
	sed -i 's/mastersSchedulable: true/mastersSchedulable: False/' install_dir/manifests/cluster-scheduler-02-config.yml
else
	echo "####\nERROR: Manifests were not created\n####\n"
	exit 1
fi

echo "Creating the ignition files"
openshift-install create ignition-configs --dir=install_dir/

echo "Copying ignition files over"
FILES="bootstrap.ign master.ign worker.ign metadata.json"
for FILE in ${FILES}; do
	if [ -f ./install_dir/${FILE} ]; then
		sudo install install_dir/${FILE} /var/www/html/okd4/${FILE}
		sudo chown apache:apache /var/www/html/okd4/${FILE}
		sudo chmod 755 /var/www/html/okd4/${FILE}
	else
		echo "####\n ERROR: ${FILE} missing.\n####"
		exit 1
	fi
done
echo "Ready for running terraform"
