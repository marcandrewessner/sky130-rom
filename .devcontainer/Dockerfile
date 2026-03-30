# =============================================================
# BASE IMAGE & ENVIRONMENT
# Ubuntu 24.04 LTS is the foundation. ENV vars here are baked
# into every layer and available to all processes at runtime.
# =============================================================
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    VNC_RESOLUTION=1920x1080 \
    VNC_COLOR_DEPTH=24 \
    HOME=/home/designer \
    USER=designer


# =============================================================
# DESKTOP ENVIRONMENT  (root)
# The full GUI stack: virtual display (Xvfb), XFCE desktop,
# VNC backend (x11vnc), noVNC web proxy, and the Falkon browser.
# Add or swap desktop packages here (e.g. a different browser,
# file manager, or window manager).
# =============================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    xfce4 \
    xfce4-terminal \
    x11vnc \
    novnc \
    websockify \
    falkon \
    dbus-x11 \
    at-spi2-core \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# =============================================================
# SYSTEM TOOLS  (root)
# General-purpose CLI utilities available to every user.
# Add apt packages here for tools that belong in /usr/bin or
# /usr/local/bin (compilers, linters, build tools, etc.).
# =============================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    bash \
    curl \
    wget \
    git \
    nano \
    vim \
    htop \
    make-guile \
    ca-certificates \
    iverilog \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# =============================================================
# PYTHON RUNTIME  (root, system-wide)
# Python 3.12 ships in the Ubuntu 24.04 default repos — no PPA
# needed. To switch version change 3.12 → 3.x below. For a
# version newer than what Ubuntu ships, add the deadsnakes PPA
# before the apt-get install block.
# =============================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3-pip \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
    && update-alternatives --install /usr/bin/python  python  /usr/bin/python3.12 1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# =============================================================
# PYTHON PACKAGES  (root, system-wide)
# Installed once, accessible to all users including designer.
# Add pip packages here. --break-system-packages is required on
# Ubuntu 24.04+ for system-wide pip installs inside a container.
# =============================================================
RUN pip3 install --no-cache-dir --break-system-packages \
    numpy \
    matplotlib \
    ipython \
    pytest \
    cocotb \
    cocotb-bus \
    click


# =============================================================
# USER & WORKSPACE  (root)
# Creates the designer user with passwordless sudo, sets up the
# /design workspace, copies startup scripts, and fixes ownership.
# Do not move the chown below USER designer — it must run as root.
# =============================================================
RUN useradd -m -s /bin/bash designer \
    && echo "designer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/designer \
    && chmod 0440 /etc/sudoers.d/designer

RUN mkdir -p /design && chown designer:designer /design

RUN gtk-update-icon-cache -f /usr/share/icons/hicolor/

COPY --chown=designer:designer entrypoint.sh    /home/designer/entrypoint.sh
COPY --chown=designer:designer setup-desktop.sh /home/designer/setup-desktop.sh
COPY --chown=designer:designer custom-setup.sh  /home/designer/custom-setup.sh
RUN chmod +x \
        /home/designer/entrypoint.sh \
        /home/designer/setup-desktop.sh \
        /home/designer/custom-setup.sh \
    && chown -R designer:designer /home/designer


# =============================================================
# DESKTOP CONFIGURATION  (designer)
# Runs as the designer user to configure the XFCE panel and
# desktop launchers under ~/.config. Anything that writes to the
# user's home directory belongs here.
# =============================================================
USER designer

RUN /home/designer/setup-desktop.sh


# =============================================================
# CUSTOM SETUP  (designer)
# Project-specific user-level tools: nvm, rustup, pipx packages,
# dotfiles, shell aliases, etc. Edit custom-setup.sh to extend.
# =============================================================
RUN /home/designer/custom-setup.sh


# =============================================================
# LAUNCH
# The workspace is bind-mounted at /design at runtime.
# Port 8888 serves the noVNC web desktop.
# =============================================================
WORKDIR /design

EXPOSE 8888

ENTRYPOINT ["/home/designer/entrypoint.sh"]
