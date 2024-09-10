expect -c "
spawn vncpasswd
expect \"Password:\"
send \"liteloaderqqnt\n\"
expect \"Verify:\"
send \"liteloaderqqnt\n\"
expect \"Would you like to enter a view-only password (y/n)?\"
send \"n\n\"
expect eof
"
