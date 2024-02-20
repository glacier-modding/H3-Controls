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
   5. File -> Project Structure -> SDKs -> Click the + icon -> Add new Flex/AIR SDK... -> Point it to `C:\FlexSDK` or whichever folder you choose earlier. 
   6. File -> Project Structure -> Modules -> Module -> -> Dependencies -> Select Flex/AIR SDK in Flex/AIR SDK dropdown.
   7. File -> Project Structure -> Project -> Select Flex/AIR SDK in the SDK dropdown.
5. Hit Ctrl - F9 and it should build all the SWFs.

## Example mods that utilised files from this repository
1. [Simple Health Bar](https://github.com/Notexe/h3-simple-health-bar)