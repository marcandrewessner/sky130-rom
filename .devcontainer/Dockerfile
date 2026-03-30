FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    VNC_RESOLUTION=1920x1080 \
    VNC_COLOR_DEPTH=24 \
    HOME=/home/designer \
    USER=designer

# Core packages: Xvfb + XFCE desktop + x11vnc (VNC backend) + noVNC + dev tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    xfce4 \
    xfce4-terminal \
    x11vnc \
    novnc \
    websockify \
    falkon \
    sudo \
    bash \
    curl \
    wget \
    git \
    nano \
    vim \
    htop \
    ca-certificates \
    dbus-x11 \
    at-spi2-core \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# =============================================================
# System-level tooling (runs as root)
# Add apt packages to the block above, or add RUN blocks here
# for tools that should live in /usr/local/bin etc.
# =============================================================

# Python 3.12 (Ubuntu 24.04 default — no PPA needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3-pip \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
    && update-alternatives --install /usr/bin/python  python  /usr/bin/python3.12 1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Scientific + ASIC Python libraries — system-wide, accessible by all users including designer
RUN pip3 install --no-cache-dir --break-system-packages \
        numpy \
        matplotlib \
        ipython \
        cocotb \
        cocotb-bus \
        click

# Create designer user with sudo rights
RUN useradd -m -s /bin/bash designer \
    && echo "designer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/designer \
    && chmod 0440 /etc/sudoers.d/designer

# Create workspace and set ownership
RUN mkdir -p /design && chown designer:designer /design

# Update icon cache so panel icons resolve correctly
RUN gtk-update-icon-cache -f /usr/share/icons/hicolor/

# Copy entrypoint and desktop setup script
COPY --chown=designer:designer entrypoint.sh /home/designer/entrypoint.sh
COPY --chown=designer:designer setup-desktop.sh /home/designer/setup-desktop.sh
RUN chmod +x /home/designer/entrypoint.sh /home/designer/setup-desktop.sh \
    && chown -R designer:designer /home/designer

USER designer

# =============================================================
# User-level tooling (runs as designer)
# Install nvm, rustup, pipx, npm globals, dotfile tools etc.
# These land in ~/.local, ~/.cargo, ~/.nvm and so on.
# =============================================================

# Configure XFCE panel launchers
RUN /home/designer/setup-desktop.sh

# Run the custom setup
COPY --chown=designer:designer custom-setup.sh /home/designer/custom-setup.sh
RUN chmod +x /home/designer/custom-setup.sh
RUN /home/designer/custom-setup.sh


WORKDIR /design

EXPOSE 8888

ENTRYPOINT ["/home/designer/entrypoint.sh"]
