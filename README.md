# Scaledrone Swift Client (WIP)

## Usage
```swift
import UIKit

class ViewController: UIViewController, ScaledroneDelegate, ScaledroneRoomDelegate {

    let scaledrone = Scaledrone(channelID: "KtJ2qzn3CF3svSFe")

    override func viewDidLoad() {
        super.viewDidLoad()
        scaledrone.delegate = self
        scaledrone.connect()
    }

    func scaledroneDidConnect(scaledrone: Scaledrone, error: NSError?) {
        print("Connected to Scaledrone channel", scaledrone.clientID)
        let room = scaledrone.subscribe(roomName: "notifications")
        room.delegate = self
    }

    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: NSError?) {
        print("Scaledrone error")
    }

    func scaledroneDidDisconnect(scaledrone: Scaledrone, error: NSError?) {
        print("Scaledrone disconnected")
    }

    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: NSError?) {
        print("Scaledrone connected to room", room.name)
    }

    func scaledroneRoomDidReceiveMessage(room: ScaledroneRoom, message: String) {
        print("Room received message:", message)
    }
}
```

## Installation

### CocoaPods

Check out [Get Started](http://cocoapods.org/) tab on [cocoapods.org](http://cocoapods.org/).

To use Starscream in your project add the following 'Podfile' to your project
```ruby
pod 'Scaledrone', '~> 0.1.0'
```

Then run:
```
pod install
```
## ToDo:

* JWT authentication
* Automatic reconnection
* Sending messages
* Observable rooms
