//
//  ExtrasSlideUpView.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 15..
//


import UIKit

class ExtrasSlideUpView: UIView {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 300)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0
        clipsToBounds = true
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    // MARK: - Selectors
    
}

