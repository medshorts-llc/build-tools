#! /usr/bin/env bash


function load-environment {
    if [ "$ENV" = "development" ]; then
        . /app/.$ENV.env
    else
        echo "LOADING SECRETS"
        until python scripts/load_secrets.py; do
            echo "Loading secrets failed... retrying"
            sleep 10
        done

        . ./.secrets.env
    fi
}

function install-requirements {
    pip install bcrypt==3.2.0
    while ! pip install -r requirements.txt; do
        echo "Failed to install requirements.txt"
    done
}

function wait-for-mysql {
    MYSQL_HOST=$DB_SERVICE_HOST

    while ! mysqladmin --connect-timeout=2 ping -h"$MYSQL_HOST" --silent; do
        echo "Waiting for mysql..."
        sleep 1
    done
}

function create-database {
    if [ "$ENV" != "development" ]; then
        echo "Creating DB..."
        mysql -h"$MYSQL_HOST" -u"$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -e "CREATE DATABASE $MYSQL_DB" || true
    fi
}

function migrate-database {
    echo "Running db migrations..."
    cd /app
    flask db upgrade || true
}

function start-celery {
    if [[ -n $CELERY_APP ]]; then
        rm /tmp/da-beatus.pid /tmp/beatschedulerdb || true
        mkdir -p /var/log/celery
        mkdir -p /var/run/celery
        celery --app=$CELERY_APP worker -E --time-limit=1000 --loglevel=INFO --concurrency=2 --logfile=/var/log/celery/worker1%I.log --pidfile=/var/run/celery/worker1.pid --hostname=worker1@%h  &
        celery --app=$CELERY_APP beat --pidfile=/tmp/da-beatus.pid -s /tmp/beatschedulerdb -l INFO --logfile=/tmp/beat.log &
    fi
}

function start-service {
    if [ "$ENV" = "development" ]; then
        if [ -z "$KUBERNETES_SERVICE_HOST" ]; then
            echo "Running runserver.py..."
            python runserver.py
        else
            bash build-tools/watch-for-changes.sh &
        fi
    fi
}

load-environment
install-requirements

wait-for-mysql
create-database
migrate-database
start-celery
start-service
