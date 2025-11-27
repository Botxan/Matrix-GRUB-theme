<h1 align="center">Matrix GRUB Theme (Red Pill vs Blue Pill)</h1>
<div align="center">
  <img width="600" src="preview.gif">
  <p align="center"><i>“I Can Only Show You The Door. You're The One That Has To Walk Through It.”</i></p>
  <p align="center"><i>~Morpheus</i></p>
</div>

## ⚠️ Requirements & Warnings

* **Resolution:** Designed for **1920x1080**. If your monitor is different, you must edit `theme.txt` and `installer.sh` before running.
* **Operating Systems:** Designed for **Kali Linux** and **Windows** dual-boot.
* **Critical:** This theme requires editing the `/etc/grub.d/40_custom` file with your correct partition **UUIDs**. Failure to do so will result in an unbootable system.

## Installation Steps

1.  **Clone the Repository** and enter the directory.
    ```bash
    git clone https://github.com/Botxan/Matrix-GRUB-theme
    cd Matrix-GRUB-theme
    ```

2.  **Find Your UUIDs:**
    Use `lsblk -f` or `sudo blkid` to find the UUIDs for:
    * Your Kali root partition (e.g., `ext4` type).
    * Your Windows EFI partition (e.g., `vfat` type).

3.  **Edit `40_custom`:**
    Open the file and replace the placeholders: `YOUR_KALI_ROOT_PARTITION_UUID` and `YOUR_WINDOWS_EFI_PARTITION_UUID` with your actual UUIDs.

4.  **Run the Installer:**
    ```bash
    sudo ./installer.sh
    ```
    This script will:
    * Create the theme directory (`/boot/grub/themes/Matrix`).
    * Generate the necessary `font.pf2`.
    * Copy the theme files and your customized `40_custom`.
    * Update `/etc/default/grub`.
    * Generate a new `grub.cfg`.

5.  **Reboot** and enjoy the theme!

## Attributions
You can find the original project designed for Arch Linux and Windows [here](https://github.com/jigurdas/Matrix-GRUB-Theme).
