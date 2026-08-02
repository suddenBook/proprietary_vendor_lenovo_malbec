#!/vendor/bin/sh

rootfs="/data/lrootfs"
init="pcsysmgr"
lrootfs_dns_file="$rootfs/etc/resolv.conf"
log_file="$rootfs/mnt/pcsys/log/lrootfs.log"

# losetup img to loop
do_bind()
{
    local try_time=50
    local do_time=0
    local img_path=null
    local old_devices=$(losetup -a | grep $1 | awk -F: '{print $1}')
    if [ ! -z $old_devices ]; then
        losetup -d $old_devices
    fi

    while [ $(getprop vendor.zuxos.pcengine.mount.start) -eq 1 ]
    do
        sleep 0.05
    done

    # Path replacement
    if [ "$1" = "usr" ]; then
        img_path=/vendor/etc/assets/usrimg
    elif [ "$1" = "kingsoft" ]; then
        img_path=$rootfs/kingsoftimg
    fi
    if [ ! -f $img_path ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): error: $img_path is not exist" >> $log_file
        return
    fi
    # try losetup -r
    while [ $do_time -le $try_time ]
    do
        get_devices=$(losetup -f)
        losetup -r $get_devices $img_path
        if [ $? -eq 0 ]; then
            setprop vendor.zuxos.pcengine.img.loopdevice $get_devices
            echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): losetup -r $get_devices $img_path success" >> $log_file
            return
        fi
        ((do_time++))
        sleep 0.02
    done
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): error: bind $1 failed" >> $log_file
}

# start umount img
do_umount()
{
    local try_time=50
    local do_time=0
    local img_umount_path=null
    # Path replacement
    if [ "$1" = "usr" ]; then
        img_umount_path=$rootfs/usr
    elif [ "$1" = "kingsoft" ]; then
        img_umount_path=$rootfs/opt/kingsoft
    fi
    # try umount
    while [ $do_time -le $try_time ]
    do
        umount $img_umount_path
        if [ $? -eq 0 ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): umount $img_umount_path success" >> $log_file
            return
        fi
        ((do_time++))
        sleep 0.02
    done
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): error: umount $1 failed" >> $log_file
}

# start mount img
do_mount()
{
    local img_mount_path=null
    # Path replacement
    if [ "$1" = "usr" ]; then
        img_mount_path=$rootfs/usr
        img_path=/vendor/etc/assets/usrimg
    elif [ "$1" = "kingsoft" ]; then
        img_mount_path=$rootfs/opt/kingsoft
        img_path=$rootfs/kingsoftimg
    fi
    if [ ! -f $img_path ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): error: $img_path is not exist" >> $log_file
        return
    fi
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): start mount $img_mount_path" >> $log_file
    setprop vendor.zuxos.pcengine.img.mountpath $img_mount_path
    setprop vendor.zuxos.pcengine.mount.start 1

    # Check kingsoftimg mount results
    if [ "$1" = "kingsoft" ]; then
        mount_success=0
        for i in `seq 1 10`; do
            if mount | grep -q ${img_mount_path}; then
                mount_success=1
                echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): mount $img_mount_path sucees." >> $log_file
                # kingsoftimg mount success
                setprop vendor.zuxos.pcengine.kingsoft.mount 0
                break
            fi
            # wait 100ms
            sleep 0.1
        done

        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): mount mount_success:$mount_success." >> $log_file
        if [ "$mount_success" = "0" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): mount $img_mount_path failed, md5sum kingsoftimg = $(md5sum $rootfs/kingsoftimg)." >> $log_file
            echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): mount $img_mount_path failed, du -sh kingsoftimg = $(du -sh $rootfs/kingsoftimg)." >> $log_file
            echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): mount $img_mount_path failed, Check if the image is damaged: file $rootfs/kingsoftimg = $(file $rootfs/kingsoftimg)" >> $log_file
            echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): mount $img_mount_path failed, reset it." >> $log_file
            rm -f /data/lrootfs/kingsoftimg /data/lrootfs/kingsoftimg.md5 /data/lrootfs/kingsoftimg.version
            touch /data/lrootfs/kingsoftimg /data/lrootfs/kingsoftimg.md5 /data/lrootfs/kingsoftimg.version
            chmod 666 /data/lrootfs/kingsoftimg /data/lrootfs/kingsoftimg.md5 /data/lrootfs/kingsoftimg.version
            # kingsoftimg mount failed
            setprop vendor.zuxos.pcengine.kingsoft.mount 1
        fi
    fi
}

# set container version
set_ver()
{
    local lrootfs_version=$(cat $rootfs/etc/version.txt | sed 's/rootfs-\([0-9]*\)\.tgz/\1/')
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): setup env_version: $lrootfs_version" >> $log_file
    setprop ro.vendor.zuxos.pcengine.lrootfs.version $lrootfs_version
}

