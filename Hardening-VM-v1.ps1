##################################################
#                                                #
#                                                #
#Script to verify and apply VMs hardening        #
#                                                #
# Autor Nicolas Ventre.                          #
#                                                #
# Version 1.0                                    #
#                                                #
#                                                #
##################################################

#Connect to vcenter
$vcenter = Read-Host "vCenter name:"
$user = Read-Host "User:"
$password = Read-Host "Password:"

#Write-Host -f green "Connecting to vCenter Server..."
Connect-VIServer -Server $vcenter -User $user -Password $password

#Create folder for logs output
$today = (get-date)
$dateStr = '{0:yyyyMMdd-HHmm}' -f $today

New-Item $env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr -ItemType directory

Write-Host "Depending on the number of VMs, this take a while..."

###############################################
#Persistent Disk Verify                       #
###############################################
Write-Host -f White "###############################################"
Write-Host -f White "#Persistent Disk Verify  ...                  #"
Write-Host -f White "###############################################"
$persistent = Get-VM | Get-HardDisk | Select Parent, Name, Filename, DiskType, Persistence | FT -AutoSize
$persistent | Out-String | ForEach-Object { $_.Trim() } > "$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\persistent-drive.txt"
if ($persistent -like "*Nonpersistent*") {
Write-Host -f red "You need to verify the VM configuration because there is Non-Persistent disks present"
Write-Host -f red "VMs must be powered off prior to changing the hard disk mode"
Write-Host -f red "File '$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\persistent-drive.txt' was generated to validate information."
}
else {
Write-Host -f green "All scanned disk have Persistence"
}

###############################################
#Passthrough Verify                           #
###############################################
Write-Host -f White "###############################################"
Write-Host -f White "#Passthrough Verify  ...                      #"
Write-Host -f White "###############################################"
$passthrough = Get-VM | Get-PassthroughDevice -Type Pci
$passthrough | Out-String | ForEach-Object { $_.Trim() } > "$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\passthrough-pci-device.txt"
if ($passthrough -ne $Null) {
Write-Host -f red "You need to verify the VM configuration because there is Passthrough device present"
Write-Host -f red "VMs must be powered off prior to changing the device"
Write-Host -f red "File '$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\passthrough-pci-device.txt' was generated to validate information."
}
else {
Write-Host -f green "All scanned disk have Persistence"
}

###############################################
#Verify Floppy                                #
###############################################
Write-Host -f White "###############################################"
Write-Host -f White "#Verifying if Floppy is present...            #"
Write-Host -f White "###############################################"

#Verify Floppy Drive
$floppy = Get-VM | Get-FloppyDrive | Select Parent, Name, ConnectionState
$floppy | Out-String | ForEach-Object { $_.Trim() } > "$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\floppy-drive.txt"
if ($floppy -ne $Null) {
Write-Host -f red "Floppy drive detected, you need to verify your VMs"
Write-Host -f red "VMs must be powered off prior to changing the hard disk mode"
Write-Host -f red "File '$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\floppy-drive.txt' was generated to validate information."
}
else {
Write-Host -f green "No floppy drive detected"
}

###############################################
#Verify Parallel device                                #
###############################################
Write-Host -f White "###############################################"
Write-Host -f White "#Verifying if Parallel device is present...   #"
Write-Host -f White "###############################################"

#Verify Parallel Device
$parallel = Get-VM | Where {$_.ExtensionData.Config.Hardware.Device.DeviceInfo.Label -match "parallel"}
$parallel | Out-String | ForEach-Object { $_.Trim() } > "$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\parallel-device.txt"
if ($parallel -ne $Null) {
Write-Host -f red "Parallel device detected, you need to verify your VMs"
Write-Host -f red "VMs must be powered off prior to changing the hard disk mode"
Write-Host -f red "File '$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\parallel-device.txt' was generated to validate information."
}
else {
Write-Host -f green "No Parallel device detected"
}

###############################################
#Verify Serial device                                #
###############################################
Write-Host -f White "###############################################"
Write-Host -f White "#Verifying if Serial device is present...     #"
Write-Host -f White "###############################################"

#Verify Serial Device
$serial = Get-VM | Where {$_.ExtensionData.Config.Hardware.Device.DeviceInfo.Label -match "serial"}
$serial | Out-String | ForEach-Object { $_.Trim() } > "$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\serial-device.txt"
if ($serial -ne $Null) {
Write-Host -f red "Serial device detected, you need to verify your VMs"
Write-Host -f red "VMs must be powered off prior to changing the hard disk mode"
Write-Host -f red "File '$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\serial-device.txt' was generated to validate information."
}
else {
Write-Host -f green "No Serial device detected"
}

###############################################
#Verify USB device                            #
###############################################
Write-Host -f White "###############################################"
Write-Host -f White "#Verifying if USB device is present...     #"
Write-Host -f White "###############################################"

