import UIKit

class ViewController: UIViewController, ScaledroneDelegate, ScaledroneAuthenticateDelegate, ScaledroneRoomDelegate, ScaledroneObservableRoomDelegate {

    let scaledrone = Scaledrone(channelID: "4cNswoNqM2wVFHPg", data: ["name": "Swift", "color": "#ff0000"])

    override func viewDidLoad() {
        super.viewDidLoad()
        scaledrone.delegate = self
        scaledrone.authenticateDelegate = self
        scaledrone.connect()
    }

    func scaledroneDidConnect(scaledrone: Scaledrone, error: NSError?) {
        if (error != nil) {
            print(error!);
        }
        scaledrone.authenticate(jwt: "hello world")
        print("Connected to Scaledrone channel", scaledrone.clientID)
        let room = scaledrone.subscribe(roomName: "observable-room")
        room.delegate = self
        room.observableDelegate = self
    }

    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: NSError?) {
        print("Scaledrone error", error ?? "")
    }

    func scaledroneDidDisconnect(scaledrone: Scaledrone, error: NSError?) {
        print("Scaledrone disconnected", error ?? "")
    }

    func scaledroneDidAuthenticate(scaledrone: Scaledrone, error: NSError?) {
        print("Scaledrone authenticated", error ?? "")
    }
    
    // Rooms
    
    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: NSError?) {
        print("Scaledrone connected to room", room.name, error ?? "")
        scaledrone.publish(message: "Hello from Swift", room: room.name)

        room.publish(message: ["foo": "bar", "1": 1])
        room.publish(message: [1, 2, 3])
    }

    func scaledroneRoomDidReceiveMessage(room: ScaledroneRoom, message: Any) {
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
   
    func scaledroneObservableRoomDidConnect(members: [ScaledroneMember]) {
        print("members", members)
        print(members.map { (m: ScaledroneMember) -> String in
            return m.id
        })
    }
    
    func scaledroneObservableRoomMemberDidJoin(member: ScaledroneMember) {
        print("member joined", member, member.id)
    }
    
    func scaledroneObservableRoomMemberDidLeave(member: ScaledroneMember) {
        print("member left", member, member.id)
    }
    
}
