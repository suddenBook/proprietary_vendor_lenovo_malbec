#!/vendor/bin/sh

function configure_read_ahead_kb_values() {
  MemTotalStr=`cat /proc/meminfo | grep MemTotal`
  MemTotal=${MemTotalStr:16:8}

  dmpts=$(ls /sys/block/*/queue/read_ahead_kb | grep -e dm -e mmc -e sd)
  # dmpts holds below read_ahead_kb nodes if exists:
  # /sys/block/dm-0/queue/read_ahead_kb to /sys/block/dm-10/queue/read_ahead_kb
  # /sys/block/sda/queue/read_ahead_kb to /sys/block/sdh/queue/read_ahead_kb

  # Set 128 for <= 4GB &
  # set 512 for >= 5GB targets.
  if [ $MemTotal -le 4194304 ]; then
	ra_kb=128
  else
	ra_kb=512
  fi
  for dm in $dmpts; do
	if [ `cat $(dirname $dm)/../removable` -eq 0 ]; then
		echo $ra_kb > $dm
	fi
  done
  if [ -f /sys/block/mmcblk0/bdi/read_ahead_kb ]; then
	echo $ra_kb > /sys/block/mmcblk0/bdi/read_ahead_kb
  fi
  if [ -f /sys/block/mmcblk0rpmb/bdi/read_ahead_kb ]; then
	echo $ra_kb > /sys/block/mmcblk0rpmb/bdi/read_ahead_kb
  fi
}


function taskset_process_cpu() {
  #cpu taskset core
  #taskset -ap 3f `pidof -x kswapd0`
}

function configure_memory_parameters() {
  configure_read_ahead_kb_values
  taskset_process_cpu

  # Disable periodic kcompactd wakeups. We do not use THP, so having many
  # huge pages is not as necessary.
  MemTotalStr=`cat /proc/meminfo | grep MemTotal`
  MemTotal=${MemTotalStr:16:8}
  let RamSizeGB="( $MemTotal / 1048576 ) + 1"

  echo 0 > /proc/sys/vm/compaction_proactiveness
  
  echo 10 > /proc/sys/vm/dirty_background_ratio
  echo 20 > /proc/sys/vm/dirty_ratio

  echo 100 > /proc/sys/vm/swappiness
 
  if [ $RamSizeGB -ge 12 ]; then
	echo 11584 > /proc/sys/vm/min_free_kbytes
	echo 110 > /proc/sys/vm/watermark_scale_factor
  elif [ $RamSizeGB -ge 8 ]; then
	# 8GB配置
	echo 11584 > /proc/sys/vm/min_free_kbytes
	echo 110 > /proc/sys/vm/watermark_scale_factor
  fi
	
  # Disable wsf for all targets beacause we are using efk.
	# wsf Range : 1..1000 So set to bare minimum value 1.

  #Set per-app max kgsl reclaim limit and per shrinker call limit
  if [ -f /sys/class/kgsl/kgsl/page_reclaim_per_call ]; then
		echo 38400 > /sys/class/kgsl/kgsl/page_reclaim_per_call
  fi
  if [ -f /sys/class/kgsl/kgsl/max_reclaim_limit ]; then
		echo 25600 > /sys/class/kgsl/kgsl/max_reclaim_limit
  fi
}


# Set Memory parameters.
configure_memory_parameters





