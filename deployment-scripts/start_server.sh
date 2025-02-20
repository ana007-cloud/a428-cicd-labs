#!/bin/bash -ex
cd /var/www/html
npm install
npm run build
npx serve -s build -l 3000 &
