#!/bin/bash

FILE_SERVICE="ytb2audiobot.service"

sudo cp "$FILE_SERVICE" "/etc/systemd/system/$FILE_SERVICE"

sudo systemctl daemon-reload

sudo systemctl enable "$FILE_SERVICE"

sudo systemctl start "$FILE_SERVICE"

sudo systemctl status "$FILE_SERVICE"
