#!/bin/bash
###########################
# provision jenkins on k8s
###########################

# vars
: ${CONFIG_BRANCH:=master}
: ${CONFIG_DEST:=/tmp/jenkins-config}
: ${CONFIG_BASE:=$CONFIG_DEST/jenkins_config}
: ${DEFAULT_PLUGIN_FP:=/tmp/default_jenkins_plugins}
: ${CUSTOM_PLUGINS:=plugins}
: ${CUSTOM_MAIN_CONFIG:=config.xml}
: ${CONFIG_REPO:=https://github.schq.secious.com/Logrhythm/lr-kubernetes.git}
: ${CUSTOM_PLUGIN_FP:=$CONFIG_BASE/$CUSTOM_PLUGINS}
: ${CUSTOM_CONFIG_FP:=$CONFIG_BASE/$CUSTOM_MAIN_CONFIG}
: ${CUSTOM_JOBS_PATH:=$CONFIG_BASE/jobs}
: ${JENKINS_WD:=/var/jenkins_home}

# functions
installPlugins() {
    less $1 | tr '\n' ' ' | /usr/bin/install_jenkins_plugins.sh
}

# bootstrap container
mkdir -p $CONFIG_DEST

# install basic plugins
if [ -f $DEFAULT_PLUGIN_FP ]; then
    echo "found default jenkins plugins, installing:"
    cat $DEFAULT_PLUGIN_FP
    installPlugins $DEFAULT_PLUGIN_FP
fi

# clone configuration repository
git clone $CONFIG_REPO $CONFIG_DEST
cd $CONFIG_DEST
git checkout $CONFIG_BRANCH
cd -

# check for custom plugins
if [ -f $CUSTOM_PLUGIN_FP ]; then
    echo "found custom jenkins plugins. installing:"
    cat $CUSTOM_PLUGIN_FP
    installPlugins $CUSTOM_PLUGIN_FP
fi

# provision jenkins server with stored configuration
if [ -f $CUSTOM_CONFIG_FP ]; then
    cp $CUSTOM_CONFIG_FP $JENKINS_WD
fi

if [ -f $CUSTOM_JOBS_PATH ]; then
    cp -R $CUSTOM_JOBS_PATH/* $JENKINS_WD/jobs/
fi
