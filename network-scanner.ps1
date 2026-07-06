#Requires -Version 5.1
<#
.SYNOPSIS
    Network Scanner GUI - Tanpa Install
.DESCRIPTION
    Scan IP, ports, services via Tailscale
.EXAMPLE
    .\network-scanner.ps1
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Network Scanner - Cyber Lab"
$form.Size = New-Object System.Drawing.Size(800, 650)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)

# Title
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "NETWORK SCANNER"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::Cyan
$titleLabel.Size = New-Object System.Drawing.Size(760, 40)
$titleLabel.Location = New-Object System.Drawing.Point(20, 10)
$titleLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($titleLabel)

# Target section
$targetGroupBox = New-Object System.Windows.Forms.GroupBox
$targetGroupBox.Text = "TARGET"
$targetGroupBox.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$targetGroupBox.ForeColor = [System.Drawing.Color]::White
$targetGroupBox.Size = New-Object System.Drawing.Size(760, 80)
$targetGroupBox.Location = New-Object System.Drawing.Point(20, 60)
$form.Controls.Add($targetGroupBox)

$ipLabel = New-Object System.Windows.Forms.Label
$ipLabel.Text = "Target IP:"
$ipLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$ipLabel.ForeColor = [System.Drawing.Color]::White
$ipLabel.Size = New-Object System.Drawing.Size(80, 25)
$ipLabel.Location = New-Object System.Drawing.Point(10, 30)
$targetGroupBox.Controls.Add($ipLabel)

$ipTextBox = New-Object System.Windows.Forms.TextBox
$ipTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$ipTextBox.Size = New-Object System.Drawing.Size(200, 25)
$ipTextBox.Location = New-Object System.Drawing.Point(90, 30)
$ipTextBox.Text = "100.74.88.110"
$targetGroupBox.Controls.Add($ipTextBox)

$portLabel = New-Object System.Windows.Forms.Label
$portLabel.Text = "Ports:"
$portLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$portLabel.ForeColor = [System.Drawing.Color]::White
$portLabel.Size = New-Object System.Drawing.Size(50, 25)
$portLabel.Location = New-Object System.Drawing.Point(310, 30)
$targetGroupBox.Controls.Add($portLabel)

$portTextBox = New-Object System.Windows.Forms.TextBox
$portTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$portTextBox.Size = New-Object System.Drawing.Size(300, 25)
$portTextBox.Location = New-Object System.Drawing.Point(360, 30)
$portTextBox.Text = "22,80,135,139,445,3389,5985,5986,8006"
$targetGroupBox.Controls.Add($portTextBox)

# Preset buttons
$presetsGroupBox = New-Object System.Windows.Forms.GroupBox
$presetsGroupBox.Text = "PRESETS"
$presetsGroupBox.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$presetsGroupBox.ForeColor = [System.Drawing.Color]::White
$presetsGroupBox.Size = New-Object System.Drawing.Size(760, 60)
$presetsGroupBox.Location = New-Object System.Drawing.Point(20, 150)
$form.Controls.Add($presetsGroupBox)

# Preset buttons
$presets = @(
    @{Name="Common"; Ports="21,22,23,25,53,80,110,135,139,443,445,993,995,3389,5985,5986,8006,8080"},
    @{Name="Windows"; Ports="135,139,445,3389,5985,5986"},
    @{Name="Web"; Ports="80,443,8080,8443,8888,9090"},
    @{Name="Database"; Ports="1433,1434,3306,5432,27017"},
    @{Name="SSH/FTP"; Ports="21,22,23"},
    @{Name="Proxmox"; Ports="22,8006"}
)

$x = 10
foreach ($preset in $presets) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $preset.Name
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $btn.Size = New-Object System.Drawing.Size(100, 30)
    $btn.Location = New-Object System.Drawing.Point($x, 25)
    $btn.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.FlatStyle = "Flat"
    $btn.Tag = $preset.Ports
    $btn.Add_Click({
        $portTextBox.Text = $this.Tag
    })
    $presetsGroupBox.Controls.Add($btn)
    $x += 110
}

# Scan button
$scanBtn = New-Object System.Windows.Forms.Button
$scanBtn.Text = "SCAN"
$scanBtn.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$scanBtn.Size = New-Object System.Drawing.Size(200, 40)
$scanBtn.Location = New-Object System.Drawing.Point(20, 220)
$scanBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$scanBtn.ForeColor = [System.Drawing.Color]::White
$scanBtn.FlatStyle = "Flat"
$form.Controls.Add($scanBtn)

# Stop button
$stopBtn = New-Object System.Windows.Forms.Button
$stopBtn.Text = "STOP"
$stopBtn.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$stopBtn.Size = New-Object System.Drawing.Size(150, 40)
$stopBtn.Location = New-Object System.Drawing.Point(230, 220)
$stopBtn.BackColor = [System.Drawing.Color]::FromArgb(200, 50, 50)
$stopBtn.ForeColor = [System.Drawing.Color]::White
$stopBtn.FlatStyle = "Flat"
$stopBtn.Enabled = $false
$form.Controls.Add($stopBtn)

# Progress
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(350, 25)
$progressBar.Location = New-Object System.Drawing.Point(400, 225)
$progressBar.Style = "Continuous"
$form.Controls.Add($progressBar)

# Results section
$resultsGroupBox = New-Object System.Windows.Forms.GroupBox
$resultsGroupBox.Text = "RESULTS"
$resultsGroupBox.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$resultsGroupBox.ForeColor = [System.Drawing.Color]::White
$resultsGroupBox.Size = New-Object System.Drawing.Size(760, 280)
$resultsGroupBox.Location = New-Object System.Drawing.Point(20, 270)
$form.Controls.Add($resultsGroupBox)

