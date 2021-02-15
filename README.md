# [Scaledrone](https://www.scaledrone.com/) Swift

> Use the Scaledrone Swift client to connect to the Scaledrone realtime messaging service

This project is still a work in progress, pull requests and issues are very welcome.


## Installation

### CocoaPods

Check out [Get Started](http://cocoapods.org/) tab on [cocoapods.org](http://cocoapods.org/).

To use Scaledrone in your project add the following 'Podfile' to your project

```ruby
pod 'Scaledrone', '~> 0.5.2'
```

Then run:
```
pod install
```

### Carthage

Check out [the Carthage Quick Start instructions](https://github.com/Carthage/Carthage#quick-start).

To use Scaledrone with Carthage, add the following to your Cartfile:

```ruby
github "ScaleDrone/Scaledrone-Swift"
```

Then run:

```
carthage update
```

After that, follow the [instructions on Carthage's docs](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

### Swift Package Manager

[Use Xcode to add this repo as a package.](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) Search for `https://github.com/ScaleDrone/Scaledrone-Swift`.

## Usage

First thing is to import the framework. See the Installation instructions on how to add the framework to your project.

```swift
import Scaledrone
```

Once imported, you can connect to Scaledrone.

```swift
scaledrone = Scaledrone(channelID: "your-channel-id")
scaledrone.delegate = self
scaledrone.connect()
```

After you are connected, there are some delegate methods that we need to implement.

#### scaledroneDidConnect

```swift
func scaledroneDidConnect(scaledrone: Scaledrone, error: Error?) {
    print("Connected to Scaledrone")
}
```

#### scaledroneDidReceiveError

```swift
func scaledroneDidReceiveError(scaledrone: Scaledrone, error: Error?) {
    print("Scaledrone error", error ?? "")
}
```

#### scaledroneDidDisconnect

```swift
func scaledroneDidDisconnect(scaledrone: Scaledrone, error: Error?) {
    print("Scaledrone disconnected", error ?? "")
}
```

## Authentication

Implement the **`ScaledroneAuthenticateDelegate`** protocol and set an additional delegate
```swift
scaledrone.authenticateDelegate = self
```

Then use the authenticate method to authenticate using a JWT

```swift
scaledrone.authenticate(jwt: "jwt_string")
```

#### scaledroneDidAuthenticate

```swift
func scaledroneDidAuthenticate(scaledrone: Scaledrone, error: Error?) {
    print("Scaledrone authenticated", error ?? "")
}
```

## Sending messages

```swift
scaledrone.publish(message: "Hello from Swift", room: "myroom")
// Or
room.publish(message: ["foo": "bar", "1": 2])
```

## Subscribing to messages

Subscribe to a room and implement the **`ScaledroneRoomDelegate`** protocol, then set additional delegation

```swift
let room = scaledrone.subscribe(roomName: "myroom")
room.delegate = self
```

#### scaledroneRoomDidConnect

```swift
func scaledroneRoomDidConnect(room: ScaledroneRoom, error: Error?) {
    print("Scaledrone connected to room", room.name, error ?? "")
}
```

#### scaledroneRoomDidReceiveMessage

The `member` argument exists when the message was sent to an [observable room](#observable-rooms) using the socket API (not the REST API).

```swift
func scaledroneRoomDidReceiveMessage(room: ScaledroneRoom, message: ScaledroneMessage) {
    if message.member != nil {
        // This message was sent to an observable room
        // This message was sent through the socket API, not the REST API
        print("Received message from member:", message.memberID as Any)
    }
    
    let data = message.data
    
    if let messageData = data as? [String: Any] {
        print("Received a dictionary:", messageData)
    }
    if let messageData = data as? [Any] {
        print("Received an array:", messageData)
    }
    if let messageData = data as? String {
        print("Received a string:", messageData)
    }
}
```

## Observable rooms

Observable rooms act like regular rooms but provide additional functionality for keeping track of connected members and linking messages to members.

### Adding data to the member object

Observable rooms allow adding custom data to a connected user. The data can be added in two ways:

1. Passing the data object to a new instance of Scaledrone in your Swift code.
```swift
let scaledrone = Scaledrone(channelID: "<channel_id>", data: ["name": "Swift", "color": "#ff0000"])
```
This data can later be accessed like so:
```swift
func scaledroneObservableRoomMemberDidJoin(room: ScaledroneRoom, member: ScaledroneMember) {
    print("member joined with clientData", member.clientData)
}
```

2. Adding the data to the JSON Web Token as the `data` clause during [authentication](https://www.scaledrone.com/docs/jwt-authentication). This method is safer as the user has no way of changing the data on the client side.
```json
{
  "client": "client_id_sent_from_javascript_client",
  "channel": "channel_id",
  "data": {
    "name": "Swift",
    "color": "#ff0000"
  },
  "permissions": {
    "^main-room$": {
      "publish": false,
      "subscribe": false
    }
  },
  "exp": 1408639878000
}
```
This data can later be accessed like so:
```swift
func scaledroneObservableRoomMemberDidJoin(room: ScaledroneRoom, member: ScaledroneMember) {
    print("member joined with authData", member.authData)
}
```

### Receiving the observable events

Implement the **`ScaledroneObservableRoomDelegate`** protocol, then set additional delegation.

> Observable room names need to be prefixed with *observable-*

```swift
let room = scaledrone.subscribe(roomName: "observable-room")
room.delegate = self
room.observableDelegate = self
```

#### scaledroneObservableRoomDidConnect
```swift
func scaledroneObservableRoomDidConnect(room: ScaledroneRoom, members: [ScaledroneMember]) {
    // The list will contain yourself
    print(members.map { (m: ScaledroneMember) -> String in
        return m.id
    })
}
```

#### scaledroneObservableRoomMemberDidJoin
```swift
func scaledroneObservableRoomMemberDidJoin(room: ScaledroneRoom, member: ScaledroneMember) {
    print("member joined", member, member.id)
}
```

#### scaledroneObservableRoomMemberDidLeave
```swift
func scaledroneObservableRoomMemberDidLeave(room: ScaledroneRoom, member: ScaledroneMember) {
    print("member left", member, member.id)
}
```

## Message History

When creating a Scaledrone room you can supply the number of messages to recieve from that room's history. The messages will arrive, in reverse chronological order and one by one, in `scaledroneRoomDidReceiveMessage`, just like real-time messages.

In order to recieve message history messages, this feature needs to be enabled in the [Scaledrone dashboard](http://dashboard.scaledrone.com). You can learn more about Message History and its limitations in [Scaledrone docs](https://www.scaledrone.com/docs/message-history).

```
let room = scaledrone.subscribe(roomName: "chat-room", messageHistory: 50)
```


## Basic Example
```swift
import UIKit

class ViewController: UIViewController, ScaledroneDelegate, ScaledroneRoomDelegate {

    let scaledrone = Scaledrone(channelID: "your-channel-id")

    override func viewDidLoad() {
        super.viewDidLoad()
        scaledrone.delegate = self
        scaledrone.connect()
    }

    func scaledroneDidConnect(scaledrone: Scaledrone, error: Error?) {
        print("Connected to Scaledrone channel", scaledrone.clientID)
        let room = scaledrone.subscribe(roomName: "notifications")
        room.delegate = self
    }

    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: Error?) {
        print("Scaledrone error")
    }

    func scaledroneDidDisconnect(scaledrone: Scaledrone, error: Error?) {
        print("Scaledrone disconnected")
    }

    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: Error?) {
        print("Scaledrone connected to room", room.name)
    }

    func scaledroneRoomDidReceiveMessage(room: ScaledroneRoom, message: String) {
        print("Room received message:", message)
    }
}
```

For a longer example see the `ViewController.swift` file.

## Migration notes

### 0.5.0

Scaledrone 0.5.0 removes the use of `NSError` in favor of `Error` in the delegate methods, and adds support for Swift 5.

### 0.5.2:

`scaledroneRoomDidReceiveMessage(room:message:member)` was renamed to `scaledroneRoomDidReceiveMessage(room:message:)` and `message` is now of type `ScaledroneMessage` which includes the member and message IDs, the message's time as well as the data that was sent.

## Todo:

* Automatic reconnection
