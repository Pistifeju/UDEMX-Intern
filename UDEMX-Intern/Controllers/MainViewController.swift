//
//  MainViewController.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 13..
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        self.view.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    private func fetchIceCreams() {
        NetworkCaller.shared.getIceCreams { result in
            switch result {
            case .success(let iceCreams):
                print(iceCreams)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Selectors
}

