# Define the registry path
$registryPathParents = "HKCU:\System\GameConfigStore\Parents"
$registryPathChildren = "HKCU:\System\GameConfigStore\Children"

# Get the parent entries
$parentEntries = Get-Item -LiteralPath $registryPathParents | Get-Item -ChildItem

# Display parent details
foreach ($parentEntry in $parentEntries) {
    $parentKeyPath = $parentEntry.PSPath
    $parentKey = Get-Item -LiteralPath $parentKeyPath
    
    # Display parent entry details
    Write-Host "Parent Entry - GUID: $($parentKey.PSChildName)"
    
    # Check if 'Children' property exists
    if ($parentKey.Property -contains 'Children') {
        $childrenReferences = $parentKey.GetValue('Children') -split '\r\n'
        foreach ($childReference in $childrenReferences) {
            Write-Host "  Child Reference: $childReference"
        }
    }

    # Add more details as needed
}

# Get the child entries
$childEntries = Get-Item -LiteralPath $registryPathChildren | Get-ItemProperty -Name *

# Display child details
foreach ($childEntry in $childEntries.PSChildNames) {
    $childKeyPath = Join-Path $registryPathChildren $childEntry
    $childKeyValues = Get-ItemProperty -LiteralPath $childKeyPath
    Write-Host "Child Entry - GUID: $($childKeyValues.PSChildName)"
    # Add more details as needed
}
