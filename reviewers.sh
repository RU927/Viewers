#!/bin/bash
git checkout master
git remote add upstream https://github.com/OHIF/Viewers.git
git fetch upstream
git checkout user
git merge upstream/master
git commit -m "merge master branch with user"
git remote add origin git@github.com:RU927/re_viewers.git
git push --set-upstream origin user

sudo apt install orthanc orthanc-dev orthanc-webviewer orthanc-wsi orthanc-dicomweb orthanc-gdcm orthanc-imagej orthanc-mysql orthanc-postgresql orthanc-python liborthancframework1 liborthancframework-dev

plugin_dir=/usr/share/orthanc/plugins
wget https://lsb.orthanc-server.com/plugin-ohif/mainline/libOrthancOHIF.so -P "$plugin_dir"
sudo cp libOrthancOHIF.so /usr/share/orthanc/plugins
sudo chmod +x $plugin_dir/libOrthancOHIF.so
