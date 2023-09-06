## Cautions ##
# I seriously emphasize that the crawl scripts below should not be used on unauthorized systems.
# The following error could happen when the .dll file is downloaded on Internet. If so, please tuilize the Script#2
# Add-Type : Could not load file or assembly 'file:///C:\Windows\System32\HtmlAgilityPack.dll' or one of its dependencies. Operation is not supported. (Exception from HRESULT: 
0x80131515)
## Cautions ##

# Define the path to the HtmlAgilityPack.dll file (replace with the actual path)
$htmlAgilityPackPath = "C:\Windows\System32\HtmlAgilityPack.dll"

# Load the assembly
Add-Type -Path $htmlAgilityPackPath

# Define the URL of the website you want to crawl
$url = "https://test.com"

# Send an HTTP request to the URL
$response = Invoke-WebRequest -Uri $url

# Check if the request was successful
if ($response.StatusCode -eq 200) {
    # Load the HTML content using HtmlAgilityPack
    $html = New-Object HtmlAgilityPack.HtmlDocument
    $html.LoadHtml($response.Content)

    # Now you can traverse and extract data from the HTML
    # For example, let's extract all the links on the page
    $links = $html.DocumentNode.SelectNodes("//a[@href]")

    if ($links -ne $null) {
        foreach ($link in $links) {
            $href = $link.GetAttributeValue("href", "")
            Write-Host "Link: $href"
        }
    }
} else {
    Write-Host "Failed to retrieve the webpage. HTTP status code: $($response.StatusCode)"
}
