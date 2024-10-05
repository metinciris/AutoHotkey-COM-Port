# AutoHotkey-COM-Port
# AutoHotkey COM Port Barcode Reader

This AutoHotkey script reads barcode data from a COM port (e.g., COM4) and sends the data to the active window as keyboard input. The script automatically sends the data followed by the Enter key and also saves the scanned barcode to the clipboard.

## Features
- Reads data from a specified COM port.
- Sends the scanned barcode to the active window.
- Automatically presses the Enter key after each scan.
- Copies the scanned barcode to the clipboard.
- No filtering or character deletion; all characters are processed as received.

## Requirements
- [AutoHotkey](https://www.autohotkey.com/) v1 installed on your system.

## Usage

1. **Download or clone this repository.**
2. **Edit the script** to ensure the correct COM port is specified:
    ```autohotkey
    COMPort := "\\.\COM4" ; Replace COM4 with the appropriate port for your barcode reader.
    ```
3. **Run the script** using AutoHotkey.
4. **Use your barcode scanner**: When a barcode is scanned, the data will be sent to the active window, followed by the Enter key.

## Installation

1. Install [AutoHotkey](https://www.autohotkey.com/) if you don't have it installed.
2. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/barcode-reader-autohotkey.git
    ```
3. Modify the `COMPort` variable in the script to match your device's COM port.
4. Double-click the script file to run it.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

