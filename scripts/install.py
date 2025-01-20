import os
import subprocess
import shutil

def install_packages(package_manager):
    packages = ["zip" "zsh" "openrgb" "fish" "unzip" "wget" "curl" "neovim" "eza" "neofetch" "btop" "gamemode" "mangohud" "zoxide" "fzf" "bat" "kitty"]
    for package in packages:
        try:
            if package_manager == 'pacman':
                subprocess.run(['sudo', 'pacman', '-S', '--no-confirm', package], check=True)
            subprocess.run([package_manager, 'install', '-y', package], check=True)
        except subprocess.CalledProcessError:
            print(f"Failed to install {package}")
            exit(1)

def copy_dotfiles():
    print("Adding btop config")

    btop_config_dir = os.path.expanduser('~/.config/btop')
    if not os.path.exists(btop_config_dir):
        os.makedirs(btop_config_dir)

    btop_config_src = os.path.expanduser('~/Linux/btop/btop.conf')
    shutil.copy(btop_config_src, btop_config_dir)

    print("Finished!")

    print("Adding kitty config")

    kitty_config_dir = os.path.expanduser('~/.config/kitty')
    if not os.path.exists(kitty_config_dir):
        os.makedirs(kitty_config_dir)

    kitty_config_src = os.path.expanduser('~/Linux/kitty/')
    shutil.copytree(kitty_config_src, kitty_config_dir, dirs_exist_ok=True)

    print("Finished!")

    # Adding neovim plugin
    print("Adding neovim plugin")
    print("Running neovim script")

    neovim_script = os.path.expanduser('~/Linux/scripts/neovim.sh')
    subprocess.run(['bash', neovim_script])

    nvim_plugin_dir = os.path.expanduser('~/.config/nvim/lua/plugins/')
    if not os.path.exists(nvim_plugin_dir):
        os.makedirs(nvim_plugin_dir)

    print("Finished!")

    print("Adding font and cursor")

    # Copy font
    font_src = os.path.expanduser('~/Linux/Fonts/MesloLGS NF Regular.ttf')
    font_dest = '/usr/share/fonts/'
    shutil.copy(font_src, font_dest)

    # Copy cursor
    cursor_src = os.path.expanduser('~/Linux/Cursor/Bibata-Modern-Ice/')
    cursor_dest = '/usr/share/icons/'
    shutil.copytree(cursor_src, cursor_dest, dirs_exist_ok=True)

    print("Finished!")

    shell = input("Use (1) fish or (2) zsh? ")
    if shell == '2':
        print("Adding zshrc")

        subprocess.run(['bash', os.path.expanduser('~/Linux/scripts/p10k-theme.sh')])
        zshrc_src = os.path.expanduser('~/Linux/zsh/fedorazshrc')
        zshrc_dest = os.path.expanduser('~/.zshrc')
        shutil.copy(zshrc_src, zshrc_dest)

        print("Finished!")

    elif shell == '1':
        print("Adding fish config")

        fish_config_src = os.path.expanduser('~/Linux/fish/fedora.fish')
        fish_config_dest = os.path.expanduser('~/.config/fish/config.fish')
        shutil.copy(fish_config_src, fish_config_dest)

        print("Finished!")

def configure_git():
    gitconfig = input("Want to configure git? (y/n): ")
    if gitconfig.lower() == 'y':
        username = input("What is your GitHub username? ")
        subprocess.run(['git', 'config', '--global', 'user.name', username])
        useremail = input("What is your email address? ")
        subprocess.run(['git', 'config', '--global', 'user.email', useremail])

def add_ssh_key():
    sshready = input("Ready to add ssh-key? (y/n): ")
    if sshready.lower() == 'y':
        print("Do not change the default file location and name in the following!!!")
        email = input("What is your email address? ")
        subprocess.run(['ssh-keygen', '-t', 'ed25519', '-C', email])
        subprocess.run(['ssh-add', os.path.expanduser('~/.ssh/id_ed25519')])
        with open(os.path.expanduser('~/.ssh/id_ed25519.pub'), 'r') as f:
            print("Paste the following content in your ssh-key section on GitHub:")
            print(f.read())

def add_wallpaper():
    wallpaper_dir = os.path.expanduser('~/Pictures/wallpaper')
    if not os.path.exists(wallpaper_dir):
        os.makedirs(wallpaper_dir)
    wallpaper_url = input("Enter the URL of the wallpaper: ")
    wallpaper_path = os.path.join(wallpaper_dir, 'wallpaper.jpg')
    subprocess.run(['wget', wallpaper_url, '-O', wallpaper_path])
    subprocess.run(['gsettings', 'set', 'org.gnome.desktop.background', 'picture-uri', f'file://{wallpaper_path}'])

def main():
    package_manager = input("Enter your package manager (e.g., apt, dnf, zypper, pacman): ")
    install_packages(package_manager)
    configure_git()
    add_ssh_key()
    add_wallpaper()
    copy_dotfiles()

if __name__ == "__main__":
    main()
