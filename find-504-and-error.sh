clear
IFS=\n
for date in {02..04}
do
echo -e "\e[1;32mNumber of 504s in Access logs on $date/Sep\e[0m"
zgrep "$date/Sep/2018" /var/log/nginx/access.log.* | grep " 504 "
    IFS=" "
    for times in `zgrep "$date/Sep/2018" /var/log/nginx/access.log.* | grep " 504 " | awk '{print $4}' | awk -F: '{print $2" "$3}' | tr " " ":" | tr "\n" " "`
    do
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "\e[1;32mNow the error logs corresponding to the access logs 504\e[0m"
    zgrep "2018/09/$date $times" /var/log/nginx/error.log.*
    done
echo "************************************************************************************************************"
done
