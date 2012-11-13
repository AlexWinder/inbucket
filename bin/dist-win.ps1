# Compile and package inbucket dist for windows
param([Parameter(Mandatory=$true)]$versionLabel)

# Move up to main inbucket directory
Set-Location ..

# Get environment
set DESKTOP ([Environment]::GetFolderPath("Desktop"))
set GOOS $(go env GOOS)
set GOARCH $(go env GOARCH)

# Where we will place the build output
set distname "inbucket-${versionLabel}-${GOOS}_${GOARCH}"
set distdir "$DESKTOP\$distname"

# Remove existing build directory
if (Test-Path $distdir) {
    Remove-Item -Force -Recurse $distdir
}

Write-Host "Building $distname..."
md $distdir | Out-Null
go build -o "$distdir/inbucket.exe" -a -v "github.com/jhillyerd/inbucket"

Write-Host "Copying resources..."
Copy-Item LICENSE -Destination "$distdir\LICENSE.txt"
Copy-Item README.md -Destination "$distdir\README.txt"
Copy-Item bin\inbucket.bat -Destination $distdir
Copy-Item etc -Destination $distdir -Recurse
Copy-Item themes -Destination $distdir -Recurse

Write-Host "Done!`n"
Write-Host "Press any key to continue..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
