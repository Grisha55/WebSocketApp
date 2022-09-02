//
//  ViewController.swift
//  WebSocketApp
//
//  Created by Григорий Виняр on 02/09/2022.
//

import UIKit

class ViewController: UIViewController {

  // MARK: - Properties
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
  }
  
  // MARK: - Methods
  private func setupDisconnectButton() {
    view.addSubview(disconnectButton)
    disconnectButton.addTarget(self, action: #selector(disconnectButtonAction), for: .touchUpInside)
    
    disconnectButton.translatesAutoresizingMaskIntoConstraints = false
    disconnectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    disconnectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

  @objc
  func disconnectButtonAction() {
    
  }
  
}

