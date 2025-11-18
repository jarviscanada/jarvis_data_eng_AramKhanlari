psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi
lscpu_out=`lscpu`
vm_out=`vmstat --unit M`
vm_out_d=`vmstat --unit M -d`
vm_out_t=`vmstat -t`
dfbm=`df -BM /`
hostname=$(hostname -f)
memory_free=$(echo "$vm_out" | tail -1 | awk -v col="4" '{print $col}'| xargs)
cpu_idle=$(echo "$vm_out" | tail -1 | awk -v col="15" '{print $col}'| xargs)
cpu_kernel=$(echo "$vm_out" | tail -1 | awk -v col="14" '{print $col}'| xargs)
disk_io=$(echo "$vm_out_d" | tail -1 | awk -v col="10" '{print $col}'| xargs)
disk_available=$(echo "$dfbm" | tail -1 | awk -v col="4" '{print $col}'| xargs | head -c-2)
timestamp=$(echo "$vm_out_t" | tail -1 | awk '{print $(NF-1), $NF}' | xargs -I{} date -d "{}" +"%Y-%m-%d %H:%M:%S")
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";
echo "host_id=$host_id"
echo "hostname=$hostname"
echo "timestamp=$timestamp"
echo "memory_free=$memory_free"
echo "cpu_idle=$cpu_idle"
echo "cpu_kernel=$cpu_kernel"
echo "disk_io=$disk_io"
echo "disk_available=$disk_available"
insert_stmt="INSERT INTO host_usage(timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) VALUES('$timestamp', "$host_id", '$memory_free', '$cpu_idle', '$cpu_kernel', '$disk_io', '$disk_available')"
export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
