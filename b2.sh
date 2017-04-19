. /config.env
echo "[B2]" > /rclone.conf
echo "type = b2" >> /rclone.conf
echo "account = $B2_ACCOUNT" >> /rclone.conf
echo "key = $B2_KEY" >> /rclone.conf
echo "" >> /rclone.conf
