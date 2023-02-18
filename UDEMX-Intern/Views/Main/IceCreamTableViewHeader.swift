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
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let cartImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let cartItemNumberLabelView = CartItemNumberLabelView()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cartImageTapped))
        cartImageView.addGestureRecognizer(tap)
        
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cartItemNumberLabelView.layer.cornerRadius = cartItemNumberLabelView.frame.size.width / 2
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: logoImageView.frame.size.height + 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .red
            
        let logoImage = UIImage(named: "logo")!
        logoImageView.image = logoImage
        let cartImage = UIImage(named: "cart-outline")!
        cartImageView.image = cartImage
        
        addSubview(logoImageView)
        addSubview(cartImageView)
        cartImageView.addSubview(cartItemNumberLabelView)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: logoImage.size.height / logoImage.size.width),
            
            trailingAnchor.constraint(equalToSystemSpacingAfter: cartImageView.trailingAnchor, multiplier: 2),
            cartImageView.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            cartImageView.heightAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 0.9),
            cartImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 0.9),
            
            cartItemNumberLabelView.heightAnchor.constraint(equalTo: cartImageView.heightAnchor, multiplier: 0.5),
            cartItemNumberLabelView.widthAnchor.constraint(equalTo: cartImageView.widthAnchor, multiplier: 0.5),
            cartItemNumberLabelView.trailingAnchor.constraint(equalTo: cartImageView.trailingAnchor),
        ])
        
        logoImageView.sizeToFit()
        cartImageView.sizeToFit()
    }
    
    // MARK: - Selectors
    
    @objc func cartImageTapped() {
        cartImageView.simpleSelectingAnimation()
        delegate?.didTapBasketButton()
    }
}

