import Starscream

public protocol ScaledroneDelegate: class {
    func scaledroneDidConnect(scaledrone: Scaledrone, error: NSError?)
    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: NSError?)
}

public protocol ScaledroneRoomDelegate: class {
    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: NSError?)
    func scaledroneRoomDidReceiveMessage(room: ScaledroneRoom, message: String)
}

public class Scaledrone: WebSocketDelegate {
    
    private typealias Callback = ([String:Any]) -> Void
    
    private let socket = WebSocket(url: URL(string: "ws://localhost:3900/websocket")!)
    private var callbacks:[Int:Callback] = [:]
    private var callbackId:Int = 0
    private var rooms:[String:ScaledroneRoom] = [:]
    public var clientID:String = ""
    
    public weak var delegate: ScaledroneDelegate?
    
    func getCallbackId() -> Int {
        callbackId += 1
        return callbackId
    }
    
    private func createCallback(fn: @escaping Callback) -> Int {
        callbackId += 1
        callbacks[callbackId] = fn
        return callbackId
    }
    
    public func connect() {
        print("connecting")
        socket.delegate = self
        socket.connect()
    }
    
    // MARK: Websocket Delegate Methods.
    
    public func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
        let msg = [
            "action": "handshake",
            "channel": "hDP2vDRHVuX298P5",
            "callback": createCallback(fn: { data in
                self.clientID = data["clientId"] as! String
                self.delegate?.scaledroneDidConnect(scaledrone: self, error: nil)
            })
        ] as [String : Any]
        self.send(msg)
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("Received text: \(text)")
        let dic = convertJSONMessageToDictionary(text: text)
        
        var data:[String:Any] = [:]
        if let d = dic["data"] as? [String: Any] {
            data = d
        }
        
        if let cb = dic["callback"] as? Int {
            if let fn = callbacks[cb] as Callback! {
                fn(data)
            }
            return
        }
        
        if let error = dic["error"] as? String {
            //delegate?.scaledroneDidReceiveError(scaledrone: <#T##Scaledrone#>, error: NSError?)
            print("error", error)
            return
        }
        
        if let roomName = dic["room"] as? String {
            if let room = rooms[roomName] as ScaledroneRoom? {
                room.delegate?.scaledroneRoomDidReceiveMessage(room: room, message: dic["message"] as! String)
            }
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("Received data: \(data.count)")
    }
    
    func send(_ value: Any) {
        guard JSONSerialization.isValidJSONObject(value) else {
            print("[WEBSOCKET] Value is not a valid JSON object.\n \(value)")
            return
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: value, options: [])
            socket.write(data: data)
        } catch let error {
            print("[WEBSOCKET] Error serializing JSON:\n\(error)")
        }
    }
    
    func subscribe(roomName: String) -> ScaledroneRoom {
        let room = ScaledroneRoom(name: roomName)
        rooms[roomName] = room
        
        let msg = [
            "action": "subscribe",
            "room": roomName,
            "callback": createCallback(fn: { data in
                room.delegate?.scaledroneRoomDidConnect(room: room, error: nil)
            })
            ] as [String : Any]
        self.send(msg)
        
        return room
    }
    
}

public class ScaledroneRoom {
    
    public let name:String
    
    public weak var delegate: ScaledroneRoomDelegate?
    
    init(name: String) {
        self.name = name
    }
    
}

func convertJSONMessageToDictionary(text: String) -> [String: Any] {
    if let message = text.data(using: .utf8) {
        do {
            var json = try JSONSerialization.jsonObject(with: message, options: []) as! [String: Any]
            if let data = json["data"] as? [[String: Any]] {
                json["data"] = data
            }
            return json
        } catch {
            print(error.localizedDescription)
        }
    }
    return [:]
}
