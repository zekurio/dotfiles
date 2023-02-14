# Part of the setup script. Checks for packages and installs them if they are not installed.

# for g
export GOPATH="$HOME/go"

export GOROOT="$HOME/.go"

# first, some variables
# here we define the packages we want to install
PACMAN_PACKAGES="git zsh starship rustup base-devel otf-firacode-nerd otf-cascadia-code-nerd"

# if we are in WSL, we add some more packages
if [ -n "$WSL2" ]; then
    PACMAN_PACKAGES="$PACMAN_PACKAGES socat"
fi

AUR_PACKAGES="paru-git"

echo "Updating package lists..."
sudo pacman -Syu

# now we install the packages
echo "Checking for packages..."
for package in $PACKAGES; do
    if [ -x "$(command -v $package)" ]; then
        echo "$package is already installed."
    else
        echo "$package is not installed. Installing..."
        sudo pacman -S --noconfirm $package
    fi
done

# now we build and install paru
echo "Checking for paru..."
if [ -x "$(command -v paru)" ]; then
    echo "paru is already installed."
else
    echo "paru is not installed. Installing..."
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    rm -rf paru
fi

# now we install paru from the AUR
echo "Checking for packages from the AUR..."
for package in $AUR_PACKAGES; do
    if [ -x "$(command -v $package)" ]; then
        echo "$package is already installed."
    else
        echo "$package is not installed. Installing..."
        paru -S --noconfirm $package
    fi
done

# now we install packages like g which are not in the official repos
echo "Checking for g..."
if [ -x "$(command -v g)" ]; then
    echo "g is already installed."
else
    echo "g is not installed. Installing..."
    curl -sSL https://git.io/g-install | sh -s -- -y
fi