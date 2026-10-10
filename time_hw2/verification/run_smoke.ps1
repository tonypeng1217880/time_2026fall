param([Parameter(Mandatory=$true)][string]$IcarusBin)
$ErrorActionPreference = 'Stop'
$rtlPath = Join-Path $PSScriptRoot '../01_RTL'
$benchPath = Join-Path $PSScriptRoot '../00_TESTBED'
$resultPath = Join-Path $PSScriptRoot 'results'
New-Item -ItemType Directory -Force -Path $resultPath | Out-Null

function Invoke-Smoke {
    param([string]$Name, [string[]]$Defines, [string]$Expected,
          [bool]$ExpectFailure = $false, [bool]$FakeDut = $false)
    $programPath = Join-Path $resultPath "$Name.vvp"
    $compileArgs = @('-g2012', '-Wall', '-DRTL', '-DNO_FSDB',
        '-I', $benchPath, '-I', $rtlPath, '-s', 'TESTBED', '-o', $programPath)
    foreach ($define in $Defines) { $compileArgs += "-D$define" }
    if ($FakeDut) {
        $compileArgs += (Join-Path $PSScriptRoot 'false_lock_tb.v')
    }
    else {
        $compileArgs += @((Join-Path $benchPath 'TESTBED.v'),
                         (Join-Path $PSScriptRoot 'smoke_cells.v'))
    }
    & (Join-Path $IcarusBin 'iverilog.exe') @compileArgs
    if ($LASTEXITCODE -ne 0) { throw "$Name compilation failed" }
    $simulation = & (Join-Path $IcarusBin 'vvp.exe') $programPath 2>&1
    $simulationExit = $LASTEXITCODE
    $simulation | Tee-Object -FilePath (Join-Path $resultPath "$Name.log")
    if (($simulation -join "`n") -notmatch [regex]::Escape($Expected)) {
        throw "$Name did not report the expected result: $Expected"
    }
    if ((!$ExpectFailure -and $simulationExit -ne 0) -or
        ($ExpectFailure -and $simulationExit -eq 0)) {
        throw "$Name unexpected exit code $simulationExit"
    }
    Write-Output "CHECK PASSED: $Name"
}

Invoke-Smoke 'pd' @('PD_TEST') 'PD TEST PASSED'
Invoke-Smoke 'tdl' @('TDL_TEST') 'TDL TEST PASSED'
Invoke-Smoke 'dll' @() 'DLL TEST PASSED'
Invoke-Smoke 'dll_scale098' @('SMOKE_SCALE=0.98') 'DLL TEST PASSED'
Invoke-Smoke 'dll_scale115' @('SMOKE_SCALE=1.15') 'DLL TEST PASSED'
Invoke-Smoke 'dll_insufficient_range' @('SMOKE_SCALE=0.80') 'DLL did not lock' $true
Invoke-Smoke 'reject_zero_cycle' @('FAKE_O2_DELAY=0.0') 'DLL absolute delay check failed' $true $true
Invoke-Smoke 'reject_two_cycles' @('FAKE_O2_DELAY=2.0') 'DLL absolute delay check failed' $true $true
Write-Output 'All smoke checks passed. These are NOT TSMC library/SDF timing results.'
