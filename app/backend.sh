#!/bin/bash

while IFS="=" read -r key value; do
  export "$key"="$value"
done < <(azd env get-values)

echo ""
echo "Starting backend"
echo ""
cd ./backend
#xdg-open "http://127.0.0.1:5000" &
python ./app.py

if [ $? -ne 0 ]; then
    echo "Failed to start backend"
    exit $?
fi