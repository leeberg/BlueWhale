# docker build . -t sectoolstester
# docker run -it -p 6901:6901 -p 5901:5901 sectoolstester:latest 

FROM ubuntu:latest
LABEL maintainer="github.com\LeeBerg"
LABEL description="This image provides an UBUNTU + Xfce4 with NoVNC to provide a GUI Container Experience. This container was built for the purposes of testing and experimenting with Security Tools. NOT FOR PRODUCTION USE!" 
LABEL version="0.2"

### ENVs
ENV HOME /home/root \
    DISPLAY=:1 \
    LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8' \
    TZ America/Chicago

# Set System Time
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Essentials
RUN apt-get update && apt-get install -y cmake curl git git-core wget whois traceroute unzip usbutils sudo ssh sshfs rar bzip2 ca-certificates build-essential zip inetutils-ping lsb-release net-tools wget && rm -rf /var/lib/apt/lists/*

#XFCE
RUN apt-get update && apt-get install -y locales supervisor xfce4 xfce4-terminal && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*

# NUMPY for WebSockify
RUN apt-get update && apt-get install -y python-psutil python-setuptools python-numpy && mkdir -p /opt/noVNC/utils/websockify && rm -rf /var/lib/apt/lists/*

# Setup websockify & noVNC
RUN mkdir -p /opt/noVNC/utils/websockify && \
 wget -qO- "http://github.com/kanaka/noVNC/tarball/master" | tar -zx --strip-components=1 -C /opt/noVNC && \
 wget -qO- "https://github.com/kanaka/websockify/tarball/master" | tar -zx --strip-components=1 -C /opt/noVNC/utils/websockify && \
 ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Setup TigerVNC
RUN apt-get update && wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.9.0.x86_64.tar.gz | tar xz --strip 1 -C / && rm -rf /var/lib/apt/lists/*

# Setup Additional VNC/XFCE Items
#RUN apt-get update && apt install -y xfce4-goodies xorg dbus-x11 x11-xserver-utils && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt install -y tigervnc-standalone-server tigervnc-common && rm -rf /var/lib/apt/lists/*

#MISC - adds ~35mb
RUN apt-get update && apt install -y aptitude apt-utils p7zip p7zip-full xtightvncviewer unrar netcat net-tools xmlstarlet ldap-utils openssl openvpn automake autoconf ghex ethtool && rm -rf /var/lib/apt/lists/*

# Frameworks / Languages - adds ~300mb - python & java takes awhile to install
RUN apt-get update && apt install -y openjdk-8-jdk openjdk-8-jre python python2.7 python-dev python-pip python-virtualenv python-scapy python-sqlalchemy g++ gcc gdb && rm -rf /var/lib/apt/lists/*

# Broswers - 189MB
RUN apt-get update && apt install -y firefox && rm -rf /var/lib/apt/lists/*

# Databases - 66 MB
RUN apt-get update && apt install -y postgresql pgadmin3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*

#wireshark is problematic sometimes
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y wireshark wireshark-qt

# SEC TOOLS ~700MB
RUN apt-get update && apt install -y etherape zenmap aircrack-ng dsniff nikto nmap ophcrack pyrit reaver tshark thc-ipv6 yersinia lynis medusa nbtscan netwox scalpel hydra hydra-gtk autopsy ettercap-text-only tcpdump tcpick && rm -rf /var/lib/apt/lists/*

# MetaSploit Framework + 489MB
RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && sh ./msfinstall

# Tools Directory Setup (Lots of GITs)
RUN mkdir /home/root
RUN mkdir /home/root/Desktop
RUN mkdir /home/root/Desktop/Tools
RUN cd /home/root/Desktop/Tools && \
git clone --depth=1 https://LaNMaSteR53@bitbucket.org/LaNMaSteR53/recon-ng.git && \
curl 'https://portswigger.net/burp/releases/download?product=community&version=2.1.01&type=linux' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' -H 'Referer: https://portswigger.net/burp/communitydownload' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9' -H 'Cookie: ASP.NET_SessionId=5191FCB5C06D7EFCE1572BFA7C96E3367F9F9464FD43082D0E89C8B716660117791248413E382215' --compressed -o burpsuite_community_linux_v2_1_01.sh && \
git clone --depth=1 https://github.com/EmpireProject/Empire.git /opt/Empire && \
git clone --depth 1 https://github.com/HarmJ0y/CheatSheets && \
git clone --depth 1 https://github.com/aramosf/sqlmap-cheatsheet.git && \
git clone --depth 1 https://github.com/wsargent/docker-cheat-sheet.git && \
git clone --depth 1 https://github.com/paragonie/awesome-appsec.git && \
git clone --depth 1 https://github.com/enaqx/awesome-pentest && \
git clone --depth 1 https://github.com/samratashok/nishang.git && \
git clone --depth 1 https://github.com/rebootuser/LinEnum.git && \
git clone --depth 1 https://github.com/huntergregal/mimipenguin.git && \
git clone --depth 1 https://github.com/toolswatch/vFeed.git && \
git clone --depth 1 https://github.com/secretsquirrel/the-backdoor-factory && \
git clone --depth 1 https://github.com/FuzzySecurity/PowerShell-Suite.git && \
git clone --depth 1 https://github.com/madmantm/powershell && \
git clone --depth 1 https://github.com/scadastrangelove/SCADAPASS.git && \
git clone --depth 1 https://github.com/DanMcInerney/creds.py.git && \
git clone --depth 1 https://github.com/inquisb/keimpx && \
git clone --depth 1 https://github.com/sensepost/DET.git && \
git clone --depth 1 https://github.com/DanMcInerney/LANs.py.git && \
git clone --depth 1 https://github.com/lgandx/Responder && \
git clone --depth 1 https://github.com/arthepsy/ssh-audit.git && \
git clone --depth 1 https://github.com/DanMcInerney/net-creds.git && \
git clone --depth 1 https://github.com/covertcodes/multitun.git && \
git clone --depth 1 https://github.com/byt3bl33d3r/MITMf.git && \
git clone --depth 1 https://github.com/byt3bl33d3r/CrackMapExec.git && \
git clone --depth 1 https://github.com/m57/ARDT.git && \
git clone --depth 1 https://github.com/vanhauser-thc/thc-ipv6.git && \
git clone --depth 1 https://github.com/nccgroup/vlan-hopping.git && \
git clone --depth 1 https://github.com/Hood3dRob1n/Reverser.git && \
git clone --depth 1 https://github.com/SpiderLabs/ikeforce.git && \
git clone --depth 1 https://github.com/robertdavidgraham/masscan.git && \
git clone --depth 1 https://github.com/XiphosResearch/exploits.git && \
git clone --depth 1 https://github.com/wpscanteam/wpscan.git && \
git clone --depth 1 https://github.com/joaomatosf/jexboss.git && \
git clone --depth 1 https://github.com/internetwache/GitTools.git && \
git clone --depth 1 https://github.com/OsandaMalith/LFiFreak && \
git clone --depth 1 https://github.com/D35m0nd142/LFISuite.git && \
git clone --depth 1 https://github.com/P0cL4bs/Kadimus && \
git clone --depth 1 https://github.com/stasinopoulos/commix.git && \
git clone --depth 1 https://github.com/kost/dvcs-ripper && \
git clone --depth 1 https://github.com/mandatoryprogrammer/xssless.git && \
git clone --depth 1 https://github.com/tennc/webshell && \
git clone --depth 1 https://github.com/vs4vijay/heartbleed.git && \
git clone --depth 1 https://github.com/beefproject/beef && \
git clone --depth 1 https://github.com/Dionach/CMSmap.git && \
git clone --depth 1 https://github.com/droope/droopescan.git && \
git clone --depth 1 https://github.com/gfoss/attacking-drupal.git && \
git clone --depth 1 https://github.com/sullo/nikto.git && \
git clone --depth 1 https://github.com/gabtremblay/tachyon.git && \
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git && \
git clone --depth 1 https://github.com/WebBreacher/tilde_enum.git && \
git clone --depth 1 https://github.com/epinna/weevely3.git && \
git clone --depth 1 https://github.com/eschultze/URLextractor.git && \
git clone --depth 1 https://github.com/Greenwolf/Spray.git && \
git clone --depth 1 https://github.com/spinkham/skipfish.git && \
git clone --depth 1 https://github.com/chango77747/AdEnumerator && \
git clone --depth 1 https://github.com/Raikia/CredNinja && \
git clone --depth 1 https://github.com/ChrisTruncer/WMIOps && \
git clone --depth 1 https://github.com/FortyNorthSecurity/EyeWitness

# IDEs (VSCODE) - 229mb
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
RUN apt-get install -y apt-transport-https && apt-get update -y && apt-get install -y code && rm -rf /var/lib/apt/lists/*

# Set Background Image - In a round about way
#RUN cd /usr/share/backgrounds/xfce && rm -f *.jpg && wget -q www.google.com\test.png xfce-teal.jpg

# WorkDIR Set - seems to make VNC behave better //TODO FIX
ENV HOME /home/root
WORKDIR /home

# Preconfigure Xfce // TODO - Remove JUNK
COPY [ "./src/home/Desktop", "root/Desktop/" ]
COPY [ "./src/home/config/xfce4/panel", "root/.config/xfce4/panel/" ]
COPY [ "./src/home/config/xfce4/xfconf/xfce-perchannel-xml", "root/.config/xfce4/xfconf/xfce-perchannel-xml/" ]

# Wireshark Config - Not Working / TODO
#RUN groupadd wireshark && chown root:wireshark /usr/bin/dumpcap && usermod -a -G wireshark root && chgrp wireshark /usr/bin/dumpcap && setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap 

# EXPOSE Ports
EXPOSE 6901 5901

#Copy / Run Startup Scripts
COPY [ "./src/startup.sh", "/home/startup.sh" ]
#ENTRYPOINT ["/home/startup.sh"]
#CMD [ "--wait" ]