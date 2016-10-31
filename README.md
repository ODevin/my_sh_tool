#!/bin/sh
# $1 is dir path
# $2 is number of days
# $3 {--noback}
now_date=$(date "+%Y-%m-%d");
now_hour=$(date "+%H");
now_time=$(date "+%H-%M-%S");
now_datetime=$(date "+%Y-%m-%d-%H-%M-%S");
now_datetime2=$(date "+%Y-%m-%d %H:%M:%S");
#=============================================================================================
this_file_path=`readlink -f "$0"`
path_num=`echo ${this_file_path}|awk -F"/" '{print NF}'`
((dir_num=${path_num}-1))
current_position=`echo ${this_file_path}|cut -d "/" -f -${dir_num}`
#=============================================================================================
#RE1='^[0-9]*$'
#RE1 int
RE1='^[[:digit:]]*$';
#RE1='^[[:digit:]]+(\.[[:digit:]])?$'
#RE1='^[0-9]+(\.[0-9]+)?$'
if [ -n "${1}" ];then
    if [[ -e ${1} && -d ${1} ]];then
        directory=${1}
        shift;
        if [ -n "${1}" ];then
            if [ ${1} == "-d" ];then
                echo "${now_datetime2} WARNING:: '-d' This option not enabled yet,plase use other option";
            elif [ ${1} == "-f" ];then
                shift;
                if [ -n "${1}" ];then
                    if [[ ${1} =~ ${RE1} ]];then
                        num_of_day=${1};
                        shift;
                        if [ -n "${1}" ];then
                            option=${1}
                            case ${option} in
                                "--noback")
                                    echo "====================${now_datetime2}NO Backup and Delete====================================";
                                    if [ ${num_of_day} -eq 0 ];then
                                        all_file=$(find ${directory} -maxdepth 1 -mtime ${num_of_day} -type f -exec basename {} \;)
                                    else
                                        all_file=$(find ${directory} -maxdepth 1 -mtime +${num_of_day} -type f -exec basename {} \;)
                                    fi
                                    file_num=$(echo ${all_file}|awk '{print NF}')
                                    if [ ${file_num} -ne 0 ];then
                                            $(cd ${directory}&& rm ${all_file});
                                            for file in ${all_file};do
                                                echo "${now_datetime2} INFO::${file} is deleted!";
                                            done
                                        echo "${now_datetime2} INFO::Delete ${file_num} file!!!!!!!!";
                                    else
                                        echo "${now_datetime2} ERROR::No conform file on this directory: ${directory} ";
                                        exit 44;
                                    fi

                                ;;
                                *)
                                    echo "${now_datetime2} ERROR::The option error.....";
                                    exit 33;
                                ;;
                            esac
                        
                        else
                            echo "====================${now_datetime2} Backup and Delete====================================";
                            bak_for_date=$(date -d "${num_of_day} day ago" +%Y-%m-%d-%H-%M-%S);
                            back_file="${current_position}"/"${bak_for_date}_bak.tar.gz";
                            if [ -f ${back_file} ];then
                                echo "${now_datetime2} ERROR::Backup file ${back_file} is existence??plase move it and try again!!"
                                exit 40;
                            fi
                            if [ ${num_of_day} -eq 0 ];then
                                all_file=$(find ${directory} -maxdepth 1 -mtime ${num_of_day} -type f -exec basename {} \;)
                            else
                                all_file=$(find ${directory} -maxdepth 1 -mtime +${num_of_day} -type f -exec basename {} \;)
                            fi
                            file_num=$(echo ${all_file}|awk '{print NF}')
                            if [ ${file_num} -ne 0 ];then
                                if [ ${file_num} -eq 1 ];then
                                    $(eval tar -cf - -C ${directory} ${all_file} ${produce_file_str}|gzip -c -9 >${back_file})
                                else
                                    for ((i=1;${i}<=${file_num};i++));do
                                        if [ ! ${i} == ${file_num} ];then
                                            produce_file_str=${produce_file_str}$(echo ${all_file}|cut -d " " -f ${i})',';
                                        else
                                            produce_file_str=${produce_file_str}$(echo ${all_file}|cut -d " " -f ${i});
                                        fi
                                    done
                                    $(eval tar -cf - -C ${directory} {${produce_file_str}}|gzip -c -9 >${back_file})
                                fi
                            else
                                echo "${now_datetime2} ERROR::No conform file on this directory: ${directory} ";
                                exit 44;
                            fi
                            echo "${now_datetime2} INFO::${now_datetime2}:Backup complete to ${back_file}";
                            if [ $? -eq 0 ];then
                                $(cd ${directory}&& rm ${all_file});
                                for file in ${all_file};do
                                    echo "${now_datetime2} INFO::${file} is deleted!";
                                done
                            echo "${now_datetime2} INFO::Delete ${file_num} file!!!!!!!!";
                            else
                                echo "execu fail";
                            fi
                        fi
                    else
                    
                        echo "zhe bu shi shu zi";
                        exit 44;
                    fi
                else 
                    echo "${now_datetime2} ERROR::Null number, I need a number, Give me a number!!!!!"
                    exit 33;
                fi
            elif [[ ${1} =~ ${RE1} ]];then
                num_of_day=${1};
                shift;
                if [ -n "${1}" ];then
                    option=${1}
                    case ${option} in
                        "--noback")
                            echo "====================${now_datetime2} NO Backup and Delete====================================";
                            if [ ${num_of_day} -eq 0 ];then
                                all_file=$(find ${directory} -maxdepth 1 -mtime ${num_of_day} -type f -exec basename {} \;)
                            else
                                all_file=$(find ${directory} -maxdepth 1 -mtime +${num_of_day} -type f -exec basename {} \;)
                            fi
                            file_num=$(echo ${all_file}|awk '{print NF}')
                            if [ ${file_num} -ne 0 ];then
                                $(cd ${directory}&& rm ${all_file});
                                for file in ${all_file};do
                                    echo "${now_datetime2} INFO::${file} is deleted!";
                                done
                                echo "${now_datetime2} INFO::Delete ${file_num} file!!!!!!!!";
                            else
                                echo "${now_datetime2} ERROR::No conform file on this directory: ${directory} ";
                                exit 44;
                            fi

                        ;;
                        *)
                            echo "${now_datetime2} ERROR::The option error.....";
                            exit 33;
                        ;;
                    esac
                else
                    echo "====================${now_datetime2} Backup and Delete====================================";
                    bak_for_date=$(date -d "${num_of_day} day ago" +%Y-%m-%d-%H-%M-%S);
                    back_file="${current_position}"/"${bak_for_date}_bak.tar.gz";
                    if [ ${num_of_day} -eq 0 ];then
                        all_file=$(find ${directory} -maxdepth 1 -mtime ${num_of_day} -type f -exec basename {} \;)
                    else
                        all_file=$(find ${directory} -maxdepth 1 -mtime +${num_of_day} -type f -exec basename {} \;)
                    fi
                    file_num=$(echo ${all_file}|awk '{print NF}')
                    if [ ${file_num} -ne 0 ];then
                        
                        if [ ${file_num} -eq 1 ];then
                            $(eval tar -cf - -C ${directory} ${all_file} ${produce_file_str}|gzip -c -9 >${back_file})
                        else
                            for ((i=1;${i}<=${file_num};i++));do
                                if [ ! ${i} == ${file_num} ];then
                                    produce_file_str=${produce_file_str}$(echo ${all_file}|cut -d " " -f ${i})',';
                                else
                                    produce_file_str=${produce_file_str}$(echo ${all_file}|cut -d " " -f ${i});
                                fi
                            done
                            $(eval tar -cf - -C ${directory} {${produce_file_str}}|gzip -c -9 >${back_file})
                        fi
                    else
                        echo "${now_datetime2} ERROR::No conform file on this directory: ${directory} ";
                        exit 44;
                    fi
                    if [ $? -eq 0 ];then
                        echo "${now_datetime2} INFO::${now_datetime2}:Backup complete to ${back_file}";
                        $(cd ${directory}&& rm ${all_file});
                        if [ $? -eq 0 ];then
                            for file in ${all_file};do
                                echo "${now_datetime2} INFO::${file} is deleted!";
                            done
                        fi
                        echo "${now_datetime2} INFO::Delete ${file_num} file!!!!!!!!";
                    else
                        echo "execu fail";
                    fi
                fi
            else
                echo "${now_datetime2} ERROR::Parameter error";
                exit 44;
            fi
        else 
            echo "${now_datetime2} ERROR::Null parameter!Give me a num or parameter{-d|-f}!!!!!"
            exit 33;
        fi
    else
        echo "${now_datetime2} ERROR::This is not directory or not exist, plase check this and try again!"
        exit 22;
    fi
else
    echo "${now_datetime2} ERROR::Plase add parameter!";
    exit 11;
fi
