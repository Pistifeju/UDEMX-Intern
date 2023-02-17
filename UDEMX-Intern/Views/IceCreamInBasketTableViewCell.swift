//
//  IceCreamInBasketTableViewCell.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 14..
//

import UIKit

class IceCreamInBasketTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "IceCreamInBasketTableViewCell"
    private var iceCream = IceCream()
    
    private var flavorLabel = FlavorLabel()
    private var priceLabel = BasePriceLabel()
    
    private let stepperLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "1"
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .clear
                
        selectionStyle = .none
        
        contentView.addSubview(flavorLabel)
        contentView.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            flavorLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            flavorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: priceLabel.trailingAnchor, multiplier: 2),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureCell(with iceCream: IceCream, basePrice: Float) {
        self.iceCream = iceCream
        flavorLabel.text = iceCream.name == "Vanília" ? iceCream.name.uppercased() : iceCream.name
        priceLabel.text = basePrice.createFormattedBasePriceString()
    }
    
    // MARK: - Selectors
}
