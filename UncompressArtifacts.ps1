$target = "C:\inetpub\wwwroot\Woobster\" 

function DeleteIfExistsAndCreateEmptyFolder($dir )
{
    if ( Test-Path $dir ) {    
           Get-ChildItem -Path  $dir -Force -Recurse | Remove-Item -force -recurse
           Remove-Item $dir -Force
    }
    New-Item -ItemType Directory -Force -Path $dir
}
# Clean up target Directory
DeleteIfExistsAndCreateEmptyFolder($target )

# MS WebDeploy creates a Web Artifact with multiple levels of folders. We only need the 
# content of the folder which has Web.Config within it 

$path2 = "C:\temp\WebApp\Woobster\*"
Copy-Item $path2 $target -recurse -force



