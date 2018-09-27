clear
IFS=\n
read -p "Enter the start date in DD-MM-YYYY format. Example 26-Sep-2018 :" startdate
read -p "Enter the end date in DD-MM-YYYY format. Example 26-Sep-2018 :" enddate
start=$(echo $startdate | cut -d '-' -f1)
end=$(echo $enddate | cut -d '-' -f1)
month=$(echo $startdate | cut -d '-' -f2)
for date in $(seq $start $end)
do
echo -e "\e[1;32mAccess logs 504s on $date/$month - Location /var/log/nginx/"
zgrep "$date/$month/2018" /var/log/nginx/access.lo* | grep " 504 "
    IFS=" "
    for times in `zgrep "$date/$month/2018" /var/log/nginx/access.lo* | grep " 504 " | awk '{print $4}' | awk -F: '{print $2" "$3}' | tr " " ":" | tr "\n" " "`
    do
    # echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;31mError logs on $date/$month $times - Location (/var/log/nginx/)\e[0m"
    zgrep "2018/09/$date $times" /var/log/nginx/error.lo*
    echo -e "\e[1;36mphp5-fpm logs on $date/$month - Location /var/log/ \e[0m"
    zgrep "$date-$month-2018" /var/log/php5-fpm.lo*
    done
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
done

# for t in $(seq $x $y); do echo -e "$t"; done;

read -p "Enter the start date in DD-MM-YYYY format. Example 26-Sep-2018 :" startdate
read -p "Enter the end date in DD-MM-YYYY format. Example 26-Sep-2018 :" enddate
start=$(echo $startdate | cut -d '-' -f1)
end=$(echo $enddate | cut -d '-' -f1)
month=$(echo $startdate | cut -d '-' -f2)
echo -e "$start..$end and $month"
# for date in $(seq $start $end)
# do
# echo $date
# done

#!/bin/bash
read -p "Enter the start date in DD-MM-YYYY format. Example 26-Sep-2018 :" startdate
read -p "Enter the end date in DD-MM-YYYY format. Example 26-Sep-2018 :" enddate
start=$(echo $startdate | cut -d '-' -f1)
end=$(echo $enddate | cut -d '-' -f1)
month=$(echo $startdate | cut -d '-' -f2)

for x in $(seq $start $end)
do
echo -e "The range is $x"
done
