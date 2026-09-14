# smtp_config.ps1
# Usage: run on alert gateway; secrets retrieved from vault
$SmtpHost = "smtp-relay.internal.example"
$SmtpPort = 587
$SmtpUserSecret = "vault:secret/alert/smtp_user"
$SmtpPassSecret = "vault:secret/alert/smtp_pass"

function Send-AlertEmail {
  param(
    [string]$to,
    [string]$subject,
    [string]$body
  )
  $user = Get-Secret -Path $SmtpUserSecret
  $pass = Get-Secret -Path $SmtpPassSecret
  $securePass = ConvertTo-SecureString $pass -AsPlainText -Force
  $cred = New-Object System.Management.Automation.PSCredential ($user, $securePass)
  Send-MailMessage -SmtpServer $SmtpHost -Port $SmtpPort -Credential $cred -UseSsl -From "alert@mico.local" -To $to -Subject $subject -Body $body
}
