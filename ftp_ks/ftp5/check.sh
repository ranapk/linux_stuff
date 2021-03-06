# Answers Check Script for ftp5
echo "Give Candidate IP : "
read ip
rm -rf /tmp/exam &> /dev/null
mkdir /tmp/exam &> /dev/null
touch /tmp/exam/flogs &> /dev/null
scp 192.168.1.$ip:/etc/vsftpd/user_list /tmp/exam/user_list_$ip &>> /tmp/exam/flogs
diff /tmp/exam/user_list_$ip answers/user_list &>> /tmp/exam/flogs
a=$?
scp 192.168.1.$ip:/etc/vsftpd/ftpusers /tmp/exam/ftpusers_$ip &>> /tmp/exam/flogs
diff /tmp/exam/ftpusers_$ip answers/ftpusers &>> /tmp/exam/flogs
b=$?
scp 192.168.1.$ip:/etc/vsftpd/vsftpd.conf /tmp/exam/vsftpd.conf_$ip &>> /tmp/exam/flogs
diff /tmp/exam/vsftpd.conf_$ip answers/vsftpd.conf &>> /tmp/exam/flogs
c=$?
if [ $(ls -ld /var/ftp/pub/q.txt | awk '{ print $1 }') == '-rwxr--r--.' ]; then p=1; else p=0; fi
if [ $a -eq 0 ] && [ $b -eq 0 ] && [ $c -eq 0 ] && [ $p -eq 1 ]; then
	echo "Perfect."
	exit
fi
grep "anonymous" /tmp/exam/user_list_$ip &>> /tmp/exam/flogs
a1=$? # 1 for pass
grep "anonymous" /tmp/exam/ftpusers_$ip &>> /tmp/exam/flogs
a3=$? # 1 for pass
grep "userlist_deny=NO" /tmp/exam/vsftpd.conf_$ip &>> /tmp/exam/flogs
a5=$? # 1 for pass
if [ $a1 -eq 1 ] && [ $a3 -eq 1 ] && [ $a5 -eq 1 ] && [ $c -eq 0 ] && [ $p -eq 1 ]; then
	echo "Pass."
else 
	echo "Fail."
fi
