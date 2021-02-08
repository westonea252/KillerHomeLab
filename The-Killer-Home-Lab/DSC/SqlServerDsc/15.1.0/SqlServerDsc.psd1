@{
    # Version number of this module.
    moduleVersion      = '15.1.0'

    # ID used to uniquely identify this module
    GUID               = '693ee082-ed36-45a7-b490-88b07c86b42f'

    # Author of this module
    Author             = 'DSC Community'

    # Company or vendor of this module
    CompanyName        = 'DSC Community'

    # Copyright statement for this module
    Copyright          = 'Copyright the DSC Community contributors. All rights reserved.'

    # Description of the functionality provided by this module
    Description        = 'Module with DSC resources for deployment and configuration of Microsoft SQL Server.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion  = '5.0'

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion         = '4.0'

    # Functions to export from this module
    FunctionsToExport  = @()

    # Cmdlets to export from this module
    CmdletsToExport    = @()

    # Variables to export from this module
    VariablesToExport  = @()

    # Aliases to export from this module
    AliasesToExport    = @()

    DscResourcesToExport = @('SqlAG','SqlAGDatabase','SqlAgentAlert','SqlAgentFailsafe','SqlAgentOperator','SqlAGListener','SqlAGReplica','SqlAlias','SqlAlwaysOnService','SqlConfiguration','SqlDatabase','SqlDatabaseDefaultLocation','SqlDatabaseMail','SqlDatabaseObjectPermission','SqlDatabasePermission','SqlDatabaseRole','SqlDatabaseUser','SqlEndpoint','SqlEndpointPermission','SqlLogin','SqlMaxDop','SqlMemory','SqlPermission','SqlProtocol','SqlProtocolTcpIp','SqlReplication','SqlRole','SqlRS','SqlRSSetup','SqlScript','SqlScriptQuery','SqlSecureConnection','SqlServiceAccount','SqlSetup','SqlTraceFlag','SqlWaitForAG','SqlWindowsFirewall','SqlDatabaseOwner','SqlDatabaseRecoveryModel','SqlServerEndpointState','SqlServerNetwork')

    RequiredAssemblies = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData        = @{

        PSData = @{
            # Set to a prerelease string value if the release should be a prerelease.
            Prerelease   = ''

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('DesiredStateConfiguration', 'DSC', 'DSCResourceKit', 'DSCResource')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/dsccommunity/SqlServerDsc/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/dsccommunity/SqlServerDsc'

            # A URL to an icon representing this module.
            IconUri      = 'https://dsccommunity.org/images/DSC_Logo_300p.png'

            # ReleaseNotes of this module
            ReleaseNotes = '## [15.1.0] - 2021-02-01

### Added

- SqlServerDsc
  - Added a new script analyzer rule to verify that `Import-SQLPSModule` or `Connect-SQL`
    (that implicitly calls `Import-SQLPSModule`) is present in each `Get-`, `Test-`,
    and `Set-TargetResource` function. If neither command is not needed then the
    analyzer rule should be overridden ([issue #1683](https://github.com/dsccommunity/SqlServerDsc/issues/1683)).
  - Added a new pipeline job that runs Script Analyzer on all PowerShell scripts
    in the source folder. The rules are defined by the Script Analyzer settings
    file `.vscode\analyzersettings.psd1` (which also the Visual Studio Code
    PowerShell extension uses).
  - Added unit tests and integration tests for SQL Server 2019
    ([issue #1310](https://github.com/dsccommunity/SqlServerDsc/issues/1310)).

### Changed

- SqlServerDsc
  - Suppressed new custom Script Analyzer rule `SqlServerDsc.AnalyzerRules\Measure-CommandsNeededToLoadSMO`
    for `Get-`, `Test-`, and `Set-TargetResource` functions in the resources.
- SqlLogin
  - Added functionality to throw exception if an update to the `LoginMustChangePassword`
    value on an existing SQL Login is attempted. This functionality is not supported
    by referenced, SQL Server Management Object (SMO), libraries and cannot be
    supported directly by this module.
  - Added integration tests to ensure that an added (or updated) `SqlLogin` can
    connect into a SQL instance once added (or updated).
  - Added integration tests to ensure that the default database connected to by
    a `SqlLogin` is the same as specified in the resource''s `DefaultDatabase`
    property/parameter.
  - Amended how the interdependent, `PasswordExpirationEnabled` and `PasswordPolicyEnforced`
    properties/parameters are updated within the `SqlLogin` resource - Both values
    are now updated together if either one or both are not currently in the desired
    state. This change avoids exceptions thrown by transitions to valid, combinations
    of these properties that have to transition through an invalid combination (e.g.
    where `PasswordExpirationEnabled` is `$true` but `PasswordPolicyEnforced` is
    `$false`).
- SqlSetup
  - Minor refactor due to source code lint errors. The loop what evaluates
    the configuration parameters `*FailoverCluster` was change to a `foreach()`.

### Fixed

- SqlServerDsc
  - The component `gitversion` that is used in the pipeline was wrongly
    configured when the repository moved to the new default branch `main`.
    It no longer throws an error when using newer versions of GitVersion
    ([issue #1674](https://github.com/dsccommunity/SqlServerDsc/issues/1674)).
  - Minor lint errors throughout the repository.
- SqlLogin
  - Added integration tests to assert `LoginPasswordExpirationEnabled`,
  `LoginPasswordPolicyEnforced` and `LoginMustChangePassword` properties/parameters
  are applied and updated correctly. Similar integration tests also added to ensure
  the password of the `SqlLogin` is updated if the password within the `SqlCredential`
  value/object is changed ([issue #361](https://github.com/dsccommunity/SqlServerDsc/issues/361),
  [issue #1032](https://github.com/dsccommunity/SqlServerDsc/issues/1032) and
  [issue #1050](https://github.com/dsccommunity/SqlServerDsc/issues/1050)).
  - Updated `SqlLogin`, integration tests to make use of amended `Wait-ForIdleLcm`,
    helper function, `-Clear` switch usage to remove intermittent, integration
    test failures ([issue #1634](https://github.com/dsccommunity/SqlServerDsc/issues/1634)).
- SqlRSSetup
  - If parameter `SuppressRestart` is set to `$false` the `/norestart`
    argument is no longer wrongly added ([issue #1401](https://github.com/dsccommunity/SqlServerDsc/issues/1401)).
- SqlSetup
  - Added/corrected `InstallSharedDir`, property output when using SQL Server 2019.
- SqlTraceFlag
  - Fixed Assembly not loaded error ([issue #1680](https://github.com/dsccommunity/SqlServerDsc/issues/1680)).
- SqlDatabaseUser
  - Added parameter `ServerName` to the call of `Assert-SqlLogin`.
    `@PSBoundParameters` doesn''t capture the default value of `ServerName`
    when it is not explicitly set by the caller ([issue #1647](https://github.com/dsccommunity/SqlServerDsc/issues/1647)).

'

        } # End of PSData hashtable

    } # End of PrivateData hashtable
}




