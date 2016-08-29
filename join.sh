#!/bin/bash
/usr/bin/net ads join -U"$JOIN_USER"%"$JOIN_PASSWORD" -n "$HOSTNAME" -S "$DC"
