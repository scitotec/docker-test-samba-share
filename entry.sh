#!/bin/bash

trap 'echo "bye"; kill -TERM $(jobs -p)' SIGTERM SIGINT

nginx -c /app/nginx.conf -g "daemon off;" &
samba.sh "$@" &

# wait for the next job to finish
wait -n
kill -TERM $(jobs -p)
