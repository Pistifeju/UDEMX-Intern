//
//  IceCreamTableViewHeader.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 14..
//

import UIKit
import AVKit

protocol IceCreamTableViewHeaderDelegate: AnyObject {
    func didTapBasketButton()
}

class IceCreamTableViewHeader: UIView {
    
    // MARK: - Properties
    
    weak var delegate: IceCreamTableViewHeaderDelegate?
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(named: "cart-outline"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cartButton.addTarget(self, action: #selector(didTapCartButton(_:)), for: .touchUpInside)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .red
            
        addSubview(logoImageView)
        addSubview(cartButton)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 1/2),
            
            trailingAnchor.constraint(equalToSystemSpacingAfter: cartButton.trailingAnchor, multiplier: 2),
            cartButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cartButton.heightAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 0.7),
            cartButton.widthAnchor.constraint(equalTo: cartButton.heightAnchor, multiplier: 0.7),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didTapCartButton(_ sender: UIButton) {
        sender.simpleSelectingAnimation()
        delegate?.didTapBasketButton()
    }
}

