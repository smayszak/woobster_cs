## Usage: CreateSite.ps1 ([domain\user] [password]) 


# Restart this script under 64-bit Windows PowerShell. More details ? 
# Refer this http://docs.aws.amazon.com/codedeploy/latest/userguide/troubleshooting-deployments.html#troubleshooting-deployments-powershell
# (\SysNative\ redirects to \System32\ for 64-bit mode)

if ($PSHOME -like "*SysWOW64*")
{
  Write-Warning "Restarting this script under 64-bit Windows PowerShell."

  
  & (Join-Path ($PSHOME -replace "SysWOW64", "SysNative") powershell.exe) -File `
    (Join-Path $PSScriptRoot $MyInvocation.MyCommand) @args

  # Exit 32-bit script.

  Exit $LastExitCode
}

# Was restart successful?
Write-Warning "Hello from $PSHOME"
Write-Warning "  (\SysWOW64\ = 32-bit mode, \System32\ = 64-bit mode)"
Write-Warning "Original arguments (if any): $args"


# Load IIS tools
Import-Module WebAdministration
sleep 2

# Get SiteName and AppPool from script args
$siteName    = "Default Web Site"  
$appPoolName = "DefaultAppPool" 
$port        = 80  
$path        = "C:\inetpub\wwwroot" 
$AppName     = "Woobster"  
$AppPath     = "C:\inetpub\wwwroot\Woobster"
$user        = $args[0]  
$password    = $args[1]  


$backupName = "$(Get-date -format "yyyyMMdd-HHmmss")-$siteName"
"Backing up IIS config to backup named $backupName"
$backup = Backup-WebConfiguration $backupName

# Removes the Default Web Site, AppPool
function Remove-WebSite-AppPool(){
    
    if (Test-Path "IIS:\Sites\$siteName") {
        "Removing existing website $siteName"
        Remove-Website -Name $siteName
    }

    if (Test-Path "IIS:\AppPools\$appPoolName") {
        "Removing existing AppPool $appPoolName"
        Remove-WebAppPool -Name $appPoolName
    }

    #remove anything already using that port
    foreach($site in Get-ChildItem IIS:\Sites) {
        if( $site.Bindings.Collection.bindingInformation -eq ("*:" + $port + ":")){
             "Warning: Found an existing site '$($site.Name)' already using port $port. Removing it..."
             Remove-Website -Name  $site.Name 
             "Website $($site.Name) removed"
        }
    }
}

# Creates a AppPool and sets the Identity to ApplicationPoolIdentity by default. 
function Create-AppPool() {

    "Create an appPool named $appPoolName under v4.0 runtime, default (Integrated) pipeline"
    $pool = New-WebAppPool $appPoolName
    $pool.managedRuntimeVersion = "v4.0"
    $pool.processModel.identityType = 4 #ApplicationPoolIdentity
	
	if ($user -ne $null -AND $password -ne $null) {
	    "Setting AppPool to run as $user"
		$pool.processmodel.identityType = 3
		$pool.processmodel.username = $user
		$pool.processmodel.password = $password
	} 
	
    $pool | Set-Item

    if ((Get-WebAppPoolState -Name $appPoolName).Value -ne "Started") {
        throw "App pool $appPoolName was created but did not start automatically. Probably something is broken!"
    }
}

# Creates the Default Web Site binding it to port 80. Associates the Default App Pool to the website
function Create-WebSite() {

    "Create a website $siteName from directory $path on port $port"
    $website = New-Website -Name $siteName -PhysicalPath $path -ApplicationPool "DefaultAppPool" -Port $port

    if ((Get-WebsiteState -Name $siteName).Value -ne "Started") {
        throw "Website $siteName was created but did not start automatically. Probably something is broken!"
    }
}


function Create-WebApplication(){
        New-WebApplication -Name $appName -ApplicationPool $appPoolName -Site $siteName -PhysicalPath $appPath
		"$appName WebApplication created"
}


try { 
    
    Remove-WebSite-AppPool

    Create-AppPool

    Create-WebSite    

    Create-WebApplication

    "Website, AppPool and WebApplication created and started sucessfully"

} catch {
    "Error detected, running command 'Restore-WebConfiguration $backupName' to restore the web server to its initial state. Please wait..."
    sleep 3 #allow backup to unlock files
    Restore-WebConfiguration $backupName
    "IIS Restore complete. Throwing original error."
    throw
}


