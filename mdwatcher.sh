#!/bin/bash

# this_config="$(readlink -f "$0")"
this_dir_path="$(dirname "$(realpath "$0")")"
config_dir=/etc/orthanc
file_names=$(command ls "$this_dir_path/$config_dir")

ohif_sync_upstream() {
	# git checkout master
	git remote add upstream https://github.com/OHIF/Viewers.git
	git fetch upstream
	git checkout user
	git stash
	# git stash -a save "message"
	git merge upstream/master
	git add .
	git commit -am "merged upstream/master with user"
	git remote add origin git@github.com:chikh-chikh/md_watcher.git
	git remote set-head origin user
	git push
	git stash pop
	# git stash pop stash@"{0}"
}
ohif_sync_upstream

build_orthanc() {

	sudo apt install build-essential unzip cmake mercurial patch \
		uuid-dev libcurl4-openssl-dev liblua5.3-dev \
		libgtest-dev libpng-dev libsqlite3-dev libssl-dev libjpeg-dev \
		zlib1g-dev libdcmtk-dev libboost-all-dev libwrap0-dev \
		libcharls-dev libjsoncpp-dev libpugixml-dev locales protobuf-compiler

}

apt_orthanc() {
	sudo apt install \
		orthanc \
		orthanc-dev \
		orthanc-webviewer \
		orthanc-wsi \
		orthanc-dicomweb \
		orthanc-gdcm \
		orthanc-imagej \
		orthanc-mysql \
		orthanc-postgresql \
		orthanc-python \
		liborthancframework1 \
		liborthancframework-dev

}
# apt_orthanc

src_dir=~/src
plugin_dir=/usr/share/orthanc/plugins
wget_plugins() {
	mkdir -p $src_dir
	wget https://lsb.orthanc-server.com/plugin-ohif/mainline/libOrthancOHIF.so -P "$src_dir"
	sudo cp $src_dir/libOrthancOHIF.so $plugin_dir
	sudo chmod +x $plugin_dir/libOrthancOHIF.so

	for f in $file_names; do
		sudo mv "$config_dir/$f" "$config_dir/$f".old
		sudo ln -svf "$this_dir_path$config_dir/$f" "$config_dir/$f"
	done
	sudo service orthanc restart
}
