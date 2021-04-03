sleep 10
while true
do
    inotifywait -r ./ && pkill -HUP gunicorn
    sleep 5
done
