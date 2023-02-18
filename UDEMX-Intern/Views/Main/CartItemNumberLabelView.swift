//
//  CartItemNumberLabelView.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 18..
//

import UIKit
 
protocol CartItemNumberLabelViewDelegate: AnyObject {
    func CartItemNumberViewIsHidden(isHidden: Bool)
}

class CartItemNumberLabelView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CartItemNumberLabelViewDelegate?
    
    private var basketCount = 0 {
        didSet {
            countLabel.text = basketCount > 9 ? "9+" : "\(basketCount)"
            delegate?.CartItemNumberViewIsHidden(isHidden: basketCount > 0 ? false : true)
        }
    }
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "0"
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(basketChanged), name: NSNotification.Name("BasketChanged"), object: nil)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("BasketChanged"), object: nil)
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
    
    @objc private func basketChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo, let basket = userInfo["basket"] as? [IceCream: Int] {
            basketCount = 0
            for iceCream in basket {
                basketCount += iceCream.value
            }
        }
    }
    
}

