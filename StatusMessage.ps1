using namespace System.Net

param($Request, $TriggerMetadata)

$DLLPath = Join-Path -Path $PSScriptRoot -ChildPath "bin\SrsResources.dll"
Add-Type -Path $DLLPath

$MessageID = $Request.Query.MessageID
if (-not $MessageID) {
    $MessageID = $Request.Body.MessageID
}


$intSeverity = $Request.Query.Severity

If ($intSeverity -eq 3221225472)
{
    $intSeverity = -1073741824
}

If ($intSeverity -eq 2147483648)
{
    $intSeverity = -2147483648
}


$insString1 = $Request.Query.insString1
$insString2 = $Request.Query.insString2
$insString3 = $Request.Query.insString3
$insString4 = $Request.Query.insString4
$insString5 = $Request.Query.insString5
$insString6 = $Request.Query.insString6
$insString7 = $Request.Query.insString7
$insString8 = $Request.Query.insString8
$insString9 = $Request.Query.insString9
$insString10 = $Request.Query.insString10


$Language = $Request.Query.Language
if (-not $Language) {
    $Language = $Request.Body.Language
}

If(!($Language)) {
    $Language = "en-US"
}

[int]$intMessageID = $MessageID

if ($intMessageID -eq 0 -or $intMessageID) {
    $Message = [SrsResources.Localization]::GetStatusMessage($intMessageId,$intSeverity,"",$Language,$insString1,$insString2,$insString3,$insString4,$insString5,$insString6,$insString7,$insString8,$insString9,$insString10)
    If($Message) {
        $status = [HttpStatusCode]::OK
        $body = [pscustomobject]@{
            Result = ($Message -replace "`n"," ") -replace "`r",""
        }
    }
    else {
        $status = [HttpStatusCode]::OK
        $body = "No Result."
    }
}
else {
    $status = [HttpStatusCode]::BadRequest
    $body = "Please pass properly formed status message parameters."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $body | ConvertTo-Json
})
