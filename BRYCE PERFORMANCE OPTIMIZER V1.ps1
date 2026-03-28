Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ================== FORM SETUP ==================
$form = New-Object System.Windows.Forms.Form
$form.Text = "Performance Optimizer V2"
$form.Size = New-Object System.Drawing.Size(750,650)
$form.StartPosition = "CenterScreen"

# ================== OUTPUT BOX ==================
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(20,470)
$outputBox.Size = New-Object System.Drawing.Size(700,150)
$outputBox.Multiline = $true
$outputBox.ScrollBars = 'Vertical'
$outputBox.ReadOnly = $true
$form.Controls.Add($outputBox)

# ================== SELECT/DESELECT ALL ==================
$btnSelectAll = New-Object System.Windows.Forms.Button
$btnSelectAll.Text = "Select All"
$btnSelectAll.Location = New-Object System.Drawing.Point(20,20)
$btnSelectAll.Size = New-Object System.Drawing.Size(100,30)
$form.Controls.Add($btnSelectAll)

$btnDeselectAll = New-Object System.Windows.Forms.Button
$btnDeselectAll.Text = "Deselect All"
$btnDeselectAll.Location = New-Object System.Drawing.Point(140,20)
$btnDeselectAll.Size = New-Object System.Drawing.Size(100,30)
$form.Controls.Add($btnDeselectAll)

# ================== TAB CONTROL ==================
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(710,420)
$tabControl.Location = New-Object System.Drawing.Point(20,60)
$form.Controls.Add($tabControl)

# ================== WINDOWS TAB ==================
$windowsTab = New-Object System.Windows.Forms.TabPage
$windowsTab.Text = "Windows Tweaks"

$winTweaks = @("Visual", "Power", "Privacy", "Gaming", "WUB")
$yPos = 10
$windowsCheckboxes = @{}
foreach ($tweak in $winTweaks) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = "$tweak Tweaks ✅"
    $cb.AutoSize = $true
    $cb.Location = New-Object System.Drawing.Point(10,$yPos)
    $windowsTab.Controls.Add($cb)
    $windowsCheckboxes[$tweak] = $cb
    $yPos += 25
}

$tabControl.TabPages.Add($windowsTab)

# ================== USB TAB ==================
$usbTab = New-Object System.Windows.Forms.TabPage
$usbTab.Text = "USB Tweaks"

$usbCheck = New-Object System.Windows.Forms.CheckBox
$usbCheck.Text = "Apply USB & Latency Optimizations ✅"
$usbCheck.AutoSize = $true
$usbCheck.Location = New-Object System.Drawing.Point(10,10)
$usbTab.Controls.Add($usbCheck)

$tabControl.TabPages.Add($usbTab)

# ================== DEBLOAT TAB ==================
$debloatTab = New-Object System.Windows.Forms.TabPage
$debloatTab.Text = "Debloat"

$debloatCheck = New-Object System.Windows.Forms.CheckBox
$debloatCheck.Text = "Remove Unnecessary Windows Apps ✅"
$debloatCheck.AutoSize = $true
$debloatCheck.Location = New-Object System.Drawing.Point(10,10)
$debloatTab.Controls.Add($debloatCheck)

$tabControl.TabPages.Add($debloatTab)

# ================== APPLY BUTTON ==================
$btnApply = New-Object System.Windows.Forms.Button
$btnApply.Text = "Apply Selected Tweaks"
$btnApply.Location = New-Object System.Drawing.Point(20,420)
$btnApply.Size = New-Object System.Drawing.Size(200,40)
$form.Controls.Add($btnApply)

# ================== SELECT/DESELECT LOGIC ==================
$btnSelectAll.Add_Click({
    foreach ($cb in $windowsCheckboxes.Values) { $cb.Checked = $true }
    $usbCheck.Checked = $true
    $debloatCheck.Checked = $true
})

$btnDeselectAll.Add_Click({
    foreach ($cb in $windowsCheckboxes.Values) { $cb.Checked = $false }
    $usbCheck.Checked = $false
    $debloatCheck.Checked = $false
})

# ================== FUNCTIONS ==================

