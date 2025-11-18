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
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out"  | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out"  | egrep "^Model name:" | awk -F: '{print $2}' | xargs)
l2_cache=$(echo "$lscpu_out"  | egrep "^L2 cache:" | awk '{print $3}' | xargs)
total_mem=$(echo "$vm_out" | tail -1 | awk '{print $4}')
cpu_mhz=$(echo "$lscpu_out" | egrep "^Model name:" | awk '{print $NF}' | xargs | head -c-4 | awk '{print $1 * 1000}')
timestamp=$(echo "$vm_out_t" | tail -1 | awk '{print $(NF-1), $NF}' | xargs -I{} date -d "{}" +"%Y-%m-%d %H:%M:%S")
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";
echo "hostname=$hostname"
echo "cpu_number=$cpu_number"
echo "cpu_architecture=$cpu_architecture"
echo "cpu_model=$cpu_model"
echo "l2_cache=$l2_cache"
echo "cpu_mhz=$cpu_mhz"
echo "total_mem=$total_mem"
echo "timestamp=$timestamp"
insert_stmt="INSERT INTO host_info(hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, timestamp, total_mem ) VALUES( '$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$l2_cache', '$timestamp', '$total_mem')"
export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
