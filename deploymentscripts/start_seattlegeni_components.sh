#!/bin/bash

# <Author>
#   Justin Samuel
# <Date Started>
#   August 13, 2009
# <Purpose>
#   This script will start the various components of SeattleGeni in the correct
#   order (namely, lockserver first, then backend, then the rest). It will also
#   gracefully restart apache. This script should be used rather than
#   stopping/starting components individually to ensure that all components use
#   a fresh lockserver after they have been restarted.
# <Usage>
#    As root, run:
#      ./start_seattlegeni_components.sh
#    Once started, the processes will not exit until its children have. To kill
#    all components of seattlegeni (except apache), send a SIGINT or SIGTERM to
#    this process.

export PYTHONPATH="/home/geni/live/:/home/geni/live/seattle:/usr/local/lib/python2.5/site-packages"
export DJANGO_SETTINGS_MODULE="seattlegeni.website.settings"

# The seattlegeni/ directory in the directory deployed to (by the deployment script)
SEATTLEGENI_DIR="/home/geni/live/seattlegeni"

# The directory that output to stdout/stderr will be logged to.
LOG_DIR="/home/geni/logs"

# A sude cmd to run processes as the user 'geni' with the correct environment
# variables for django.
SUDO_CMD="sudo -u geni PYTHONPATH=$PYTHONPATH DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE"

if [ "$USER" != "root" ]; then
  echo "You must run this script as root. Exiting."
  exit 1
fi

echo "Starting lockserver."
$SUDO_CMD python $SEATTLEGENI_DIR/lockserver/lockserver_daemon.py >>$LOG_DIR/lockserver.log 2>&1 &
sleep 1 # Wait a moment to make sure it has started (lockserver is used by other components).

echo "Starting backend."
$SUDO_CMD python $SEATTLEGENI_DIR/backend/backend_daemon.py >>$LOG_DIR/backend.log 2>&1 &
sleep 1 # Wait a moment to make sure it has started (backend is used by other components).

echo "Gracefully restarting apache."
apache2ctl graceful

echo "TODO: start node state transition scripts"

echo "All components started. Kill this process (CTRL-C or 'kill $$') to stop all started components (except apache)."


function shutdown() {
  echo "Shutting down seattlegeni components."
  # Tell kill to kill the process group (so, kill children) by giving a negative process id.
  # Note: "--" means the end of options
  kill -- -$$
}

# Wait for the user to CTRL-C or "kill this_pid".
trap "shutdown" SIGINT SIGTERM

# Wait for all background processes to terminate.
wait
