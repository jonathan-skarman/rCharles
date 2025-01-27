# Set the custom directory and Ruby file path
# Replace "C:\Your\Custom\Directory" with your desired directory
$customDirectory = "C:\Users\jonathan.nissovskar\Kod\Github_Repositories\rCharles\test_server"
$rubyFile = "app.rb" # Replace with the name of your Ruby file

# Start PowerShell, navigate to the directory, and run the Ruby file
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command", "Set-Location '$customDirectory'; ruby '$rubyFile'"
