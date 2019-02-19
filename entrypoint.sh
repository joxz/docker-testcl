#!/bin/sh

set -e

if [ "$1" = 'test' ]; then
  exec su-exec testcl jtcl /app/test/test_jtcl_irule.tcl

elif [ "$1" = 'test_irule' ]; then
  cd /app/test
  exec su-exec testcl jtcl /app/test/test_simple_irule.tcl

elif [ "$1" = 'makemeroot' ]; then
  exec ash

else
  exec su-exec testcl "$@"
fi