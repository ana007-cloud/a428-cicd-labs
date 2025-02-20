#!/bin/bash -ex
cd /var/www/html
npx serve -s build -l 3000 > /dev/null 2>&1 &