# set container dns
set_con_dns()
{
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): start setup dns" >> $log_file
    local lrootfs_dns=$(getprop persist.vendor.zuxos.pcengine.lrootfs.dns)
    echo "nameserver 114.114.114.114" > $lrootfs_dns_file
    for dns in $lrootfs_dns; do
        echo "nameserver $dns" >> $lrootfs_dns_file
    done
}

set_dir_per()
{
    # for wps fonts
    mkdir -p $rootfs/home/zuxos/.local/share/Kingsoft/office6/docerFonts
    chown 7200:7200 -R $rootfs/home/zuxos
    [ ! -f $log_file ] && touch $log_file
    chown 7200:7200 -R $rootfs/mnt/pcsys
    chmod 666 $log_file
    chown 7200:7200 -R $rootfs/run/user
    chmod 777 -R $rootfs/home/
}

reset_wps_files()
{
    if [[ ! -e "/data/lrootfs/kingsoftimg"
          || ! -e "/data/lrootfs/kingsoftimg.md5"
          || ! -e "/data/lrootfs/kingsoftimg.version" ]]; then
        rm -f /data/lrootfs/kingsoftimg /data/lrootfs/kingsoftimg.md5 /data/lrootfs/kingsoftimg.version
        touch /data/lrootfs/kingsoftimg /data/lrootfs/kingsoftimg.md5 /data/lrootfs/kingsoftimg.version
        chmod 666 /data/lrootfs/kingsoftimg /data/lrootfs/kingsoftimg.md5 /data/lrootfs/kingsoftimg.version
    fi
}

config_base_env()
{
    local appconfig_filepath="$rootfs/home/zuxos/.config/"
    local apps_filename="Kingsoft user-dirs.dirs"
    # file backup
    for app in $apps_filename
    do
        if [ -d "$appconfig_filepath/$app" ]; then
            rm -rf $appconfig_filepath/$app-bak
            mv $appconfig_filepath/$app $appconfig_filepath/$app-bak
        fi
    done
    # tar lrootfs.tgz
    tar -xf  /vendor/etc/assets/$1 -C $rootfs
    if [ $? -eq 0 ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): root_file_system tar success" >> $log_file
    else
        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): root_file_system tar failed" >> $log_file
    fi

    # restore file
    for app in $apps_filename
    do
        if [ -d "$appconfig_filepath/$app-bak" ]; then
            rm -rf $appconfig_filepath/$app
            mv $appconfig_filepath/$app-bak $appconfig_filepath/$app
        fi
    done

    # hosts
    if [ -e "$rootfs/etc/hosts" ]; then
        echo "127.0.0.1 localhost" > $rootfs/etc/hosts
    fi

    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): config_base_env end" >> $log_file

    # dns
    set_con_dns
}

check_if_config_base_env()
{
    local version_file="$rootfs/etc/version.txt"
    local old_env_version=$(cat $rootfs/etc/version.txt)
    local latest_env_version=$(basename "$(ls /vendor/etc/assets/lrootfs*.tgz)")
    if [ -f $version_file ]; then
        if [ "$old_env_version" \< "$latest_env_version" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): start update the root file system" >> $log_file
            config_base_env $latest_env_version
        fi
    else
        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): start setting up the root file system" >> $log_file
        config_base_env $latest_env_version
    fi
    reset_wps_files
}

