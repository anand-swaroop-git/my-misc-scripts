for date in {23..24}
do
echo -e "Number of 504s in Access logs on $date/Sep"
zgrep "$date/Sep/2018" /var/log/nginx/access.log.* | grep " 504 " | awk '{print $4}' | awk -F: '{print $2 " " $3}
echo
done

# head -n1 access.log | awk '{print $4}' | awk -F: '{print $2 " " $3}'
# head -n1 access.log | awk '{print $4}' | awk -F: '{print $3}'