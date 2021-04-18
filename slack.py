import requests
import json

# TODO: Regenerate and place in secrets manager
SLACK_TOKEN = 'xoxb-44312198678-1506365813828-RTKYelFGvBprCjWTGcLbis6N'
SLACK_API_URL = 'https://slack.com/api'


def send_message(channel, text):
    payload = {
        'channel': channel,
        'text': text
    }

    return make_request('/chat.postMessage', payload)

def make_request(endpoint, payload, method='post'):
    headers = {
        'Authorization': 'Bearer {token}'.format(token=SLACK_TOKEN),
        'Content-Type': 'application/json'
    }

    url = '{base_url}{endpoint}'.format(
        base_url=SLACK_API_URL,
        endpoint=endpoint
    )

    return getattr(requests, method)(
        url,
        headers=headers,
        data=json.dumps(payload)
    )

if __name__ == '__main__':
    import sys

    try:
        channel = sys.argv[1]
        message = sys.argv[2]
        send_message(channel=channel, text=message)
    except IndexError:
        print('You need at least a channel and a message')
