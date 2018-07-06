FROM cubeearth/wine:ubuntu_bionic

ENV DEBIAN_FRONTEND=noninteractive
ENV WINEARCH=win32
ENV WINEPREFIX=/home/desktop/.wine32
ENV LOGNAME=desktop
ENV USER=desktop
ENV HOME=/home/desktop

RUN echo 'export WINEARCH=win32' >> /etc/profile && \
	echo 'export WINEPREFIX=/home/desktop/.wine32' >> /etc/profile && \
#	mkdir /tmp/.X11-unix && \
	cat /etc/profile && \
	echo "# $WINEARCH $WINEPREFIX" && \
#	apt-get install xvfb && \
#	Xvfb :0 -screen 0 1024x768x16 &
	wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
	chmod +x winetricks && \
	mv -v winetricks /usr/local/bin

RUN apt-get install -y xorg xvfb xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

RUN apt-get install -y cups

RUN apt-get install -y xvfb && \
#	Xvfb :1 -ac -pixdepths 8 16 24 32 -screen 0 1024x768x24 +extension GLX +extension RANDR +render -noreset &
	Xvfb :1 -screen 0 1024x768x16 &
	
#ENV DISPLAY=:1

USER desktop
#RUN echo "# $WINEARCH $WINEPREFIX $DISPLAY" && \
#	WINEDLLOVERRIDES="mshtml=" xvfb-run --server-args="-ac +extension GLX +extension RANDR +render -noreset" wine wineboot --init && \
##	WINEDLLOVERRIDES="mscoree,mshtml=" wine wineboot && wineserver -w && \
###	wine REG ADD 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' /v ProgramFiles /t REG_SZ /d 'C:\Program Files' /f && \
###	wine REG ADD 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' /v SystemDrive /t REG_SZ /d 'C:' /f && \
###	winetricks win7 && \
#	echo x

RUN echo "# $WINEARCH $WINEPREFIX $DISPLAY" && \
	WINEDLLOVERRIDES="mshtml=" wine wineboot --init && \
###	wine REG ADD 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' /v ProgramFiles /t REG_SZ /d 'C:\Program Files' /f && \
###	wine REG ADD 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' /v SystemDrive /t REG_SZ /d 'C:' /f && \
#	winetricks win7 && \
	winetricks winxp && \
	winetricks -q dotnet40 && \
#	winetricks -q dotnet46 && \
	echo x

RUN mkdir -p /tmp/downloads && cd /tmp/downloads && \
#	wget https://download.microsoft.com/download/4/9/0/49001df1-af88-4a4d-b10f-2d5e3a8ea5f3/dotnetfx30SP1setup.exe && \
	wget --content-disposition http://go.microsoft.com/fwlink/?linkid=863265 && \
	curl -L https://sourceforge.net/projects/wine/files/Wine%20Gecko/2.40/wine_gecko-2.40.msi/download > wine-gecko.msi && \
	curl -L http://support.apple.com/downloads/DL999/en_US/BonjourPSSetup.exe > BonjourPSSetup.exe && \
	cabextract BonjourPSSetup.exe && \
	curl -L `curl -Ls https://agilebits.com/downloads | grep -E '<a .* data-event-action="Windows"' | head -n 1 | sed -E 's/^.* href="([^"]*)".*$/\1/'` > 1p-setup.exe
	

USER root
RUN echo "Europe/Berlin" > /etc/timezone
#RUN apt-get install -y mono-complete
RUN echo "allowed_users=anybody" > /etc/X11/Xwrapper.config
RUN cp /etc/xpra/xorg.conf /etc/X11/xpra-xorg.conf

USER desktop

RUN cd /tmp/downloads && \
	( WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 wine msiexec /i wine-gecko.msi /qn || ( a=$? ; [ $a -eq 91 ] || exit $a ) ) && \
	wine msiexec /i Bonjour.msi /qn && \
	winetricks win7 && \
#	wine NDP472-KB4054530-x86-x64-AllOS-ENU.exe /quiet /norestart && \
	echo x

#RUN mkdir -p /tmp/downloads && cd /tmp/downloads && \
#	wget https://download.microsoft.com/download/4/9/0/49001df1-af88-4a4d-b10f-2d5e3a8ea5f3/dotnetfx30SP1setup.exe
	
#RUN winetricks win7

# wget https://dl.winehq.org/wine/wine-mono/4.7.2/wine-mono-4.7.2.msi
# wine msiexec /i wine-mono-4.7.2.msi /qn

