# MindGeekTest

1. On the first launch land on settings page with toggle control to activate/deactivate passcode secure mode. When user switches control on, a view will pop-up. User enters new passcode and then he should confirm it into another view. If 2 passcode don’t coincide - error alert. On success - passcode screen should dismiss and user should see “Settings” view with a switch control toggled on. 
 
2. “Settings” view page should be the main (root) view of the app. All other screens should appear modally above it.
 
3. With activated “secured” mode (passcode is setup): 
- if user puts application into background and then brings it back to foreground, he should land on “Enter Passcode” screen (it should be presented as a modal window above  and enter correct passcode.
- if entered passcode is incorrect: show error message. After 3 failed attempts - app should be locked for 1 minute and display a corresponding message for user (see attached mockup). If user “kills” the app when it was locked for a minute and launches it again, the app should stay locked until timeout.
- if entered passcode is correct: dismiss “Enter passcode” screen and the user should see “Settings” view.
- if user “kills” the app and launches it again: he should land on “Enter Passcode” screen (same as return back to foreground) and the main view (“Settings” view) should be blocked for him until he enters correct passcode.
 
4. With deactivated “secured” mode (passcode is not setup and the switch control on “Settings” page was toggled off):
- user always land on “Settings” page when he launches the app or if he brings it back to foreground.




# Note 
Userdefaults not working accurately in simulator, if something unusual happens try installing it on device.
