#!/bin/sh

APP_VOLUME=${APP_VOLUME:-/app_sync}
HOST_VOLUME=${HOST_VOLUME:-/host_sync}
OWNER_UID=${OWNER_UID:-0}

# http://www.cis.upenn.edu/~bcpierce/unison/download/releases/stable/unison-manual.html#fastcheck
# Unison can sometimes fail to transfer a file, giving the unhelpful message "Destination updated during synchronization"
# even though the file has not been changed. This can be caused by programs that change either the file's contents or
# the file's extended attributes without changing its modification time. It's not clear what is the best fix for this –
# it is not Unison's fault, but it makes Unison's behavior puzzling – but at least Unison can be more helpful about
# suggesting a workaround (running once with fastcheck set to false). The failure message has been changed to give this
# advice.

echo "Start recovery sync state with unison using fastcheck=false" >> /tmp/unison.log
# we use ruby due to http://mywiki.wooledge.org/BashFAQ/050
time ruby -e '`unison #{ENV["UNISON_ARGS"]} #{ENV["UNISON_SYNC_PREFER"]} #{ENV["UNISON_EXCLUDES"]} -numericids -auto -times -fastcheck false /host_sync /app_sync -logfile /tmp/unison.log`'
echo "Finish recovery sync state with using unison fastcheck=false" >> /tmp/unison.log

