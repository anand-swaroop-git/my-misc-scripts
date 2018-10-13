# Script finds the 504s in the access logs (across zipped access logs as well), greps the timestamp of the log files and then finds the error logs (Across zipped error logs as well) corresponding to the timestamps of 504's access log entries found.
clear
IFS=\n
for date in {20..26}
do
echo -e "\e[1;32mAccess logs 504s on $date/Sep - Location /var/log/nginx/ e[0m"
zgrep "$date/Sep/2018" /var/log/nginx/access.lo* | grep " 504 "
    IFS=" "
    for times in `zgrep "$date/Sep/2018" /var/log/nginx/access.lo* | grep " 504 " | awk '{print $4}' | awk -F: '{print $2" "$3}' | tr " " ":" | tr "\n" " "`
    do
    echo -e "\e[1;31mError logs on $date/Sep $times - Location (/var/log/nginx/)\e[0m"
    zgrep "2018/09/$date $times" /var/log/nginx/error.lo*
    echo -e "\e[1;36mphp5-fpm logs on $date/Sep - Location /var/log/ \e[0m"
    zgrep "$date-Sep-2018" /var/log/php5-fpm.lo*
    done
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
done




