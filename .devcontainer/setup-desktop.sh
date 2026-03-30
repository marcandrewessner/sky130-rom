#!/bin/bash
# Configure XFCE panel launchers: Terminal, File Manager, Falkon, App Finder

mkdir -p \
  /home/designer/.config/xfce4/panel/launcher-17 \
  /home/designer/.config/xfce4/panel/launcher-18 \
  /home/designer/.config/xfce4/panel/launcher-19 \
  /home/designer/.config/xfce4/panel/launcher-20

# launcher-17: Terminal
cat > /home/designer/.config/xfce4/panel/launcher-17/17748671211.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Exec=exo-open --launch TerminalEmulator
Icon=org.xfce.terminalemulator
StartupNotify=true
Terminal=false
Categories=Utility;X-XFCE;X-Xfce-Toplevel;
OnlyShowIn=XFCE;
Name=Terminal Emulator
Comment=Use the command line
X-XFCE-Source=file:///usr/share/applications/xfce4-terminal-emulator.desktop
EOF

# launcher-18: File Manager
cat > /home/designer/.config/xfce4/panel/launcher-18/17748671212.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Exec=exo-open --launch FileManager %u
Icon=org.xfce.filemanager
StartupNotify=true
Terminal=false
Categories=Utility;X-XFCE;X-Xfce-Toplevel;
OnlyShowIn=XFCE;
X-XFCE-MimeType=inode/directory;x-scheme-handler/trash;
Name=File Manager
Comment=Browse the file system
X-XFCE-Source=file:///usr/share/applications/xfce4-file-manager.desktop
EOF

# launcher-19: Falkon
cat > /home/designer/.config/xfce4/panel/launcher-19/17748671213.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Exec=/home/designer/launch-falkon.sh
Icon=falkon
StartupNotify=true
Terminal=false
Categories=Network;WebBrowser;
Name=Falkon
Comment=A fast and secure web browser
StartupWMClass=Falkon
X-XFCE-Source=file:///usr/share/applications/org.kde.falkon.desktop
EOF

# launcher-20: App Finder
cat > /home/designer/.config/xfce4/panel/launcher-20/17748671214.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Exec=xfce4-appfinder
Icon=org.xfce.appfinder
StartupNotify=true
Terminal=false
Categories=Utility;X-XFCE;
Name=Application Finder
Comment=Find and launch applications installed on your system
X-XFCE-Source=file:///usr/share/applications/xfce4-appfinder.desktop
EOF

# Falkon wrapper
cat > /home/designer/launch-falkon.sh << 'EOF'
#!/bin/bash
falkon
EOF
chmod +x /home/designer/launch-falkon.sh
