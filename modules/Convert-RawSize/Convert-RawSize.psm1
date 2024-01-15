function Convert-RawSize {
    param (
        [Parameter(Mandatory = $true,  Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [double]$SizeInBytes
    )
    process {
        try {
            $index = 0 ; $suffixes = @('Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB')
            while ($SizeInBytes -ge 1024 -and $index -lt 4) {
                $SizeInBytes = $SizeInBytes / 1024 ; $index++
            }
            [string]::Format('{0:F2} {1}', $SizeInBytes, $suffixes[$index])
        } catch {
            Write-Error "[$($MyInvocation.MyCommand.Name)]`tError converting bytes value: $_"
        }
    }
}
