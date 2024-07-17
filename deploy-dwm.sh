#!/bin/bash

# Install the dependencies
install_arch() {
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm base-devel libconfig dbus libev libx11 libxcb libxext libgl libegl libepoxy meson pcre2 pixman uthash xcb-util-image xcb-util-renderutil xorgproto cmake \
        playerctl rofi flameshot dunst noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji \
        ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    case $ID in 
        arch)
            echo "Installing dependencies"
            install_arch
            ;;
    esac
else
    echo "/etc/os-release not found. Unsupported distribution"
    exit 1
fi


picom_animations() {
    # Clone the repository in the home/build directory
    mkdir -p $HOME/build
    if [ ! -d $HOME/build/picom ]; then
        if ! git clone https://github.com/FT-Labs/picom.git ~/build/picom; then
            echo "Failed to clone the repository"
            return 1
        fi
    else
        echo "Repository already exists, skipping clone"
    fi

    cd $HOME/build/picom || { echo "Failed to change directory to picom"; return 1; }

    # Build the project
    if ! meson setup --buildtype=release build; then
        echo "Meson setup failed"
        return 1
    fi

    if ! ninja -C build; then
        echo "Ninja build failed"
        return 1
    fi

    # Install the built binary
    if ! sudo ninja -C build install; then
        echo "Failed to install the built binary"
        return 1
    fi

    echo "Picom animations installed successfully"
}

dwm_install(){
    if [ ! -d $HOME/.config/dwm ]; then
        if ! git clone https://github.com/GabzDK/dkwm $HOME/.config/dwm; then
            echo "Failed to clone the DWM repository"
            return 1
        fi
    else
        echo "Repository already exists"
    fi
    cd $HOME/.config/dwm || { echo "Failed to change dir to dwm"; return 1; }

    # Build dwm
    if ! sudo make clean install; then
        echo "Could not build DWM"
        return 1
    fi
    echo "DWM installed!"
}
st_install(){
    if [  ! -d $HOME/.config/st ]; then
        if !git https://github.com/GabzDK/dkst $HOME/.config/st; then
            echo "Failed to clone the ST repository"
            return 1
        fi
    else
        echo "Repository already exists"
    fi
    cd $HOME/.config/st || { echo "Failed to change dir to dwm"; return 1; }

    # Build ST
    if ! sudo make clean install; then
        echo "Could not build ST"
        return 1
    fi

    echo "ST installed!"
}
config_dir(){
    
}
# Call the function
picom_animations
dwm_install
st_install
