# OBS_custom_follower_notification
Create popup and play music in OBS. Choose any length, animation and sound. Run localy


## Installation

# Step 1

Follow instructions here to install OBS for powershell (in case link below becomes broken)
https://ianmorrish.wordpress.com/2017/05/20/automating-obs-from-powershell-script/

You will simply need to download powershell files 
https://1drv.ms/u/s!ApGpqMMpRLhikIlQpe2lqL_grayskg

And extract to the folder C:\Users\*YourUserName*\Documents\WindowsPowerShell


# Step 2

One more OBS in powershell installation. Run Powershell as Admin (alt+x --> "Windows Power Shell (Admin)")

Run command

  Install-Module -Name OBS

If you have an error first type command

  powershell.exe -executionpolicy bypass 

And then run again 

  Install-Module -Name OBS
  
  
# Step 3 

Download the folder "stream".
Save it where it will be permanently placed

Add OBS source --> Text --> connect to file:
  1) "lastfollow.txt" - list of the last 10 followers
  2) "newfollow.txt" - list of new people that follow you
  3) Extra sources to have a frame or animation

Group all the sources that you want to add into the group called "follower_animation" - group HAS to be named exactly that, so script can recognise what to make unvisible/visible

# Step 4

Open the file "get_moderator_activity.ps1" with text editor. Set up values:

  1) $myUname - your user name. It will be used to navigate to your page
  2) $filepath_audio - attach the audio that will be played when new person follows you
  3) $duration - by default your new follower popup would be the same duration as audio that you selected. But if you want to set nimber of seconds to wait instead, you can set up the number for duration (e.g. $duration = "5")
  4) cd - set where you saved your script files including stream folder (e.g. "D:\Automation\stream")


## First Time Usage

In order to run the script you can run powershell and paste line below
    powershell.exe -executionpolicy bypass -file "C:\PathWhereYouSavedYourFiles\stream\get_moderator_activity.ps1"


You will see that the windows explorer will open and go to your moderator page. Log in to your accountand ensure to put "Activity Feed" on the grid.


