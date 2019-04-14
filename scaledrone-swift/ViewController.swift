import UIKit

class ViewController: UIViewController, ScaledroneDelegate, ScaledroneAuthenticateDelegate, ScaledroneRoomDelegate, ScaledroneObservableRoomDelegate {

    let scaledrone = Scaledrone(channelID: "4cNswoNqM2wVFHPg", data: ["name": "Swift", "color": "#ff0000"])

    override func viewDidLoad() {
        super.viewDidLoad()
        scaledrone.delegate = self
        scaledrone.authenticateDelegate = self
        scaledrone.connect()
    }

    func scaledroneDidConnect(scaledrone: Scaledrone, error: Error?) {
        if (error != nil) {
            print(error!);
        }
        scaledrone.authenticate(jwt: "hello world")
        print("Connected to Scaledrone channel", scaledrone.clientID)
        let room = scaledrone.subscribe(roomName: "observable-room")
        room.delegate = self
        room.observableDelegate = self
        let room2 = scaledrone.subscribe(roomName: "myroom")
        room2.delegate = self
        room2.observableDelegate = self
    }

    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: Error?) {
        print("Scaledrone error", error ?? "")
    }

    func scaledroneDidDisconnect(scaledrone: Scaledrone, error: Error?) {
        print("Scaledrone disconnected", error ?? "")
    }

    func scaledroneDidAuthenticate(scaledrone: Scaledrone, error: Error?) {
        print("Scaledrone authenticated", error ?? "")
    }
    
    // Rooms
    
    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: Error?) {
        print("Scaledrone connected to room", room.name, error ?? "")
        scaledrone.publish(message: "Hello from Swift", room: room.name)

        room.publish(message: ["foo": "bar", "1": 1])
        room.publish(message: [1, 2, 3])
    }

    func scaledroneRoomDidReceiveMessage(room: ScaledroneRoom, message: Any, member: ScaledroneMember?) {
        if member != nil {
            print("Received message from member:", member?.description ?? "")
        }
        if let message = message as? [String : Any] {
            print("Received a dictionary:", message)
        }
        if let message = message as? [Any] {
            print("Received an array:", message)
        }
        if let message = message as? String {
            print("Received a string:", message)
        }
    }
    
    // Observable rooms
   
    func scaledroneObservableRoomDidConnect(room: ScaledroneRoom, members: [ScaledroneMember]) {
        print(members.map { (m: ScaledroneMember) -> Any? in
            return m.clientData
        })
    }
    
    func scaledroneObservableRoomMemberDidJoin(room: ScaledroneRoom, member: ScaledroneMember) {
        print("member joined", member, member.id)
    }
    
    func scaledroneObservableRoomMemberDidLeave(room: ScaledroneRoom, member: ScaledroneMember) {
        print("member left", member, member.id)
    }
    
}
