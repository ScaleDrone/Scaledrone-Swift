import Starscream

class Scaledrone: WebSocketDelegate {
    let socket = WebSocket(url: URL(string: "ws://localhost:3900/websocket")!)
    let callbacks:[Int:Any] = [:]
    var handshakeCallbackId:Int = 0
    
    func getCallbackId() -> Int {
        handshakeCallbackId += 1
        return handshakeCallbackId
    }
    
    init() {
        socket.delegate = self
        socket.connect()
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
        let msg = [
            "action": "handshake",
            "channel": "hDP2vDRHVuX298P5",
            "callback": getCallbackId()
        ] as [String : Any]
        self.send(msg)
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
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
    
    // MARK: Write Text Action
    
    @IBAction func writeText(_ sender: UIBarButtonItem) {
        socket.write(string: "hello there!")
    }
    
    // MARK: Disconnect Action
    
    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        if socket.isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
    
}
