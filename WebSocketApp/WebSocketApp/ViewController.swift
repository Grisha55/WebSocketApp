//
//  ViewController.swift
//  WebSocketApp
//
//  Created by Григорий Виняр on 02/09/2022.
//

import UIKit

class ViewController: UIViewController {

  // MARK: - Properties
  private var webSocket: URLSessionWebSocketTask?
  
  private let disconnectButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .red
    button.setTitle("Disconnect", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .blue
    
    setupDisconnectButton()
    setupWebSocket()
  }
  
  // MARK: - Methods
  func setupWebSocket() {
    // Session
    let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    
    // Server API
    guard let url = URL(string: "wss://demo.piesocket.com/v3/channel_1?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self") else { return }
    
    // Socket
    webSocket = session.webSocketTask(with: url)
    
    // Connect and handles handshake
    webSocket?.resume()
  }
  
  // MARK: Receive
  func receive() {
    let workItem = DispatchWorkItem { [weak self] in
      
      self?.webSocket?.receive(completionHandler: { result in
        
        switch result {
        case .success(let message):
          
          switch message {
            
          case .data(let data):
            print("Data receive \(data)")
            
          case .string(let strMessage):
            print("String received \(strMessage)")
            
          default:
            break
          }
        case .failure(let error):
          print("Error Receiving \(error)")
        }
        
        // Creates the Recurrsion
        self?.receive()
      })
    }
    
    DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: workItem)
  }
  
  // MARK: Send
  func send() {
    let workItem = DispatchWorkItem {
      
      // Send webSocket
      self.webSocket?.send(URLSessionWebSocketTask.Message.string("Hello"), completionHandler: { error in
        
        if error == nil {
          // if error is nil we will continue to send messages else we will stop
          self.send()
        } else {
          print(error)
        }
      })
    }
    
    DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: workItem)
  }
  
  private func setupDisconnectButton() {
    view.addSubview(disconnectButton)
    disconnectButton.addTarget(self, action: #selector(disconnectButtonAction), for: .touchUpInside)
    
    disconnectButton.translatesAutoresizingMaskIntoConstraints = false
    disconnectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    disconnectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

  @objc
  func disconnectButtonAction() {
    webSocket?.cancel(with: .goingAway, reason: "You've Closed The Connection".data(using: .utf8))
  }
  
}

// MARK: - URLSessionWebSocketDelegate
extension ViewController: URLSessionWebSocketDelegate {
  
  func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
    print("Connected to server")
    self.receive()
    self.send()
  }
  
  func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
    print("Disconnect from server \(reason)")
  }
  
}
