#!/bin/sh

./bin/zeit_machine eval "Zeit.Release.migrate()"
./bin/zeit_machine start
