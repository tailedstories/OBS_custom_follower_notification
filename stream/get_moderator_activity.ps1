#Your twitch username
$myUname = "tailedstories"

#Folder on Your computer where you saved the script
cd "D:\Automation\stream"

#Path to the audio file that will be played for new follower
$filepath_audio = "D:\creative\obs\1.wav"

#Set duration to "" to play full length of audio file
#Or set duration for the number of seconds to play follower animation
$duration = ""

#################################################################
#################################################################
#                                                               #
#        The rest is tech stuff, no need to set                 #
#                                                               #
#################################################################
#################################################################




function Invoke-IEWait {
    [cmdletbinding()]
    Param(
        [Parameter(
            Mandatory,
            ValueFromPipeLine
        )]
        $ieObject
    )

    While ($ieObject.Busy) {

        Start-Sleep -Milliseconds 10

    }

}




Add-Type -AssemblyName presentationCore

Connect-obs -ip "localhost" -port 4444

Add-Type -path 'C:\Users\moroz\Documents\WindowsPowerShell\obs-websocket-dotnet.dll'
$obs = new-object OBSWebsocketDotNet.OBSWebsocket
$obs.Connect("ws://localhost:4444", "")

$link = "https://www.twitch.tv/moderator/" + $myUname

$ieObject = New-Object -ComObject 'InternetExplorer.Application'
$ieObject.Navigate($link)
$ieObject.Visible = $true

$ieObject | Invoke-IEWait
Start-Sleep -Seconds 20

$filepath = [uri] $filepath_audio
$wmplayer = New-Object System.Windows.Media.MediaPlayer
$wmplayer.Open($filepath)
Start-Sleep 2 # This allows the $wmplayer time to load the audio file
if($duration -like ""){$duration = $wmplayer.NaturalDuration.TimeSpan.TotalSeconds}else{$duration=$duration -as [int]}
$wmplayer.Close()



While (1){

$currentDocument = $ieObject.Document
$document = $currentDocument.IHTMLDocument3_documentElement


    $i = $document.innerHTML
    #$ii = $i -split 'class="activity-list-layout">'
    #$iii = $ii.Get(1) -split 'class="tw-link tw-link--button tw-link--inherit">'
    $ii = $i -split 'class="new-event-notification-banner tw-absolute tw-full-width"'
    $iii = $ii.get(1) -split "</div></div></div></div></div>"
    $iii = $iii.get(0) -split "</button></p>"

    $k=0
    $arr = New-Object System.Collections.ArrayList
    $lastfollow = Get-Content -Path "./lastfollow.txt"
    $mycancel=0



    foreach ($follower in $iii){
        $f = $follower -split 'tw-link">'
        if ($f.Length -gt 1) {
            #if( $lastfollow -eq $f.get(1)) {$mycancel=1}

#        if($mycancel > 0){
            if($k -lt 11) {
                $s=$follower -split '</button>'
                $arr.Add($f.get(1))
            }
        }
        $k=$k+1
    }
    

    $ss=$arr | out-string
    $lastfollow=$lastfollow | out-string
	
	
	
	$mycancel=0
	
	$arr2 = New-Object System.Collections.ArrayList

	foreach ($a in $arr){
		
		if( ($lastfollow -like "*" + $a + "*") -and ($a.Length -gt 0)) {$mycancel=1}

		if($mycancel -lt 1){
				$arr2.Add($a)
		}
	}
	
    if(($arr2[0].Length -gt 0) -and ($lastfollow -ne $ss)){
        
		Remove-Item -Path "./lastfollow.txt"
        New-Item -Path . -Name "lastfollow.txt" -ItemType "file" -Value $ss
		
		
		
		$ss=$arr2 | out-string
		Remove-Item -Path "./newfollow.txt"
        New-Item -Path . -Name "newfollow.txt" -ItemType "file" -Value $ss
		
		Start-Sleep -s 1
		
		$nam = $obs.GetCurrentScene() | select Name
		
		
		$wmplayer = New-Object System.Windows.Media.MediaPlayer
		$wmplayer.Open($filepath)
		Start-Sleep 2 # This allows the $wmplayer time to load the audio file
		
		$wmplayer.Play()
		
		
		
		Show-obsSource -SceneName $nam.Name -SourceName "follower_animation" -Show $true
		
		Start-Sleep ($duration + 2)
		$wmplayer.Stop()
		$wmplayer.Close()


		Show-obsSource -SceneName $nam.Name -SourceName "follower_animation" -Show $false
    }


    Start-Sleep -s 1
}
