//
//  CustomRedButton.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 14..
//

import Foundation

import UIKit

class CustomRedButton: UIButton {
        
    // MARK: - Lifecycle
    
    init(with title: String) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 15, bottom: 8, trailing: 15)
        
        self.configuration = configuration
        
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setTitleColor(.red, for: .normal)
        setTitleColor(.red, for: .highlighted)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline).bold()
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

