# run.ps1 for home_services
$env:PATH = "C:\dev\bin;C:\dev\flutter\bin;C:\Program Files\Git\cmd;C:\Program Files\Android\Android Studio\jbr\bin;" + $env:PATH
$env:ANDROID_HOME = "C:\Users\ps\AppData\Local\Android\Sdk"
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:FLUTTER_ROOT = "C:\dev\flutter"
$env:ComSpec = "C:\dev\bin\cmd.exe"

Set-Location C:\dev\home_services
Write-Host "Запуск приложения ПрофиСервис (home_services) на эмуляторе Pixel 8a..." -ForegroundColor Green
& "C:\dev\flutter\bin\cache\dart-sdk\bin\dart.exe" "C:\dev\flutter\bin\cache\flutter_tools.snapshot" run -d emulator-5554
