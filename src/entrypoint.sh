export GIT_PROXY=https://github.moeyy.xyz
export LLQQNT_VERSION=1.2.1
export NAPCAT_VERSION=3.29.5

if [ -d "/root/.config/LiteLoaderQQNT" ]; then
  USER=root vncserver :1
  nohup novnc --vnc localhost:5901 --listen 6080 >/dev/null 2>&1 &
  nohup redis-server >/dev/null 2>&1 &

  if [ -d "./Yunzai" ]; then
    if [ -f "./install.lock" ]; then
      node app
      USER=root vncserver -kill :1
      exit
    else
      echo '开始执行安装命令'
      if [ -f "./plugins/install.sh" ]; then
        chmod +x plugins/install.sh
        bash -c plugins/install.sh
        rm plugins/install.sh
        touch install.lock
        echo '安装完成!请重启!'
        exit
      else
        echo '安装脚本不存在，退出安装'
        touch install.lock
        exit
      fi
    fi
  else
    git clone https://gitee.com/TimeRainStarSky/Yunzai
    mv Yunzai/* .
    pnpm install -P
    touch install.lock
  fi
else
  cd /root/.config
  mkdir LiteLoaderQQNT
  cd LiteLoaderQQNT
  wget -O LiteLoaderQQNT.zip ${GIT_PROXY}/https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/${LLQQNT_VERSION}/LiteLoaderQQNT.zip
  unzip LiteLoaderQQNT.zip
  rm LiteLoaderQQNT.zip
  mkdir plugins

  cd plugins
  mkdir LLOneBot
  cd LLOneBot
  wget -O LLOneBot.zip ${GIT_PROXY}/https://github.com/LLOneBot/LLOneBot/releases/download/v${LLONEBOT_VERSION}/LLOneBot.zip
  unzip LLOneBot.zip
  rm LLOneBot.zip
  chmod +x /root/.config/LiteLoaderQQNT -R
fi
