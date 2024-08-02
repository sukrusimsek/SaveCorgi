
# Save Corgi
Save Corgi is a delightful and engaging mobile game developed using Swift. The objective of the game is to protect the Corgi from being caught by the approaching enemies. The game features smooth animations, a toggle for light/dark mode, and integration with Google Mobile Ads to enhance the user experience.

## Features
Player and Enemy Animations: Smooth and fluid animations for both the player (Corgi) and the enemies (Cats).
Light/Dark Mode Toggle: Switch between light and dark modes with a stylish button.
Ad Integration: Google Mobile Ads integration to display interstitial ads.
Game States: The game has different states including ready, playing, and game over.
Best Time Tracking: Keeps track of the best time achieved by the player.

## Installation
1.Clone the repository:
```bash
git clone https://github.com/your-username/save-corgi.git
```
2.Navigate to the project directory:
```bash
cd save-corgi
```
cd save-corgi
3.Open the project in Xcode:
```bash
open SaveCorgi.xcodeproj
```
4.Install dependencies:

Make sure you have CocoaPods installed. Then, run:
```bash
pod install
```

5.Build and run the project:

Select your target device or simulator and hit 'Cmd + R' to build and run the project.

## Gameplay
* Start the Game: Tap anywhere on the screen to start the game.
* Move the Player: Tap to move the Corgi to the touched location. Enemies will follow the Corgi.
* Avoid Enemies: Keep the Corgi away from the enemies for as long as possible to achieve the highest time.
### Ad Integration
The game uses Google Mobile Ads for displaying interstitial ads. Make sure to replace the ad unit ID in the code with your own.

```swift
GADInterstitialAd.load(
    withAdUnitID: "ca-app-pub-394*2*****994***4/***********", request: GADRequest())
```

### Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your changes. Ensure that your code follows the project's coding standards and includes relevant tests.

### License
This project is licensed under the MIT License. See the LICENSE file for details.

### Contact
If you have any questions or feedback, feel free to reach out to me at sukrusimsekll@gmail.com

Enjoy saving the Corgi and happy coding!