#RUN mkdir -p /tmp/downloads && cd /tmp/downloads && \
#	wine dotnetfx30SP1setup.exe /quiet /norestart

# RUN wget --content-disposition http://go.microsoft.com/fwlink/?linkid=863265 && \
#	wine NDP472-KB4054530-x86-x64-AllOS-ENU.exe /quiet /norestart

#RUN echo "# $WINEARCH $WINEPREFIX $DISPLAY" && \
#	winetricks win7 && \
#	winetricks dotnet20 && \
#	winetricks -q dotnet46

#SHELL [ "/bin/bash", "-l" ]

#RUN \ 
##set -xe						&& \
#	bash -lc 'echo $WINEPREFIX; WINEDLLOVERRIDES="mscoree,mshtml=" xvfb-run --auto-servernum --server-args="-screen 0 640x480x24:32" wine wineboot --init' && \
#	echo "--- 1 ----------" && \
#	bash -lc "xvfb-run wineserver -w" 		&& \
#	echo "--- 2 ----------" && \
#	bash -lc "xvfb-run winetricks -q vcrun2015"  && \
#	echo "--- 3 ----------"

#RUN bash -lc "xvfb-run winetricks win7" && \
#	echo "--- 4 ----------" && \
#	bash -lc "xvfb-run winetricks -q dotnet46" && \
#	echo "--- 5 ----------"


#RUN winetricks dotnet46


#USER desktop
#RUN . /etc/profile && \
##	bash /usr/scripts/start_display.sh && \
##	. ~/display.env && \
#	env && \
#	mkdir -p /tmp/downloads && cd /tmp/downloads && \
#	WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 wine wineboot --init
	
## https://app-updates.agilebits.com/download/OPW4
#RUN mkdir -p /tmp/downloads && cd /tmp/downloads && \
#	curl -L https://sourceforge.net/projects/wine/files/Wine%20Mono/4.5.6/wine-mono-4.5.6.msi/download > wine-mono.msi && \
#	WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 wine msiexec /i wine-mono.msi /qn && \
#	echo "pwd: $PWD" && \
#	curl -L https://sourceforge.net/projects/wine/files/Wine%20Gecko/2.40/wine_gecko-2.40.msi/download > wine-gecko.msi && \
#	ls -dl * && \
#    ( WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 wine msiexec /i wine-gecko.msi /qn || ( a=$? ; [ $a -eq 91 ] || exit $a ) ) && \
#	echo "-1" && \
#	curl -L http://support.apple.com/downloads/DL999/en_US/BonjourPSSetup.exe > BonjourPSSetup.exe && \
#	cabextract BonjourPSSetup.exe && \
#	wine msiexec /i Bonjour.msi /qn && \
#	echo x
	
#RUN cd /tmp/downloads && \
#	curl -L `curl -Ls https://agilebits.com/downloads | grep -E '<a .* data-event-action="Windows"' | head -n 1 | sed -E 's/^.* href="([^"]*)".*$/\1/'` > 1p-setup.exe && \
##	WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 wine 1p-setup.exe /verysilent /lang=en && \
#	echo x

#USER root

##RUN apt-get install -y winetricks

#RUN apt-get install -y libntlm0

#RUN apt-get remove winetricks && \
#	wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
#	chmod +x winetricks && \
#	mv -v winetricks /usr/local/bin

#USER desktop

##RUN WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 wine cmd.exe /c echo '%ProgramFiles%' && \
##	export ProgramFiles='C:\Program Files' && \
##	WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 winetricks win7 && \
##	WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 winetricks -q msxml3 && \
##	WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 winetricks -q dotnet46

##WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 wine REG ADD 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' /v ProgramFiles /t REG_SZ /d 'C:\Program Files'
##WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 wine REG ADD 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' /v SystemDrive /t REG_SZ /d 'C:'

## WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 wine REG ADD HKLM\\Software\\Microsoft\\.NETFramework /v InstallRoot /t REG_SZ /d C:\\Windows\\Microsoft.NET\\Framework
## WINEARCH=win32 WINEPREFIX=/home/desktop/.wine32 wine REG Query HKLM\\Software\\Microsoft\\.NETFramework /v InstallRoot

# wine "/home/desktop/.wine32/drive_c/users/desktop/Local Settings/Application Data/1password/app/7/1Password.exe"

USER root
	
COPY home/ /home/desktop/
RUN chown -R desktop /home/desktop

