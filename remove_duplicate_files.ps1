$directoryPath = "C:\path_example" # Replace with the path of the directory you want to search for duplicate files in

Write-Host "Searching for files in $($directoryPath)..."
# Get all files in the directory and its subdirectories
$files = Get-ChildItem -Path $directoryPath -Recurse -File

Write-Host "Grouping files by hash value..."
# Group the files by their hash (which will be the same for identical files)
$groups = $files | Group-Object -Property {$_.GetHashCode()}

Write-Host "Deleting duplicate files..."
# Loop through the groups of files, keeping only the first file in each group (i.e., the original file) and deleting the others
foreach ($group in $groups) {
    if ($group.Count -gt 1) {
        $originalFile = $group.Group[0]
        Write-Host "Keeping $($originalFile.FullName) and deleting $($group.Group[1..$($group.Count - 1)].FullName)"
        $group.Group[1..$($group.Count - 1)] | Remove-Item -Force
    }
}

Write-Host "Duplicate file removal complete."