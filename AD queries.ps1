
# Список учеток неактивных более 90 дней
Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 | ?{$_.enabled -eq $true} | Select-Object name, objectclass, enabled, lastlogondate | Export-Csv D:\inactive.csv  -UseCulture