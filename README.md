# WSLGuiPowershell

## Overview

WSLGuiPowershell is a PowerShell script designed to create a simple graphical user interface (GUI) for executing command-line tools in Windows Subsystem for Linux (WSL). This script is particularly useful for integrating command-line tools with a user-friendly interface, enhancing the accessibility and usability of these tools for users who prefer graphical interactions.

## Features

- **Dynamic GUI Creation:** Generates a Windows Forms-based GUI dynamically for any command-line tool.
- **Customizable Options:** Allows users to specify command arguments and options through an intuitive interface.
- **Regex Validation:** Includes regular expressions for validating input such as domain names and IP addresses.
- **Image Integration:** Supports adding an image to the GUI, enhancing visual appeal.

## Prerequisites

- Windows 10 or later with WSL installed.
- PowerShell 5.1 or higher.
- Internet connection (for downloading images).

## Installation

1. Clone the repository:
   \\\bash
   git clone https://github.com/pentestfunctions/WSLGuiPowershell.git
   \\\
2. Navigate to the cloned directory.

## Usage

1. Open PowerShell and navigate to the directory containing the script.
2. To run the script, type the following command:
   ```powershell
   .\\template.ps1
   ```
3. A GUI window will appear, allowing you to interact with the specified command-line tool through a graphical interface.

### Configuring the Script

- Edit the \`template.ps1\` file to configure the script for your specific command-line tool.
- Modify the user-configurable variables at the beginning of the script to customize the GUI elements and functionality.

### Running with Double Click (Optional)

To enable running the script with a double click:

1. Open Command Prompt as administrator.
2. Run the following commands:
   \\\bash
   assoc .ps1=Microsoft.PowerShellScript.1
   ftype Microsoft.PowerShellScript.1="%SystemRoot%\\system32\\WindowsPowerShell\\v1.0\\powershell.exe" -ExecutionPolicy Bypass -File "%1" %*
   \\\

## Contributing

Contributions to improve WSLGuiPowershell are welcome. Feel free to fork the repository and submit pull requests.

## License

This project is licensed under [specify license]. See the LICENSE file for details.
