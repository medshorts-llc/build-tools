while true
do
    inotifywait -e modify -e attrib -e move -e create -e delete --exclude '.*(\.pyc)' -r ./ && pkill -HUP gunicorn
    sleep 1
done
