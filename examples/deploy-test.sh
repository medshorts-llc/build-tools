#!/usr/bin/env bash

git fetch
git branch -D ms2.0/qa
git push origin --delete ms2.0/qa
git checkout $1
git pull origin $1
git checkout -b ms2.0/qa
git pull origin develop
cp .deploy-targets-test.json .deploy-targets.json
git add .deploy-targets.json
git commit -m "Test deploy"
git push origin ms2.0/qa