# -------- WINDOWS TWEAKS --------
function Apply-VisualTweaks {
    $outputBox.AppendText("Applying Visual Tweaks...`r`n")
    # Disable animations, transparency, shadows, taskbar effects, etc.
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
    $outputBox.AppendText("Visual Tweaks applied.`r`n")
}

function Apply-PowerTweaks {
    $outputBox.AppendText("Applying Power Tweaks...`r`n")
    reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f
    reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 2000 /f
    reg add "HKCU\Control Panel\Desktop" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f
    powercfg -h off
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v VerboseStatus /t REG_DWORD /d 0 /f
    $outputBox.AppendText("Power Tweaks applied.`r`n")
}

function Apply-PrivacyTweaks {
    $outputBox.AppendText("Applying Privacy Tweaks...`r`n")
    reg add "HKCU\Software\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v AllowTelemetry /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f
    $outputBox.AppendText("Privacy Tweaks applied.`r`n")
}

function Apply-GamingTweaks {
    $outputBox.AppendText("Applying Gaming Tweaks...`r`n")
    reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 0 /f
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f
    reg add "HKCU\Control Panel\Mouse" /v SmoothMouseXCurve /t REG_BINARY /d 00000000000000000000000000000000000000000000000000000000 /f
    reg add "HKCU\Control Panel\Mouse" /v SmoothMouseYCurve /t REG_BINARY /d 00000000000000000000000000000000000000000000000000000000 /f
    $outputBox.AppendText("Gaming Tweaks applied.`r`n")
}

function Apply-WUB {
    $outputBox.AppendText("Launching Windows Update Blocker...`r`n")
    $url = "https://www.sordum.org/files/downloads.php?st-windows-update-blocker"
    $zip = "$env:TEMP\WUB.zip"
    $folder = "$env:TEMP\WUB"
    Invoke-WebRequest $url -OutFile $zip
    Expand-Archive $zip -DestinationPath $folder -Force
    Start-Process "$folder\Wub.exe"
    $outputBox.AppendText("Windows Update Blocker launched.`r`n")
}

# -------- USB & Latency TWEAKS --------
function Apply-USBTweaks {
    $outputBox.AppendText("Applying USB & Latency Optimizations...`r`n")
    # Power settings
    powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_USB USBSELECTSUSPEND 0
    powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_USB USBSELECTSUSPEND 0
    # HID Polling
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\HidUsb" /v PollingInterval /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v DisableSelectiveSuspend /t REG_DWORD /d 1 /f
    # Mouse & Keyboard
    reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f
    reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f
    reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d 0 /f
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d 31 /f
    # DPC & Interrupts
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3" /v EnableMSI /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBPORT\Parameters" /v InterruptModeration /t REG_DWORD /d 0 /f
    $outputBox.AppendText("USB & Latency Optimizations applied.`r`n")
}

# -------- DEBLOAT --------
function Apply-Debloat {
    $outputBox.AppendText("Applying Debloat...`r`n")
    Get-AppxPackage | Where-Object { $_.Name -notmatch "Store|Calculator|Notepad|Edge|MediaPlayer" } | Remove-AppxPackage
    # Stop unnecessary services
    sc stop "DiagTrack" | Out-Null
    sc config "DiagTrack" start= disabled | Out-Null
    sc stop "WMPNetworkSvc" | Out-Null
    sc config "WMPNetworkSvc" start= disabled | Out-Null
    $outputBox.AppendText("Debloat applied.`r`n")
}

# ================== APPLY BUTTON LOGIC ==================
$btnApply.Add_Click({
    if ($windowsCheckboxes["Visual"].Checked) { Apply-VisualTweaks }
    if ($windowsCheckboxes["Power"].Checked) { Apply-PowerTweaks }
    if ($windowsCheckboxes["Privacy"].Checked) { Apply-PrivacyTweaks }
    if ($windowsCheckboxes["Gaming"].Checked) { Apply-GamingTweaks }
    if ($windowsCheckboxes["WUB"].Checked) { Apply-WUB }
    if ($usbCheck.Checked) { Apply-USBTweaks }
    if ($debloatCheck.Checked) { Apply-Debloat }
    $outputBox.AppendText("All selected tweaks applied.`r`n")
})

# ================== SHOW FORM ==================
[void]$form.ShowDialog()