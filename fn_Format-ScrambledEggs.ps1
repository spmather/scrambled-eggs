#!/bin/pwsh
# Author : spmather
# Date   : 2025-10-11
# Update : 2025-10-26
# Version: 0.2

# Coming soon
#    Generate random substitution legend and save it as an exported file
#    Make more breakfast references

function Format-ScrambledEggs {
<#
.SYNOPSIS

Uses substitution method to scramble or unscramble text

.DESCRIPTION
Scrambles the text in a file using a specific legend.  Can unscramble if the same legend is used.


Known issues:
Scrambling and Unscrambling requires a loop in the substitution legend.  
Id est: 
a -> b
b -> c
c -> a

Leaving it open ended by not defining either 1)  all the characters or 2) the final "to value" in a short list
will make unscrambling fail

There is also an issue with capitalization due to powershell not being case sensitive

It cannot process numbers until the token is generation is adjusted to use something else

.EXAMPLE
Working:  format-scrambledeggs -filepath ./in/text.txt -OutPath ./out/out.txt -Legend ./substitution.csv -Scramble
Working:  format-scrambledeggs -filepath ./out/out.txt -OutPath ./out/out2.txt -Legend ./substitution.csv -Unscramble
Not working:  format-scrambledeggs -filepath ./in/windowsvista_1920x1200.bmp -OutPath ./out/windowsvista_1920x1200_out.bmp -Legend ./substitution.csv -Scramble
Not working:  format-scrambledeggs -filepath ./out/windowsvista_1920x1200_out.bmp -OutPath ./unscrambled/windowsvista_1920x1200_unscram.bmp  -Legend ./substitution.csv -Unscramble
#>

    [CmdletBinding(DefaultParameterSetName = "Scramble")]
    [OutputType([string], ParameterSetName = "Scramble")]
    [OutputType([string], ParameterSetName = "Unscramble")]
    param(
      
        [parameter(
            ParameterSetName                = "Scramble",
            Mandatory                       = $true,
            ValueFromPipeLineByPropertyName = $true,
            Position                        = 0
        )]
        [parameter(
            ParameterSetName                = "Unscramble",
            Mandatory                       = $true,
            ValueFromPipeLineByPropertyName = $true,
            Position                        = 0
        )]
        [string]
        $FilePath,  # this is the path for your egg

        [parameter(
            ParameterSetName = "Scramble",
            Mandatory        = $True
        )]
        [parameter(
            ParameterSetName = "Unscramble",
            Mandatory        = $True
        )]
        [string]
        $OutPath,

        [parameter(
            ParameterSetName = "Scramble",    
            Mandatory        = $false
        )]
        [switch]
        $Scramble,


        [parameter(
            ParameterSetName = "Unscramble",
            Mandatory        = $false
        )]
        [switch]
        $Unscramble,


        [parameter(
            ParameterSetName = "Scramble",
            Mandatory        = $false
        )]
        [parameter(
            ParameterSetName = "Unscramble",
            Mandatory        = $false
        )]
        [string]
        $LegendPath,  


        [parameter(
            ParameterSetName = "Scramble",
            Mandatory        = $false
        )]
        [parameter(
            ParameterSetName = "Unscramble",
            Mandatory        = $false
        )]
        [string]
        $Delimitor = "☺"  # Alt + 1

    )
        

    Begin {

        #$FilePath
        $Content = Get-Content $FilePath
        $Legend  = Import-CSV $LegendPath
        #$Scramble
        #$Unscramble
        #$Legend
        #$Salt
        #$Pepper
        #$Pattern = '\p{L}☺[0-9][0-9][0-9][0-9]☺'

        # If no out-file specified, creates same name file in directory "out"
        If ($Null -eq $OutPath) {
            $File    = Split-Path $FilePath -Leaf
            If (!(Test-Path "$PSScriptRoot\Out")) {
                New-Item -Path "$PSScriptRoot" -Name "Out" -ItemType "Directory"
            }
            $OutPath = "$PSScriptRoot\Out\$File"
        }

        # $salt = Get-Random -Minimum 1 -Maximum ((Get-Content $psscriptroot\substitution.legend | measure).count)

        # Verify csv format is correct

        $ColumnACount = ($Legend."from value".count)  # Does not require subtracting 1 for headers
        $ColumnBCount = ($Legend."to value".count  )  # Does not require subtracting 1 for headers

        If ($ColumnACount -ne $ColumnBCount) {
            Write-Output "Incomplete substitution"
            Throw
        }
        Else {
            $LineCount = $ColumnBCount
        }

        If ($Scramble) {
            $SwitchCheck = 1
        }
        ElseIf ($Unscramble) {
            $SwitchCheck = 2
        }

        Write-Debug "SwitchCheck is [$($SwitchCheck)]"
    }


    Process {

        # Create tokens

        $TokenArrFrom      = @()
        $TransmutedArrFrom = @()

        Foreach ($Char in $Legend."From value") {

            Do {
                $Token = Get-Random -Minimum 1000 -Maximum 9999 

                If ($TokenArrFrom.Count -gt 8999) {
                    Break
                }

                If ($TokenArrFrom.Count -gt $LineCount) {
                    Break
                }

                Write-Debug "Token is [$($Token)]"
                Write-Debug "Token count is $($TokenArrFrom.Count)"
            }
            Until ($TokenArr -notcontains $Token)

            $TokenArrFrom      += $Token
            Write-Debug "TokenArr is [$($TokenArr)]"
            $TokenAndDelim      = $Delimitor + $Token + $Delimitor
            Write-Debug "TokenAndDeliminator is [$($TokenAndDelim)]"
            $CharAndToken       = $Char + "$TokenAndDelim"
            Write-Debug "CharacterAndToken is [$($CharAndToken)]"
            $TransmutedArrFrom += $CharAndToken
            Write-Debug "TransmutedArray is [$($TransmutedArr)]"
                
        }

        $TokenArrTo      = @()
        $TransmutedArrTo = @()

        Foreach ($Char in $Legend."To value") {

            Do {
                $Token = Get-Random -Minimum 1000 -Maximum 9999 

                If ($TokenArrTo.Count -gt 8999) {
                    Break
                }

                If ($TokenArrTo.Count -gt $LineCount) {
                    Break
                }

                Write-Debug "Token is [$($Token)]"
                Write-Debug "Token count is $($TokenArrTo.Count)"
            }
            Until ($TokenArrTo -notcontains $Token)

            $TokenArrTo      += $Token
                Write-Debug "TokenArrTo is [$($TokenArr)]"
            $TokenAndDelim    = $Delimitor + $Token + $Delimitor
                Write-Debug "TokenAndDeliminator is [$($TokenAndDelim)]"
            $CharAndToken     = $Char + "$TokenAndDelim"
                Write-Debug "CharacterAndToken is [$($CharAndToken)]"
            $TransmutedArrTo += $CharAndToken
                Write-Debug "TransmutedArrayTo is [$($TransmutedArrTo)]"
        }

        # Scramble or Unscramble
        Switch ($SwitchCheck) {

            1 {
                For ($k = 0 ; $k -lt $LineCount ; $k++) {
                    Write-Debug "Transmutation pipeline stage 1:"
                    Write-Debug "  From char is [$($Legend[$k]."From value")]"
                    Write-Debug "  TransmutedArray FromChar is [$($TransmutedArrFrom[$k])]"
                    $Content = $Content -replace $Legend[$k]."From value" ,$TransmutedArrFrom[$k]
                }

                For ($k = 0 ; $k -lt $LineCount ; $k++) {
                    Write-Debug "Transmutation pipeline stage 2:"
                    Write-Debug "  TransmutedArray FromChar is [$($TransmutedArrFrom[$k])]"
                    Write-Debug "  TransmutedArray ToChar is [$($TransmutedArrTo[$k])]"
                    $Content = $Content -replace $TransmutedArrFrom[$k],$TransmutedArrTo[$k]
                }

                For ($k = 0 ; $k -lt $LineCount ; $k++) {
                    Write-Debug "Transmutation pipeline stage 3:"
                    Write-Debug "  TransmutedArray ToChar is [$($TransmutedArrTo[$k])]"
                    Write-Debug "  To char is [$($Legend[$k]."To value")]"
                    $Content = $Content -replace $TransmutedArrTo[$k], $Legend[$k]."To value"
                }

                $Content | Out-File -FilePath $OutPath
            }

            2 {
                
                For ($k = 0 ; $k -lt $LineCount ; $k++) {
                    Write-Debug "Transmutation pipeline stage 1:"
                    Write-Debug "  To char is [$($Legend[$k]."To value")]"
                    Write-Debug "  TransmutedArray ToChar is [$($TransmutedArrTo[$k])]"
                    $Content = $Content -replace $Legend[$k]."To value" ,$TransmutedArrTo[$k]
                }

                For ($k = 0 ; $k -lt $LineCount ; $k++) {
                    Write-Debug "Transmutation pipeline stage 2:"
                    Write-Debug "  TransmutedArray ToChar is [$($TransmutedArrTo[$k])]"
                    Write-Debug "  TransmutedArray FromChar is [$($TransmutedArrFrom[$k])]"
                    $Content = $Content -replace $TransmutedArrTo[$k],$TransmutedArrFrom[$k]
                }

                For ($k = 0 ; $k -lt $LineCount ; $k++) {
                    Write-Debug "Transmutation pipeline stage 3:"
                    Write-Debug "  TransmutedArray FromChar is [$($TransmutedArrFrom[$k])]"
                    Write-Debug "  To char is [$($Legend[$k]."From value")]"
                    $Content = $Content -replace $TransmutedArrFrom[$k], $Legend[$k]."From value"
                }

                $Content | Out-File -FilePath $OutPath
            }
        }
    }

    End {}
}

Write-Host "Function loaded.  Please use Get-Help Format-ScrambledEggs for help" -ForegroundColor Cyan

#fin
