#!/bin/bash

# git checkout master
git remote add upstream https://github.com/OHIF/Viewers.git
git fetch upstream
git checkout user
git stash
# git stash -a save "message"
git merge upstream/master
git add .
git commit -am "merged upstream/master branch with user"
git remote add origin git@github.com:RU927/re_viewers.git
git remote set-head origin user
git push
git stash pop
# git stash pop stash@"{0}"

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

src_dir=~/src
plugin_dir=/usr/share/orthanc/plugins
mkdir -p $src_dir
wget https://lsb.orthanc-server.com/plugin-ohif/mainline/libOrthancOHIF.so -P "$src_dir"
sudo cp $src_dir/libOrthancOHIF.so $plugin_dir
sudo chmod +x $plugin_dir/libOrthancOHIF.so

config_dir=/etc/orthanc
this_dir_path="$(dirname "$(realpath "$0")")"
this_config="$(readlink -f "$0")"
fife_names=$(command ls "$this_dir_path/etc/orthanc")

for f in $fife_names; do
	sudo mv "$config_dir/$f" "$config_dir/$f".old
	sudo ln -svf "$this_dir_path$config_dir" "$config_dir"
done
sudo service orthanc restart