#Verify USB Device
$usb = Get-VM | Where {$_.ExtensionData.Config.Hardware.Device.DeviceInfo.Label -match "usb"}
$usb | Out-String | ForEach-Object { $_.Trim() } > "$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\usb-device.txt"
if ($usb -ne $Null) {
Write-Host -f red "USB device detected, you need to verify your VMs"
Write-Host -f red "VMs must be powered off prior to changing the hard disk mode"
Write-Host -f red "File '$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\usb-device.txt' was generated to validate information."
}
else {
Write-Host -f green "No Serial device detected"
}

###############################################
#Verify Share Force Salting                   #
###############################################
Write-Host -f White "###############################################"
Write-Host -f White "#Verifying Share Force Salting...             #"
Write-Host -f White "###############################################"

#Verify Parallel Device
#Check and generate file log
$shareforcesalting = Get-VMhost | select Name, @{Name="Value";  Expression={Get-AdvancedSetting -Name Mem.ShareForceSalting -Entity $_}} | sort Value | ft -AutoSize
$shareforcesalting | Out-String | ForEach-Object { $_.Trim() } > "$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\shareforcesalting.txt"

#Generate file if config not match
$emptycheck = (gc "$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\shareforcesalting.txt") | where{$_ -like "*Mem.ShareForceSalting:2*"}
function shareforcesalting {
if ($emptycheck -eq $Null) {
Write-Host -f green "Share Force Salting is set to 1 in all Hosts"
}
else {
Write-Host -f red "Wrong Share Force Salting detected"
Write-Host -f red "Fixing Hosts"
$var1 = "" #Put your domain, for example if your hostname is host.test.local, put only test.local. If you don't use FQDN then comment this line and eliminate ".$var1" in next line.
$esxhost = (gc "$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\shareforcesalting.txt") | where{$_ -like "*Mem.ShareForceSalting:2*"} | foreach{$_.split(".")[0]}
$esxhost | ForEach-Object {Get-VMhost "$_.$var1" | Get-AdvancedSetting -Name Mem.ShareForceSalting |  Set-AdvancedSetting –Value 1 -Confirm:$false}
Write-Host -f green "Hosts Fixed"
}
}
shareforcesalting




$desired = @(

    @{

        Name = 'isolation.tools.copy.disable'

        Value = $true

    },

    @{

        Name = 'isolation.tools.dnd.disable'

        Value = $true

    },

    @{

        Name = 'isolation.tools.paste.disable'

        Value = $true

    },

    @{

        Name = 'isolation.tools.diskShrink.disable'

        Value = $true

    },

    @{

        Name = 'isolation.tools.setGUIOptions.enable'

        Value = $false

    },

    @{

        Name = 'isolation.tools.diskShrink.disable'

        Value = $true

    },

    @{

        Name = 'isolation.tools.diskWiper.disable'

        Value = $true

    },

    @{

        Name = 'isolation.tools.hgfs.disable'

        Value = $true

    },

    @{

        Name = 'isolation.tools.memSchedFakeSampleStats.disable'

        Value = $true

    },

    @{

        Name = 'tools.setInfo.sizeLimit'

        Value = 1048576

    },

    @{

        Name = 'isolation.device.edit.disable'

        Value = $true

    },

    @{

        Name = 'isolation.device.connectable.disable'

        Value = $true

    },

    @{

        Name = 'log.keepOld'

        Value = 10

    },

    @{

        Name = 'log.rotateSize'

        Value = 1024000

    },

    @{

        Name = 'RemoteDisplay.vnc.enabled'

        Value = $false

    },

    @{

        Name = 'tools.guestlib.enableHostInfo'

        Value = $false

    },

    @{

        Name = 'RemoteDisplay.maxConnections'

        Value = 1

    },

    @{

        Name = 'mks.enable3d'

        Value = $false

    },

    @{

        Name = 'isolation.tools.memSchedFakeSampleStats.disable'

        Value = $true

    }
    
)
$poweredoffvmsincluster = Get-VM
#File that containing the entire trace.
$Logfile = "$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr\vm-config.txt"
Start-Transcript -Path $Logfile
ForEach($VM in $poweredoffvmsincluster) {

    $desired | %{

        $setting = Get-AdvancedSetting -Entity $VM -Name $_.Name  | Select Entity, Name, Value

        if($setting){

            if($setting.Value -eq $_.Value){

                Write-Output "$VM $($_.Name) present and set correctly"

            }

            else{

                Write-Output "$VM $($_.Name) present but not set correctly"

                Set-AdvancedSetting -AdvancedSetting $setting -Value $_.Value -Confirm:$false

            }

        }

        else{

            Write-Output "$VM $($_.Name) not present."

            New-AdvancedSetting -Name $_.Name -Value $_.Value -Entity $VM -Confirm:$false

        }

    }

} 
Stop-Transcript

Write-Host -f green "Folder '$env:USERPROFILE\Documents\HardeningVM-Logs-$dateStr' was generated with the logs inside"
