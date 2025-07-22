# zsh-adb-select-device

zsh-adb-select-device is a Zsh plugin that simplifies using ADB when multiple devices are connected. When you run `adb` command, it checks the number of connected devices. If more than one device is found, it prompts you to select a device to which the command will be directed. 

![Demo](./screen_recording.gif)


## Features

- **Automatic Device Selection:** When multiple devices are connected, you'll be prompted to select one.
- **Seamless Integration:** Works with your existing `adb` commands.
- **Device Model Display:** Shows the device model for easier identification.
- **Command Exclusion:** Certain commands like `adb devices`, `adb kill-server`, and `adb start-server` are excluded from the selection prompt for convenience.

## Installation

1.  **Clone the repository into your Oh My Zsh custom plugins directory:**
    ```sh
    git clone https://github.com/KorionCN/zsh-adb-select-device.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-adb-select-device
    ```

2.  **Add the plugin to your `.zshrc` file:**
    Open your `.zshrc` file and add `zsh-adb-select-device` to the `plugins` array:
    ```zsh
    plugins=(... zsh-adb-select-device)
    ```

4.  **Restart your terminal or source your `.zshrc` file:**
    ```sh
    source ~/.zshrc
    ```

## Usage

Simply use `adb` commands as you normally would. If multiple devices are connected, a prompt will appear, allowing you to select the target device.

```
$ adb shell
Multiple ADB devices found. Please select one:
1) emulator-5554 (sdk_gphone_x86)
2) R58M40G5Y4P (SM-G973F)
#? 1
Using device: emulator-5554
$
```

## How It Works

The plugin creates a wrapper function named `_zsh_adb_select_device_wrapper` and aliases the `adb` command to this function.

When you run an `adb` command:
1.  It checks if the `-s` flag is already present. If so, it executes the command as is.
2.  It retrieves a list of connected devices using `adb devices`.
3.  If more than one device is detected, it displays a selection menu showing the device serial number and model.
4.  Once you select a device, the original `adb` command is executed with the `-s <selected_device_serial>` flag.
5.  If zero or one device is connected, the command runs without any changes.

## License

This project is licensed under the MIT License.