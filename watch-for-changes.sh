while true
do
    find . | grep -v .git | grep -v __pycache__ | grep .py > /tmp/watchfiles.txt
    inotifywait -e modify -e attrib -e move -e create -e delete --fromfile /tmp/watchfiles.txt && pkill -HUP gunicorn
    sleep 1
done
