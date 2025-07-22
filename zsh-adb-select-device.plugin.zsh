# zsh_adb_select_device plugin

# This is a placeholder for the main plugin logic.
echo "zsh_adb_select_device plugin loaded"


_zsh_adb_select_device_wrapper() {
    # Check if -s is already in the arguments
    for arg in "$@"; do
        if [[ "$arg" == "-s" ]]; then
            # -s is present, just run the command
            command adb "$@"
            return $?
        fi
    done

    # Get the list of devices
    local devices
    devices=$(command adb devices | awk 'NR>1 && NF==2 && $2=="device" {print $1}')

    # Count the number of devices
    local device_count
    device_count=$(echo "$devices" | grep -c .)

    # If there is more than one device, prompt for selection
    if [[ $device_count -gt 1 ]]; then
        # Don't prompt for some commands
        case "$1" in
            devices|kill-server|start-server)
                command adb "$@"
                return $?
                ;;
        esac

        echo "Multiple ADB devices found. Please select one:"
        
        local device_list
        device_list=(${(f)devices}) # split by newline

        local device_options=()
        for device in "${device_list[@]}"; do
            local model
            model=$(command adb -s "$device" shell getprop ro.product.model 2>/dev/null | tr -d '\r')
            device_options+=("$device ($model)")
        done
        
        select device_option in "${device_options[@]}"; do
            if [[ -n "$device_option" ]]; then
                # Extract device serial from "serial (model)"
                local device
                device=$(echo "$device_option" | awk '{print $1}')
                echo "Using device: $device"
                # Run the original command with the selected device
                command adb -s "$device" "$@"
                return $?
            else
                echo "Invalid selection. Aborting."
                return 1
            fi
        done
    else
        # If 0 or 1 device, just run the command
        command adb "$@"
    fi
}

alias adb='_zsh_adb_select_device_wrapper'