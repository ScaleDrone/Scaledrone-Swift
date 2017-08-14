import Starscream

public protocol ScaledroneDelegate: class {
    func scaledroneDidConnect(scaledrone: Scaledrone, error: NSError?)
    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: NSError?)
}

public protocol ScaledroneRoomDelegate: class {
    func scaledroneRoomDidConnect(error: NSError?)
    func scaledroneRoomDidReceiveMessage(message: String)
}

public class Scaledrone: WebSocketDelegate {
    
    let socket = WebSocket(url: URL(string: "ws://localhost:3900/websocket")!)
    let callbacks:[Int:(Any?)->()] = [:]
    var callbackId:Int = 0
    
    public weak var delegate: ScaledroneDelegate?
    
    func getCallbackId() -> Int {
        callbackId += 1
        return callbackId
    }
    
    func connect() {
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
            "callback": getCallbackId()
        ] as [String : Any]
        self.send(msg)
        self.delegate?.scaledroneDidConnect(scaledrone: self, error: nil)
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
        
        if let data = dic["data"] as? [String: Any] {
            print(data["clientId"]!)
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
