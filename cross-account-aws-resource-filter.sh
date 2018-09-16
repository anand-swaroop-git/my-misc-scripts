unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
DURATION=3600
NAME="${4:-$LOGNAME@`hostname -s`}"
echo
echo
USER=$(aws sts get-caller-identity --profile default --query 'Arn' --output text | awk -F: '{print $6}' | awk -F/ '{print $2}')
echo
echo -e "Hey, \e[1;32m$USER\e[0m!"
echo
echo "Please enter the PrivateIP/InstanceID/NameTag/KeyName/InstanceState/InstanceSize/Platform that you would like to search... "
echo
read userinput
echo
echo "Searching \"$userinput\" across 10 AWS accounts with 15 regions each and will return the prompt within 4 mins..."
echo
echo
account=$(aws iam list-account-aliases --query 'AccountAliases[]' --output text)
for region in $(aws ec2 describe-regions --output text | cut -f3)
do
aws ec2 describe-instances --region $region --profile default --query 'Reservations[].Instances[].{IID:InstanceId,PIP:PrivateIpAddress,Name:Tags[?Key==`Name`]|[0].Value,KeyName:KeyName,InstanceState:State.Name,InstanceType:InstanceType,Platform:Platform}' --output text | grep -i --color=always "$userinput"
        if [ $? == 0 ]
        then
HITS=$(aws ec2 describe-instances --region $region --profile default --query 'Reservations[].Instances[].{IID:InstanceId,PIP:PrivateIpAddress,Name:Tags[?Key==`Name`]|[0].Value,KeyName:KeyName,InstanceState:State.Name,InstanceType:InstanceType,Platform:Platform}' --output text | grep -i "$userinput" | wc -l)
        echo
        echo "The output above is sorted by: InstanceID InstanceState InstanceSize KeyPairName NameTag PrivateIpAddress Platform"
        echo
     echo -e "AWS Account   : \e[1;32m$account\e[0m (Output Above)"
        echo "Region Name   : $region"
        echo "Hits        : $HITS"
        echo
        fi
done
for ROLE in {arn:aws:iam::101670012301:role/EP-Root-Admin-Role,arn:aws:iam::150121783959:role/EP-Root-Admin-Role,arn:aws:iam::203357732924:role/EP-Root-Admin-Role,arn:aws:iam::589011911289:role/EP-Root-Admin-Role,arn:aws:iam::638857906187:role/EP-Root-Admin-Role,arn:aws:iam::653733036938:role/EP-Root-Admin-Role,arn:aws:iam::760840840568:role/EP-Root-Admin-Role,arn:aws:iam::780477102795:role/EP-Root-Admin-Role,arn:aws:iam::911183197493:role/EP-Root-Admin-Role}
do
ASSUMEROLE=(`aws sts assume-role --role-arn $ROLE --role-session-name $NAME --duration-seconds $DURATION --profile default --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' --output text`)
export AWS_ACCESS_KEY_ID=${ASSUMEROLE[0]}
export AWS_SECRET_ACCESS_KEY=${ASSUMEROLE[1]}
export AWS_SESSION_TOKEN=${ASSUMEROLE[2]}
        ACCOUNT=$(aws iam list-account-aliases --query 'AccountAliases[]' --output text)
        for REGION in $(aws ec2 describe-regions --output text | cut -f3)
        do
aws ec2 describe-instances --region $REGION --query 'Reservations[].Instances[].{IID:InstanceId,PIP:PrivateIpAddress,Name:Tags[?Key==`Name`]|[0].Value,KeyName:KeyName,InstanceState:State.Name,InstanceType:InstanceType,Platform:Platform}' --output text | grep -i --color=always "$userinput"
                if [ $? == 0 ]
                then
HITS2=$(aws ec2 describe-instances --region $REGION --query 'Reservations[].Instances[].{IID:InstanceId,PIP:PrivateIpAddress,Name:Tags[?Key==`Name`]|[0].Value,KeyName:KeyName,InstanceState:State.Name,InstanceType:InstanceType,Platform:Platform}' --output text | grep -i "$userinput" | wc -l)
                echo
                echo "The output above is sorted by: InstanceID InstanceState InstanceSize KeyPairName NameTag PrivateIpAddress Platform"
                echo
             echo -e "AWS Account   : \e[1;32m$ACCOUNT\e[0m (Output Above)"
                echo "Region Name   : $REGION"
              echo "Hits          : $HITS2"
                echo
                fi
        done
done
