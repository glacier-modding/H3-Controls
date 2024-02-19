# H3-Scaleform-Decompilation-Project

## Building
### Prerequisites
You will need the following things:
* Flex SDK - https://flex.apache.org/download-binaries.html (apache-flex-sdk-4.16.1-bin.zip).
* Air SDK - https://airsdk.harman.com/download (AIR SDK for Flex Developers).
* IntelliJ IDEA with the Flash/Flex plugin (has to be the ultimate edition).
  * You could use an alternative free IDE like FlashDevelop, but you'd have to set it up manually.

### Steps
1. Extract Flex SDK into `C:\FlexSDK` (or a similar location).
2. Extract the contents of Air SDK into the `C:\FlexSDK` folder.
3. Open up this project in IDEA.
4. Point IDEA to the Flex SDK:

   File -> Project Structure -> SDKs -> Click the + icon -> Add new Flex/AIR SDK... -> Point it to `C:\FlexSDK` or whichever folder you choose earlier.
5. Hit Ctrl - F9 and it should build all the SWFs.

## Todo
* Organise all the symbols in the fla files.
    * Moving shared ones to libraries like what was done with ButtonPrompt.fla.
    * Create folders.
    * Rename symbols that don't have proper names? (Not sure if this will make it harder to update the files when new game versions come out.)
* Figure out more variable names for scripts.
* Fix bugs, bugs, bugs and more bugs.
* Don't go insane.