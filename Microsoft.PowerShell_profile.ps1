oh-my-posh init pwsh | Invoke-Expression
# Add this to your PowerShell profile (usually in $PROFILE)
oh-my-posh init pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression
Enable-PoshTooltips
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
