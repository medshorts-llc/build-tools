import sys
import json


def lookup_build_env_by_branch(branch_name):
    envs = None

    with open('.deploy-targets.json') as f:
        try:
            envs = json.loads(f.read()).get(branch_name)

            if envs and not isinstance(envs, list):
                envs = [envs]
        except ValueError:
            print_error('Malformed .deploy-targets.json')

    return envs


def write_build_env_files(branch_name):
    envs = lookup_build_env_by_branch(branch_name)

    if not envs:
        raise NoBuildEnvironmentFoundError('No build environment found for branch')

    for ix, env in enumerate(envs):
        write_build_env_file(env=env, index=ix)


def write_build_env_file(env, index):
    if 'K8S_NAME' in env:
        fname = f'api/.build.{env["K8S_NAME"]}.env'
    elif 'BUILD_PATH' in env:
        fname = f'{env["BUILD_PATH"]}/.build.{env["ANGULAR_CONFIG"]}.env'
    else:
        fname = f'medshorts-app/.build.{env["ANGULAR_CONFIG"]}.env'

    print(f'Conjuring {fname}...')
    with open(fname, 'w+') as f:
        for key in env:
            f.write(f'{key}={env[key]}\n')


class NoBuildEnvironmentFoundError(Exception):
    pass


def print_error(msg):
    print('ERROR: {msg}'.format(msg=msg), file=sys.stderr)


if __name__ == '__main__':
    try:
        branch = sys.argv[1]
        write_build_env_files(branch.replace('refs/heads/', ''))
    except NoBuildEnvironmentFoundError as e:
        print_error(str(e))
    except IndexError:
        print_error('Please specify branch name')
        exit(1)
