#!/bin/bash -ex
cd /var/www/html
npx serve -s build -l 3000 &
