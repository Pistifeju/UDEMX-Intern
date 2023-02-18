//
//  CartItemNumberLabelView.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 18..
//

import UIKit

class CartItemNumberLabelView: UIView {
    
    // MARK: - Properties
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "1+"
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        countLabel.font = UIFont.systemFont(ofSize: frame.size.height * 0.8)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .black
        
        addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    // MARK: - Selectors
    
}

