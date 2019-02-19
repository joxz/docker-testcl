#!/bin/sh

set -e

if [ "$1" = 'test' ]; then
  exec su-exec testcl jtcl /opt/test/test_jtcl_irule.tcl

elif [ "$1" = 'test_irule' ]; then
  cd /opt/test
  exec su-exec testcl jtcl /opt/test/test_simple_irule.tcl

elif [ "$1" = 'makemeroot' ]; then
  exec ash

else
  exec su-exec testcl "$@"
fi