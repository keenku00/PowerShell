## Cautions ##
# I seriously emphasize that the crawl scripts below should not be used on unauthorized systems.
## Cautions ##

# Install the PowerHTML module if not already installed
# If the module was already implemented, no need to execute again.
Install-Module -Name PowerHTML -RequiredVersion 0.1.6 -Force

# Import the PowerHTML module
# If the module was already implemented, no need to execute again.
Import-Module PowerHTML

# Define the URL of the website you want to crawl
$targetUrl = "https://test.com/"

# Create a function to perform web crawling
function PerformWebCrawl {
    param (
        [string]$url
    )

    try {
        # Fetch the HTML content from the URL
        $response = Invoke-WebRequest -Uri $url

        if ($response.StatusCode -eq 200) {
            # Extract the HTML content from the response
            $webpage = $response.Content

            # You can now parse and manipulate the HTML content using HtmlAgilityPack functions
            # For example, let's extract all the hyperlinks from the webpage
            $htmlDocument = New-Object HtmlAgilityPack.HtmlDocument
            $htmlDocument.LoadHtml($webpage)
            
            $links = $htmlDocument.DocumentNode.SelectNodes("//a[@href]")

            # Loop through the extracted links and display them
            foreach ($link in $links) {
                $linkUrl = $link.GetAttributeValue("href", "")
                Write-Host "Link: $linkUrl"
            }
        }
        else {
            Write-Host "Failed to retrieve webpage content. HTTP Status Code: $($response.StatusCode)"
        }
    }
    catch {
        Write-Host "An error occurred: $($_.Exception.Message)"
    }
}

# Call the web crawling function with the target URL
PerformWebCrawl -url $targetUrl
