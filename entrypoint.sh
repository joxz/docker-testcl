#!/bin/sh

set -e

if [ "$1" = 'test' ]; then
  exec jtcl /opt/test/test_jtcl_irule.tcl

elif [ "$1" = 'test_irule' ]; then
  cd /opt/test
  exec jtcl /opt/test/test_simple_irule.tcl

else
  exec "$@"
fi
