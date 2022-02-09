#!/usr/bin/env bash

<<'COMMENT'
cron: 32 6,18 * * *
new Env('自用更新');
COMMENT

## 导入通用变量与函数
dir_shell=/ql/shell
. $dir_shell/share.sh

file_config_config=$dir_config/config.sh
file_config_update=$dir_config/Update.sh

update_update() {
    curl -sL https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/sh/Update.sh >"$file_config_update"
    sed -i "/openCardBean/d" "$file_config_update"
	sed -i "/Update.sh/d" "$file_config_update"
    sed -i "s/CollectedRepo=''/CollectedRepo='12'/" "$file_config_update"
    sed -i "s/OtherRepo=''/OtherRepo='3 5 9'/" "$file_config_update"
    sed -i "s/RawScript=''/RawScript='1 2'/" "$file_config_update"
    sed -i "s/repoNum=''/repoNum=$CollectedRepo/" "$file_config_update"
}

update_update

cat >>$file_config_update <<-EOF
echo "
if [[ $(date "+%-H") -eq 0 || $(date "+%-H") -eq 8 || $(date "+%-H") -eq 16 ]] && [ $(date "+%-M") -eq 0 ] && [ $(date "+%-S") -gt 4 ]; then
  export JD_JOY_REWARD_NAME="20"
else
  export JD_JOY_REWARD_NAME="500"
fi
" >>\$file_config_config
EOF

task /ql/config/Update.sh
sed -i 's/MaxConcurrentNum=.*/MaxConcurrentNum="5"/' $file_config_config
ql extra
task raw_py_disable.py
task /ql/config/code.sh
