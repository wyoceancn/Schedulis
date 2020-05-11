#generate ansible-playbook inventory
#生成ansible-playbook 执行清单
all_nodes=$1
wtss_version_old=$2
wtss_version_new=$3
update_type=$4

UUID=${cat /proc/sys/kernel/random/uuid}
mkdir -p /data/change/client
v_hosts=/data/change/client/hdp_client.hosts${UUID}
echo >$v_hosts
cat >$v_hosts <<EOF
[all:vars]
ansible_ssh_port=36000
ansible_ssh_pass=passwd

[all_nodes]
EOF


#corresponding relations between IP and Hostname
#拼接IP和Hostname的对应关系
all_nodes=${all_nodes//,/ }
for element in $all_nodes
do
echo $element >>$v_hosts
done

echo ${v_hosts}
cat ${v_hosts}

if [ "$update_type" == 'exec' ] 
then 
	echo "start to update execServer"	
	/usr/bin/ansible-playbook -i ${v_hosts} --extra-vars "version_old=${wtss_version_old} version_new=${wtss_version_new}" /appcom/Install/AzkabanInstall/wtssdeploy/upgrade/upgrade_exec.yml
	
	
elif [ "$update_type" == 'web' ] 
then 
	echo "start to update webServer"	
	/usr/bin/ansible-playbook -i ${v_hosts} --extra-vars "version_old=${wtss_version_old} version_new=${wtss_version_new}" /appcom/Install/AzkabanInstall/wtssdeploy/upgrade/upgrade_web.yml

else
	echo "no match update_type"
fi