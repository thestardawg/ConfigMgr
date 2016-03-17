[CmdletBinding(SupportsShouldProcess=$True)]
    param
        (
        [Parameter(Mandatory=$False,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
            [string]$SoftwareName = "%",
        [Parameter(Mandatory=$False)]
            [switch]$Count,
        [Parameter(Mandatory=$False)]
            [switch]$CSV,
        [Parameter(Mandatory=$False)]
            [string]$SQLServer = “1ndcitvwcm01.tsi.lan”, # eg, <sqlserver>, or <sqlserver>\<instance>
        [Parameter(Mandatory=$False)]
            [string]$Database = “CM_TAB”
        )
  
# Open a connection
$connectionString = “Server=$SQLServer;Database=$database;Integrated Security=SSPI;”
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()
  
# Set queries
if ($count)
    {
        $query = "
        SELECT Count(sof.NormalizedName) AS 'Count',
        sof.NormalizedName, sof.NormalizedVersion, sof.NormalizedPublisher, sof.FamilyName, sof.CategoryName
        FROM v_GS_INSTALLED_SOFTWARE_CATEGORIZED sof
        where sof.NormalizedName like '$SoftwareName'
        GROUP BY sof.NormalizedName, sof.NormalizedVersion, sof.NormalizedPublisher, sof.FamilyName, sof.CategoryName
        ORDER BY 'Count' DESC, sof.NormalizedName, sof.NormalizedVersion
        "
    }
else
    {
        $query = "select Name0 as 'Computer Name',
        User_Name0 as 'Last Logged-On User',
        NormalizedName as 'Software Name',
        NormalizedPublisher as Publisher,
        NormalizedVersion as Version,
        FamilyName as 'Software Family',
        CategoryName as 'Software Category',
        InstallDate0 as 'Install Date',
        RegisteredUser0 as 'Registered User',
        InstalledLocation0 as 'Install Location',
        InstallSource0 as 'Source Location',
        UninstallString0 as 'Uninstall String',
        TimeStamp as 'Inventory Time'
        from v_GS_INSTALLED_SOFTWARE_CATEGORIZED sof
        inner join v_R_System sys on sof.ResourceID = sys.ResourceID
        where sof.NormalizedName like '$SoftwareName' order by Name0
        "
    }
     
$command = $connection.CreateCommand()
$command.CommandText = $query
$result = $command.ExecuteReader()
 
$table = new-object “System.Data.DataTable”
$table.Load($result)
 
# Output results
if ($CSV)
    {
        $Path = "$env:TEMP\SoftwareQuery-$(Get-date -format hh-mm).csv"
        $table | Export-Csv -Path $Path -Force -NoTypeInformation
        Invoke-Item $Path
    }
Else {$table}
 
# Close the connection
$connection.Close()

# Usage Examples.  Needs to be loaded as function first.  
#.\getcminstalledsoftware.ps1 -SoftwareName "Microsoft Project%" -CSV
#.\getcminstalledsoftware.ps1 -SoftwareName "Microsoft Visio%" | Out-GridView