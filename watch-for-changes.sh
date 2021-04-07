sleep 10
while true
do
    inotifywait --event modify --event attrib --event move --event create --event delete -r ./**/*.py && pkill -HUP gunicorn
    sleep 5
done
