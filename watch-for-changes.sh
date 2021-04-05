sleep 10
while true
do
    inotifywait -r ./**/*.py && pkill -HUP gunicorn
    sleep 5
done
