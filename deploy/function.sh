#! /usr/bin/env bash

function assert_process_from_name_not_exist()
{
  local pid
  pid=$(ps aux|grep $1|grep -v grep|awk '{print $2}')
  if [ "$pid" ];then
  echo "已经有一个 $1 进程在运行"
  exit 5
  fi
}

function assert_process_from_pid_file_not_exist()
{
  local pid;

  if [ -f $1 ]; then
    pid=$(cat $1)
    if [ $pid ] && [ "$(ps $pid|grep -v PID)" ]; then
      echo "$1 pid_file 中记录的 pid 还在运行"
      exit 5
    fi
  fi
}

function check_run_status_from_pid_file()
{
  local pid;
  local service_name;
  service_name=$2
  if [ -f $1 ]; then
    pid=$(cat $1)
  fi

  if [ $pid ] && [ "$(ps $pid|grep -v PID)" ]; then
    echo -e "$service_name  [\033[1;32mrunning\033[0m]"
  else
    echo -e "$service_name  [\033[1;31mnot running\033[0m]"
  fi
}

function get_sh_dir_path()
{
  echo -n $(cd "$(dirname "$0")"; pwd)
}

function command_status()
{
  if [ $? == 0 ];then
    echo -e "[\033[1;32msuccess\033[0m]"
  else
    echo -e "[\033[1;31mfail\033[0m]"
  fi
}