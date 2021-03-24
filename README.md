# Overview
This repository contains tools used to build and deploy MedShorts/Medigi projects. It's purpose is to centralize our build system as much as possible.


# Setting up a new project

## Step One - Add build-tools as a submodule
Within your projects root folder you'll need to add the build-tools submodule.
```
$ git submodule add medshorts-github:medshorts-llc/build-tools
```

## Step Two - Implement build hooks
-----------
The build hooks are a series of shell scripts that the build system will call to execute different stages of the build process

**Examples of both front and backend hook scripts are located in `examples/`**

These hooks need to exist in your repo. They will be run by the build system on push.

```
$ mkdir build
$ cp build-tools/examples/backend/hooks/* build/
```

| Script | Purpose |
| ------ | ------- |
| build/pre_build.sh | Perform any setup actions prior to build |
| build/test.sh | Run tests prior to build
| build/build.sh | Builds the application |
| build/deploy.sh | Deploys the application |

Edit the scripts to customize to your project if needed.

## Step Three - Add github actions
-----------------------
Examples of both front and backend action scripts are loacted in `examples/`

```
$ mkdir -p .github/actions/workflows
$ cp build-tools/examples/backend/github/build.yml .github/actions/workflows
```

Edit build.yml to customize to your project if needed.

## Step Four - Setup Deploy Targets
The build system will read a file named `.deploy-targets.json` from your repo. This file contains mappings of branch names to deployments.

Examples of both front and backend are locations in `examples/`

```
$ cp examples/backend/.deploy-targets.json .
```
