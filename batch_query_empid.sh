#!/bin/bash

function select_one_emp(){
    #t=$RANDOM
    #t=$[t%6+1]
    #sleep $t
    #echo "sleep $t s" >> tmp
    
    sql="select /*+join(si)*/ empid, empname, sum(b.daybal) from 
            xm_ftp_deposit_dtl_202001 a join xm_tmp_acct_202001 b 
            on a.acct=b.acct and b.dates >= to_date(a.fromdate, 'yyyymmdd') and b.dates <= to_date(a.enddate, 'yyyymmdd') 
            where empid='$6';"
    echo "mysql -h$1 -P$2 -u$3 -p$4 -D$5 -c -e \"$sql\" >> $7"
    mysql -h$1 -P$2 -u$3 -p$4 -D$5 -c -e "$sql" >> $7
}

cur_time=$(date +%H:%M:%S)
echo "start time: $cur_time"

host1="192.168.100.204"
host2="192.168.100.204"
host3="192.168.100.204"
port=17782
user=admin
password=admin
db=kingwow

result="./tmp"
cg_cnt=3
max_concurrent_one_cg=5
thread_num=`expr $cg_cnt \* $max_concurrent_one_cg`  # 最大可同时执行线程数量, 每台CG并发5，一共3台CG

tmp_fifofile="/tmp/$$.fifo"
mkfifo $tmp_fifofile      # 新建一个fifo类型的文件
exec 6<>$tmp_fifofile     # 将fd6指向fifo类型
rm $tmp_fifofile    #删也可以

# 获取empid实际个数
all_empid="./all_empid"
mysql -h$host1 -P$port -u$user -p$password -D$db -c -e "select distinct empid from xm_ftp_deposit_dtl_202001;" > $all_empid
sed -i '1d' $all_empid # 删除列名所在行
#job_num=1600
job_num=`wc -l $all_empid | awk '{print $1}'`   # 任务总数

#根据线程总数量设置token个数
for ((i=0;i<${thread_num};i++));do
    echo
done >&6

echo "start execute $job_num jobs, max concurrent:$thread_num"
for ((i=0;i<${job_num};i++));do
    # 一个read -u6命令执行一次，就从fd6中减去一个回车符，然后向下执行，
    # fd6中没有回车符的时候，就停在这了，从而实现了线程数量控制
    read -u6
    row_cnt=`expr $i + 1`
    empid=$(sed -n $row_cnt"p" $all_empid)
    calc_res=`expr $row_cnt % $cg_cnt`
    if [ $calc_res -eq 1 ]; then
        host=$host1
        echo "connect host1:$host"
    elif [ $calc_res -eq 2 ]; then
        host=$host2
        echo "connect host2:$host"
    else
        host=$host3
        echo "connect host3:$host"
    fi
    #可以把具体的需要执行的命令封装成一个函数
    {
        select_one_emp $host $port $user $password $db $empid $result
        echo >&6 # 当进程结束以后，再向fd6中加上一个回车符，即补上了read -u6减去的那个
    } &

done

wait
exec 6>&- # 关闭fd6

# 删除结果文件中的列行
sed -i '/empid/d' $result

cur_time=$(date +%H:%M:%S)
echo "end time: $cur_time"
