#!/bin/sh

mysqldump -u prod --add-drop-table reg_prod > tmp/prod.sql
