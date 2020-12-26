#!/bin/bash

#configuration
INSTALLDIR='/usr/local/lib/nodejs/'
OS='linux'
ARCH='x64'

#advanced configuration
DOWNLOAD='https://nodejs.org/dist/latest/'
TAR='tar.xz'
BIN='/usr/local/bin/'

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
	NODELIB=$INSTALLDIR''$NODE'/bin/'
	echo 'updating binary symbolic links' && \
	rm $BIN'node' $BIN'npm' $BIN'npx'
	ln -s $NODELIB'node' $BIN'node' && \
	ln -s $NODELIB'npx' $BIN'npx' && \
	ln -s $NODELIB'npm' $BIN'npm' && \
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
make_symlinks && \
verify_install && \
install_complete
[ $? -eq 1 ] && echo 'Installation Aborted'
