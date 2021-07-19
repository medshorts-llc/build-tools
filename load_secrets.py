import boto3
import os
import json


def fetch_secret(secret_id):
    region_name = os.getenv('AWS_REGION')

    secrets = boto3.client(
        'secretsmanager',
        region_name=region_name
    ).get_secret_value(SecretId=secret_id)['SecretString']
    return json.loads(secrets)


if __name__ == '__main__':
    if os.getenv('ENV') != 'development':
        secrets = fetch_secret(secret_id=os.getenv('ENV_SECRET_NAME'))

        with open('/app/.secrets.env', 'w') as secrets_file:
            for key in secrets:
                secrets_file.write('export {key}={value}\n'.format(key=key, value=secrets[key]))

    api_secrets = fetch_secret(secret_id='internal-api-key-lower')
    with open('/app/.secrets.env', 'a') as secrets_file:
        for key in api_secrets:
            secrets_file.write('export {key}={value}\n'.format(key=key, value=api_secrets[key]))
