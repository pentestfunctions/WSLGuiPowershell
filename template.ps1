# Importing Required Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Net.Http

############################################################################################################################################

# User-Configurable Variables
$commandName = 'dirsearch'
$formTitle = 'Dirsearch Scanner by Robot'
$formWidth = 350  # Width of the entire application
$formHeight = 600 # Height of the entire application
$formSize = New-Object System.Drawing.Size($formWidth, $formHeight)
$optionsListViewWidth = 300  # Width of the options box
$optionsListViewHeight = 80 # Height of the options box
$imageUrl = "https://github.com/pentestfunctions/konsole-quickcommands/raw/main/konsole_commands.png" # Make sure it's a PNG image
$pictureBoxSize = New-Object System.Drawing.Size(280, 200) # Height, Width of the image downloaded
$initialControlY = 220
$domainRegex = '^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$' # Regex for matching a domain
$ipRegex = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$' # Regex for matching an IP


# Option is for command arguments, Description for what that argument does and Position to be Before or After the domain
$commandOptions = @(
    @{Option = '-u'; Description = 'Target URL'; Position = 'Before'},
    @{Option = '-e'; Description = 'Extensions'; Position = 'After'}
    # Add more command specific options here...
)


############################################################################################################################################

# Function Definitions
function Download-Image($url, $path) {
    $client = New-Object System.Net.Http.HttpClient
    $response = $client.GetAsync($url).Result
    $bytes = $response.Content.ReadAsByteArrayAsync().Result
    [System.IO.File]::WriteAllBytes($path, $bytes)
}

# Function Definitions
function Download-Image($url, $path) {
    $client = New-Object System.Net.Http.HttpClient
    $response = $client.GetAsync($url).Result
    $bytes = $response.Content.ReadAsByteArrayAsync().Result
    [System.IO.File]::WriteAllBytes($path, $bytes)
}

function ShowExplanation($description) {
    [System.Windows.Forms.MessageBox]::Show($description, 'Option Explanation', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

function Update-CurrentCommand {
    $inputText = $textBox.Text
    $beforeOptions = ($optionsListView.Items | Where-Object { $_.Checked -and $_.Tag.Position -eq 'Before' }).ForEach({ $_.Text }) -join ' '
    $afterOptions = ($optionsListView.Items | Where-Object { $_.Checked -and $_.Tag.Position -eq 'After' }).ForEach({ $_.Text }) -join ' '
    $currentCommand = "$commandName $beforeOptions $inputText $afterOptions"
    $currentCommandLabel.Text = "Current Command: $currentCommand"
}

# GUI Component Creation
$form = New-Object System.Windows.Forms.Form
$form.Text = $formTitle
$form.Size = $formSize
$form.StartPosition = 'CenterScreen'

# Download and Load Image
$imagePath = [System.IO.Path]::GetTempFileName() + ".png"
Download-Image $imageUrl $imagePath
try {
    $image = [System.Drawing.Image]::FromFile($imagePath)
} catch {
    [System.Windows.Forms.MessageBox]::Show("Error loading image", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    return
}

# PictureBox
$pictureBox = New-Object System.Windows.Forms.PictureBox
$pictureBox.Size = $pictureBoxSize
$pictureBox.Location = New-Object System.Drawing.Point(10, 10)
$pictureBox.SizeMode = 'StretchImage'
$pictureBox.Image = $image
$form.Controls.Add($pictureBox)

# Label for domain entry
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, $initialControlY) # X, Y coordinates
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter a domain or IP:'
$form.Controls.Add($label)

# TextBox for domain entry
$textBoxLocationY = $initialControlY + 30
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, $textBoxLocationY)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

# ListView for Command options
$listViewLocationY = $initialControlY + 60
$optionsListView = New-Object System.Windows.Forms.ListView
$optionsListView.Location = New-Object System.Drawing.Point(10, $listViewLocationY)
$optionsListView.Size = New-Object System.Drawing.Size($optionsListViewWidth, $optionsListViewHeight)
$optionsListView.View = [System.Windows.Forms.View]::Details
$optionsListView.CheckBoxes = $true
$optionsListView.Columns.Add('Option', 100)
$optionsListView.Columns.Add('Info', 200)  # Adjusted to fit the width
$form.Controls.Add($optionsListView)

# Adding items to ListView using the configurable $commandOptions array
foreach ($option in $commandOptions) {
    $item = New-Object System.Windows.Forms.ListViewItem($option.Option)
    $item.SubItems.Add($option.Description)
    $item.Tag = $option # Store the entire option object in the Tag property
    $optionsListView.Items.Add($item)
}

# Adjust the column widths
$optionsListView.Columns[0].Width = 95
$optionsListView.Columns[1].Width = 200

# Event handler for ListView item check
$optionsListView.Add_ItemChecked({
    Update-CurrentCommand
})

# Label for current command
$currentCommandLabelLocationY = $initialControlY + 220
$currentCommandLabel = New-Object System.Windows.Forms.Label
$currentCommandLabel.Location = New-Object System.Drawing.Point(10, $currentCommandLabelLocationY)
$currentCommandLabel.Size = New-Object System.Drawing.Size(280, 60)
$currentCommandLabel.Text = 'Current Command: '
$form.Controls.Add($currentCommandLabel)

# OK and Cancel Buttons
$buttonLocationY = $initialControlY + 280
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(50, $buttonLocationY)
$okButton.Size = New-Object System.Drawing.Size(90,30)
$okButton.Text = 'OK'
$form.Controls.Add($okButton)

# Cancel Button
$cancelButtonY = $initialControlY + 280
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(160, $buttonLocationY)
$cancelButton.Size = New-Object System.Drawing.Size(90,30)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$okButton.Add_Click({
    $inputText = $textBox.Text
    if ($inputText -match $domainRegex -or $inputText -match $ipRegex) {
        $options = ($optionsListView.Items | Where-Object { $_.Checked }).ForEach({ $_.Text }) -join ' '
        $script:commandToRun = "$commandName $options $inputText"
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Close()
    } else {
        [System.Windows.Forms.MessageBox]::Show('Please enter a valid domain or IP address.', 'Invalid Input', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }
})

# TextBox Text Change Event
$textBox.Add_TextChanged({ Update-CurrentCommand })

# Show the Form
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK -and $script:commandToRun) {
    $wslArgs = "-d kali-linux bash -c `"$script:commandToRun`"; read -p 'Press Enter to exit...'"
    Start-Process "wsl" -ArgumentList $wslArgs
}
