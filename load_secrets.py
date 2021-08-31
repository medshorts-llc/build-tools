import boto3
import os
from glob import glob
import json


def fetch_k8s_secrets():
    with open('/app/.secrets.env', 'w') as f:
        for secret_file in glob('/app/secrets/*'):
            with open(secret_file) as s:
                value = s.read().strip('"')
                f.write(f'export {secret_file.split("/")[-1]}={value}\n')


if __name__ == '__main__':
    fetch_k8s_secrets()
