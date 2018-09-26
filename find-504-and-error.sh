clear
IFS=\n
for date in {25..26}
do
echo -e "\e[1;32mAccess logs 504s on $date/Sep - Location (/var/log/nginx/)e[0m"
zgrep "$date/Sep/2018" /var/log/nginx/access.log.* | grep " 504 "
    IFS=" "
    for times in `zgrep "$date/Sep/2018" /var/log/nginx/access.log.* | grep " 504 " | awk '{print $4}' | awk -F: '{print $2" "$3}' | tr " " ":" | tr "\n" " "`
    do
    # echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;31mError logs on $date/Sep $times - Location (/var/log/nginx/)\e[0m"
    zgrep "2018/09/$date $times" /var/log/nginx/error.log.*
    # echo -e "\e[1;36mphp5-fpm logs on $date/Sep $times - Location (/var/log/)\e[0m"
    # zgrep "$date-Sep-2018 $times" /var/log/php5-fpm.log.*
    done
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
done

# Added php-fpm logs for a specific day and not the timestamp
clear
IFS=\n
for date in {20..26}
do
echo -e "\e[1;32mAccess logs 504s on $date/Sep - Location /var/log/nginx/ e[0m"
zgrep "$date/Sep/2018" /var/log/nginx/access.lo* | grep " 504 "
    IFS=" "
    for times in `zgrep "$date/Sep/2018" /var/log/nginx/access.lo* | grep " 504 " | awk '{print $4}' | awk -F: '{print $2" "$3}' | tr " " ":" | tr "\n" " "`
    do
    # echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;31mError logs on $date/Sep $times - Location (/var/log/nginx/)\e[0m"
    zgrep "2018/09/$date $times" /var/log/nginx/error.lo*
    echo -e "\e[1;36mphp5-fpm logs on $date/Sep - Location /var/log/ \e[0m"
    zgrep "$date-Sep-2018" /var/log/php5-fpm.lo*
    done
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
done