$resultsListView = New-Object System.Windows.Forms.ListView
$resultsListView.View = "Details"
$resultsListView.FullRowSelect = $true
$resultsListView.GridLines = $true
$resultsListView.Size = New-Object System.Drawing.Size(740, 250)
$resultsListView.Location = New-Object System.Drawing.Point(10, 25)
$resultsListView.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$resultsListView.ForeColor = [System.Drawing.Color]::White
$resultsGroupBox.Controls.Add($resultsListView)

# Add columns
$resultsListView.Columns.Add("Port", 80)
$resultsListView.Columns.Add("State", 80)
$resultsListView.Columns.Add("Service", 150)
$resultsListView.Columns.Add("Description", 420)

# Export button
$exportBtn = New-Object System.Windows.Forms.Button
$exportBtn.Text = "EXPORT CSV"
$exportBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$exportBtn.Size = New-Object System.Drawing.Size(150, 35)
$exportBtn.Location = New-Object System.Drawing.Point(20, 560)
$exportBtn.BackColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
$exportBtn.ForeColor = [System.Drawing.Color]::White
$exportBtn.FlatStyle = "Flat"
$exportBtn.Enabled = $false
$form.Controls.Add($exportBtn)

# Status
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Ready"
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$statusLabel.ForeColor = [System.Drawing.Color]::Gray
$statusLabel.Size = New-Object System.Drawing.Size(580, 25)
$statusLabel.Location = New-Object System.Drawing.Point(180, 565)
$form.Controls.Add($statusLabel)

# Service map
$serviceMap = @{
    21 = "FTP"
    22 = "SSH"
    23 = "Telnet"
    25 = "SMTP"
    53 = "DNS"
    80 = "HTTP"
    110 = "POP3"
    135 = "RPC/DCOM"
    139 = "NetBIOS"
    143 = "IMAP"
    443 = "HTTPS"
    445 = "SMB"
    993 = "IMAPS"
    995 = "POP3S"
    1433 = "MSSQL"
    1434 = "MSSQL Browser"
    3306 = "MySQL"
    3389 = "RDP"
    5432 = "PostgreSQL"
    5900 = "VNC"
    5985 = "WinRM HTTP"
    5986 = "WinRM HTTPS"
    8006 = "Proxmox"
    8080 = "HTTP Alt"
    8443 = "HTTPS Alt"
    8888 = "HTTP Alt"
    9090 = "Webmin"
    27017 = "MongoDB"
}

# Scan function
$script:scanning = $false
$script:results = @()

function Scan-Port {
    param([string]$IP, [int]$Port)
    
    try {
        $result = Test-NetConnection -ComputerName $IP -Port $Port -WarningAction SilentlyContinue -InformationLevel Quiet
        return $result
    } catch {
        return $false
    }
}

# Scan button click
$scanBtn.Add_Click({
    $targetIP = $ipTextBox.Text
    $ports = $portTextBox.Text -split "," | ForEach-Object { [int]$_.Trim() }
    
    if ([string]::IsNullOrEmpty($targetIP)) {
        [System.Windows.Forms.MessageBox]::Show("Masukkan IP target!", "Warning", "OK", "Warning")
        return
    }
    
    $script:scanning = $true
    $scanBtn.Enabled = $false
    $stopBtn.Enabled = $true
    $exportBtn.Enabled = $false
    $resultsListView.Items.Clear()
    $script:results = @()
    
    $statusLabel.Text = "Scanning $targetIP..."
    $progressBar.Maximum = $ports.Count
    $progressBar.Value = 0
    
    foreach ($port in $ports) {
        if (-not $script:scanning) { break }
        
        $statusLabel.Text = "Testing port $port..."
        $progressBar.Value++
        
        $isOpen = Scan-Port -IP $targetIP -Port $port
        
        $service = if ($serviceMap.ContainsKey($port)) { $serviceMap[$port] } else { "Unknown" }
        $state = if ($isOpen) { "Open" } else { "Closed" }
        $color = if ($isOpen) { [System.Drawing.Color]::Lime } else { [System.Drawing.Color]::Red }
        
        $item = New-Object System.Windows.Forms.ListViewItem($port.ToString())
        $item.SubItems.Add($state)
        $item.SubItems.Add($service)
        $item.SubItems.Add("")
        $item.ForeColor = $color
        $resultsListView.Items.Add($item)
        
        if ($isOpen) {
            $script:results += @{Port=$port; State=$state; Service=$service; Description=""}
        }
        
        $form.Refresh()
        Start-Sleep -Milliseconds 100
    }
    
    $script:scanning = $false
    $scanBtn.Enabled = $true
    $stopBtn.Enabled = $false
    $exportBtn.Enabled = $true
    $statusLabel.Text = "Scan complete! Found $($script:results.Count) open ports."
})

# Stop button click
$stopBtn.Add_Click({
    $script:scanning = $false
    $statusLabel.Text = "Scan stopped."
})

# Export button click
$exportBtn.Add_Click({
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "CSV files (*.csv)|*.csv"
    $saveDialog.FileName = "scan-results.csv"
    
    if ($saveDialog.ShowDialog() -eq "OK") {
        $csv = $script:results | ConvertTo-Csv -NoTypeInformation
        $csv | Out-File -FilePath $saveDialog.FileName -Encoding UTF8
        [System.Windows.Forms.MessageBox]::Show("Results exported to: $($saveDialog.FileName)", "Export Complete", "OK", "Information")
    }
})

# Show form
$form.ShowDialog() | Out-Null
