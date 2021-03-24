#!/bin/bash

cd /app/medshorts-app

if [ ! -d "/app/medshorts-app/node_modules" ]; then
    npm install
    node --max_old_space_size=8196 node_modules/@angular/compiler-cli/ngcc/main-ngcc.js --properties es2015 es5 browser module main --first-only --create-ivy-entry-points
fi

ng serve --host 0.0.0.0 --configuration $ANGULAR_CONFIG