FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV GITHUB_PROXY=https://github.moeyy.xyz
ENV HOME=/root

RUN sed -i 's@deb.debian.org@mirrors.tuna.tsinghua.edu.cn@g' /etc/apt/sources.list.d/debian.sources \
&& apt-get update -y

RUN apt-get install -y xfonts-wqy fonts-wqy-zenhei fonts-wqy-microhei xvfb xorg xrdp tightvncserver expect libsoundio2 wget novnc ffmpeg \
&& ln -s /usr/share/novnc/utils/novnc_proxy /usr/local/bin/novnc \
&& chmod +x /usr/local/bin/novnc

RUN mkdir -p /scripts
COPY src/set-vnc-password.sh /scripts/set-vnc-password.sh
RUN bash /scripts/set-vnc-password.sh

COPY src/xstartup /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup

ENV QQ_DOWNLOAD_URL="https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.12_240808_amd64_01.deb"
RUN wget -O /root/qq.deb ${QQ_DOWNLOAD_URL} \
&& cd /root \
&& apt-get install -y ./qq.deb

RUN mkdir -p /root/.config \
&& echo 'require(String.raw`/root/.config/LiteLoaderQQNT`);' >> /opt/QQ/resources/app/app_launcher/index.js

RUN apt-get install -y curl \
&& curl -sL https://deb.nodesource.com/setup_20.x | bash - \
&& apt-get install -y nodejs \
&& npm config set registry https://registry.npmmirror.com \
&& npm install -g pnpm

RUN apt-get install -y apt-transport-https lsb-release ca-certificates gpg\
&& wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-archive-keyring.gpg \
&& echo "deb [signed-by=/usr/share/keyrings/google-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list \
&& apt-get update -y \
&& apt-get install -y chromium

RUN apt-get install -y redis-server git unzip

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \ 
PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
 
COPY src/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["bash", "-c", "/entrypoint.sh"]
