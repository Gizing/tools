# 检查指定时间段的日志内容中是否包含内存溢出
check_out_of_memory()
{
file=/var/log/messages
key="Out of memory"

end_month=`date +%b`
end_day=`date +%d`
start_hour=`date -d'-4 minutes' +%H`
start_minute=`date -d'-4 minutes' +'%M'`
end_hour=`date +%H`
end_minute=`date +%M`
if [ $end_hour -lt $start_hour ]; then
    # 时间段跨天
    start_month=`date -d'-4 minutes' +%b`
    start_day=`date -d'-4 minutes' +%d`
    awk -F[:\ ] -v start_month=$start_month -v start_day=$start_day -v end_month=$end_month -v end_day=$end_day -v start_hour=$start_hour -v start_minute=$start_minute -v end_hour=$end_hour -v end_minute=$end_minute \
    '($1 == start_month && $2 == start_day && start_hour":"start_minute <= $3":"$4 && $3":"$4 <= 23":"59) || 
    ($1 == end_month && $2 == end_day && $3":"$4 <= end_hour":"end_minute)' $file | grep $key
else
    awk -F[:\ ] -v end_month=$end_month -v end_day=$end_day -v start_hour=$start_hour -v start_minute=$start_minute -v end_hour=$end_hour -v end_minute=$end_minute '$1 == end_month && $2 == end_day && start_hour":"start_minute <= $3":"$4 && $3":"$4 <= end_hour":"end_minute' $file | grep $key
fi

}


