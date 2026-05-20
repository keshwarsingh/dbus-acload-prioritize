#!/bin/sh

BASE=$(dirname $(dirname $(realpath "$0")))

echo "Set up device service to autorun on restart"

chmod +x "$BASE/dbus_acload_prioritize.py"

awk -v base="$BASE" '{gsub(/\$\{BASE\}/,base);}1' \
    "$BASE/bin/service/run.tmpl" > "$BASE/bin/service/run"

chmod -R a+rwx "$BASE/bin/service"

rm -f /service/dbus-acload-prioritize
ln -s "$BASE/bin/service" /service/dbus-acload-prioritize &

cat > /data/rc.local <<EOF
ln -s $BASE/bin/service /service/dbus-acload-prioritize &
echo 1 > /proc/sys/net/ipv4/ip_forward
EOF

chmod +x /data/rc.local

echo "Setup dbus-acload-prioritize complete"
