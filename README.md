# Scrambled Eggs
# Powershell-based obfuscator

## How to use

1. Download or git clone
2. Run Powershell as administrator
3. Turn off execution policy
``` Set-ExecutionPolicy Unrestricted ```

3. Run Powershell bypassing execution policy
``` . $pshome\powershell.exe -executionpolicy bypass ```

4. Load function
``` /path/to/script.ps1 ```
``` Format-ScrambledEggs ```

## Parameters

- FilePath (path) needs a path to a source file that you want to obfuscate 
- OutPath (path) needs an output path for the obfuscated file.  If not specified, defaults to $psscriptroot/out directory
- Scramble (switch) parameter scrambles the file
- Unscramble (switch) parameter unscrambles the file
- LegendPath (path) path to a csv that's used for substitution method
- Delimitor (any symbol not contained in legend) this is used for the token creation

## Notes

### Can do:
Script currently works and tested with the Latin alphabet without diacritics.
Script requires a complete legend to work correctly, which means any character in the "to character" column must have a "from character".
This may seem about backwards, so here's an example:

```
{
    Substitution.csv
    a,b
    b,c
}
```

This won't work because when scrambled, "b" changes to "c", but when descrambled, "c" changes to "b" changes to "a".

To form a completed legend use:


```
{
    Substitution.csv
    a,b
    b,c
    c,a
}
```

Here, there is no left out "to char".

### Can't do:

The current version cannot scramble numbers currently.  This is due to the token generation being a value between 1000 and 9999 (for digit decimal)
Cannot distinguish between capitals and lowercase.  This is because Powershell translates lowercase and uppercase the same.  I'm not sure if this is important enough to investigate a fix.
I have only latin and cyrillic characters.  Arabic and Hebrew pangrams are listed in the example text, but are somewhat difficult to troubleshoot (they are written right to left).