release_base_env()
{
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): start mount imgs" >> $log_file
    rm -rf $rootfs/tmp/*
    mkdir -p $rootfs/tmp/pcsys/rdp
    chmod -R 0755 $rootfs/tmp/pcsys

    set_ver
    if [ "$1" = "base" ]; then
        mkfifo /dev/pcsys/ads
        chmod 777 /dev/pcsys/ads
        chown root:7200 /dev/pcsys/ads
    fi
}

start_pcsys()
{
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): start pcsys" >> $log_file
    rm /dev/pcsys/rdp/fast_channel
    rm /dev/pcsys/rdp/fast_server
    rm /dev/pcsys/rdp/fast_client
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): rm node result:$?" >> $log_file

    rm -rf $rootfs/home/zuxos/core
    export TMPDIR=/dev/pcsys/rdp
    # start container
    chroot $rootfs /bin/su - root -c /bin/pcsysmgr
}

mon_heartbeat()
{
    local pcengine_health=$(getprop vendor.zuxos.pcengine.health)
    local check_count=$(getprop vendor.zuxos.pcengine.heartbeat)
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): Start healthcheck: $check_count with health: $pcengine_health" >> $log_file
    while [ $pcengine_health -gt 0 ]
    do
        ((pcengine_health--))
        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): Set health-- : $pcengine_health and sleep 60s" >> $log_file
        setprop vendor.zuxos.pcengine.health $pcengine_health
        sleep 60
        ((check_count++))
        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): Set check++ : $check_count and Start next healthcheck" >> $log_file
        setprop vendor.zuxos.pcengine.heartbeat $check_count
        pcengine_health=$(getprop vendor.zuxos.pcengine.health)
    done
    if [ $pcengine_health -eq 0 ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): Stop container for health : $pcengine_health and End healthcheck" >> $log_file
        setprop vendor.zuxos.pcengine.container.start 0
    fi
}

update_imgs()
{
    # which img will be update
    local update_app_name=$(getprop vendor.zuxos.pcengine.app.update)
    local if_update_running=$(getprop vendor.zuxos.pcengine.update.state)
    local img_mount_path=null
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): Start update img: $update_app_name." >> $log_file
    # Path replacement
    if [ "$update_app_name" = "kingsoft" ]; then
        img_mount_path=$rootfs/opt/kingsoft
    fi
    while [ "$if_update_running" = "running" ]
    do
        sleep 0.5
        if_update_running=$(getprop vendor.zuxos.pcengine.update.state)
        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): Wait for update end." >> $log_file
    done
    setprop vendor.zuxos.pcengine.update.state running
    # umount img
    if mount | grep -q $img_mount_path; then
        do_umount $update_app_name
    fi
    # losetup img
    do_bind $update_app_name
    # mount img
    do_mount $update_app_name

    setprop vendor.zuxos.pcengine.update.state end
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): Update $update_app_name end." >> $log_file
}

app_cleanup()
{
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): start cleanup app data" >> $log_file
    if [ "$(getprop vendor.zuxos.pcengine.app.clean)" = "kingsoft" ]; then
        clean_dir="Kingsoft"
    else
        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): error: please check which app need be clean" >> $log_file
        return
    fi
    rm -rf $rootfs/home/zuxos/.config/$clean_dir
    cp -raf $rootfs/root/.config/$clean_dir $rootfs/home/zuxos/.config/
    chmod 777 -R $rootfs/home/zuxos/.config/$clean_dir
    chown 7200:7200 -R $rootfs/home/zuxos/.config/$clean_dir

    setprop vendor.zuxos.pcengine.container.start 0
    setprop vendor.zuxos.pcengine.app.cleandone kingsoft
}

unistall_app()
{
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): start uninstall app" >> $log_file
    local uninstall_app_name=$(getprop vendor.zuxos.pcengine.app.uninstall)
    # clean app data
    setprop vendor.zuxos.pcengine.app.clean $uninstall_app_name

    # umount img
    do_umount $uninstall_app_name
}

set_timezone()
{
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): start setup container timezone" >> $log_file

    # ensure usrimg mounted
    local usrimg_mount_path=$rootfs/usr
    for i in `seq 1 100`; do
        echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): set_timezone usrimg round: $i." >> $log_file
        ls $rootfs/usr/share/zoneinfo
        if [ "$?" = "0" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): set_timezone usrimg mounted." >> $log_file
            break
        fi

        # 等待 500ms
        sleep 0.5
    done

    local timezone=$(getprop persist.sys.timezone)
    rm $rootfs/etc/localtime
    chroot $rootfs/ /usr/bin/ln -s /usr/share/zoneinfo/$timezone /etc/localtime
}

inspect_lrootfs()
{
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): check imgs mount_state" >> $log_file
    local imgs_mount_path="$rootfs/usr $rootfs/opt/kingsoft"
    for path in $imgs_mount_path
    do
        if ! mount | grep -q $path; then
            imgname=$(basename "$path")
            do_bind $imgname
            do_mount $imgname
        fi
    done
}

reset_lrootfs()
{
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): start reset container env" >> $log_file
    setprop vendor.zuxos.pcengine.container.start 0
    rm -rf $rootfs/{boot,etc,media,mnt,root,run,src,srv,tmp,var,bin,lib,sbin}
    check_if_config_base_env
    release_base_env reset
    setprop vendor.zuxos.pcengine.container.reset.state 1
}

enable_channel()
{
    # Activate data channel
    echo start > /dev/pcsys/ads
}

if [ "$1" = "check_if_config_base_env" ]; then
    check_if_config_base_env
    set_dir_per
    release_base_env base
elif [ "$1" = "start_pcsys" ]; then
    inspect_lrootfs
    set_timezone
    start_pcsys
elif [ "$1" = "mon_heartbeat" ]; then
    mon_heartbeat
elif [ "$1" = "update_imgs" ]; then
    update_imgs
elif [ "$1" = "app_cleanup" ]; then
    app_cleanup
elif [ "$1" = "unistall_app" ]; then
    unistall_app
elif [ "$1" = "set_con_dns" ]; then
    set_con_dns
elif [ "$1" = "set_timezone" ]; then
    set_timezone
elif [ "$1" = "reset_lrootfs" ]; then
    reset_lrootfs
elif [ "$1" = "reset_wps_files" ]; then
    reset_wps_files
elif [ "$1" = "enable_channel" ]; then
    enable_channel
else
    echo "$(date +%Y-%m-%d_%H:%M:%S.%3N): Please use the correct parameters: $1." >> $log_file
fi
