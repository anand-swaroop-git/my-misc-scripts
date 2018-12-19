# The AWS CLI needs to be pre-configured to run both the following scripts.
# Also, jq needs to be installed before these scripts will run properly.
# The script is hardcoded to run in nonprod account and us-west-2 region for now  - Can be made generic/independent as well.
# It will place the output txt file in /tmp directory (The script is verbose enough)
# Note: if you want to run it for the second time or more, everytime the output file generated by the script in the location /tmp/untagged_ec2.txt will have to be manually deleted otherwise it will skew the output recorded in the output file APPENDED on each run.

# Untagged-ec2.sh
#!/bin/bash
for tags in Application DeptCode Environment ITTeamOwner ITOwnerName
do
echo
echo -e "Looking for instances without user:$tags:"
aws ec2 describe-instances --profile nonprod --region us-west-2 | jq '.Reservations[].Instances[] | select(contains({Tags: [{Key: "user:$tags"} ]}) | not)' | grep -i "instanceid" >> /tmp/userenv.txt
done
echo
#Put the final output in an output file
echo "Generating the final output file named /tmp/untagged_ec2.txt"
cat /tmp/userenv.txt | awk '{print $2}' | tr "\"" " " | awk '{print $1}' | sort | uniq >> /tmp/untagged_ec2.txt
count=$(cat /tmp/untagged_ec2.txt | wc -l)
echo
echo -e "Total $count instances were found without ANY of these Application DeptCode Environment ITTeamOwner ITOwnerName tags"
#Remove the redundant file
rm -f /tmp/userenv.txt
echo
echo "ALL DONE!"
echo

 

# Untagged-rds.sh
#!/bin/bash
echo
echo "Looking for the RDS instances without tags..."
for x in $(aws rds describe-db-instances --query 'DBInstances[*].DBInstanceArn' --profile nonprod --region us-west-2 --output text)
do
aws rds list-tags-for-resource --resource-name $x --profile nonprod --region us-west-2 | jq '.TagList[].Key' | egrep -v '(Application|DeptCode|Environment|ITTeamOwner|ITOwnerName)' &> /dev/null
if [ $? == 0 ]
then
echo -e "$x" >> /tmp/untagged_rds.txt
fi
done
count=$(cat /tmp/untagged_rds.txt | wc -l)
echo "Total $count instance were found without ANY of these Application DeptCode Environment ITTeamOwner ITOwnerName tags"
echo
echo "Generating the final output file named /tmp/untagged_rds.txt"
echo
echo "ALL DONE!"
echo

