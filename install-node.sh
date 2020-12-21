#!/bin/bash

#configuration
INSTALLDIR='/usr/local/lib/nodejs/'
OS='linux'
ARCH='x64'

#advanced configuration
DOWNLOAD='https://odejs.org/dist/latest/'
TAR='tar.xz'

#
PKGNAME='/node-v.*-'$OS'-'$ARCH'.'$TAR'/p'
NOECHO=/dev/null

lookup_latest_version(){
	echo 'Attempting to contact '$DOWNLOAD' for latest version of nodejs'
	NODE=$(curl -o - $DOWNLOAD | sed -n $PKGNAME | cut -d '"' -f2 | cut -f 1,2,3 -d '.')
	NODETAR=$NODE.$TAR
	[[ "$NODETAR" = ".$TAR" ]] \
		&& echo -e 'Failed while obtaining latest version of nodejs.\nInstallation aborted' \
		&& exit 1
	echo 'Found:' $NODETAR
}
download(){
	cd /tmp && \
	curl $DOWNLOAD''$NODETAR -o $NODETAR && \
	curl $DOWNLOAD''SHASUMS256.txt -o SHASUMS256.txt && \
	return $?
}
check_download(){
	cd /tmp && \
	echo 'Checking download integrity with checksum...' && \
	grep $NODETAR SHASUMS256.txt | sha256sum -c -
	return $?
}
make_install_dir(){
	echo 'Creating install directory' && \
	mkdir -p $INSTALLDIR && \
	echo 'Created at' $INSTALLDIR && \
	return $?
}
extract_download(){
	echo 'Extracting Tar...' && \
	tar xvf $NODETAR --directory $INSTALLDIR 1>$NOECHO && \
	echo 'Finished extracting nodejs files to' $INSTALLDIR && \
	return $?
}
remove_tmp(){
	echo 'Removing temporary files' && \
	rm /tmp/SHASUMS256.txt && \
	rm /tmp/$NODETAR && \
	return $?
}
make_symlinks(){
	echo 'updating binary symbolic links' && \
	rm /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/npx && \
	ln -s /usr/local/lib/nodejs/node-v15.4.0-linux-x64/bin/node /usr/local/bin/node && \
	ln -s /usr/local/lib/nodejs/node-v15.4.0-linux-x64/bin/npx /usr/local/bin/npx && \
	ln -s /usr/local/lib/nodejs/node-v15.4.0-linux-x64/bin/npm /usr/local/bin/npm&& \
	return $?
}
verify_install(){
	echo 'checking node versions' && \
	node -v && \
	echo 'checking npm and npx versions' && \
	npm -v && \
	npx -v && \
	return $?
}
install_complete(){
	echo 'Installation Complete'
}

# Execute
lookup_latest_version && \
download && \
check_download && \
make_install_dir && \
extract_download && \
verify_install && \
install_complete
[ $? -eq 1 ] && echo 'Installation Aborted'
