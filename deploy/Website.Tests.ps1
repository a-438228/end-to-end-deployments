param(
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string] $HostName
)

Describe 'Website' {

    It 'Serves pages over HTTPS' {
      $request = [System.Net.WebRequest]::Create("https://$HostName/")
      $request.AllowAutoRedirect = $false
      $request.GetResponse().StatusCode |
        Should -Be 200 -Because "the website requires HTTPS"
    }

    It 'Does not serves pages over HTTP' {
      $request = [System.Net.WebRequest]::Create("http://$HostName/")
      $request.AllowAutoRedirect = $false
      $request.GetResponse().StatusCode |
        Should -BeGreaterOrEqual 300 -Because "HTTP is not secure"
    }

    It 'Returns a success code from the landing page' {
      $response = Invoke-WebRequest -Uri "https://$HostName/" -SkipHttpErrorCheck
      Write-Host $response.Content
      $response.StatusCode |
        Should -Be 200 -Because "the website and configuration should be healthy"
    }

}
