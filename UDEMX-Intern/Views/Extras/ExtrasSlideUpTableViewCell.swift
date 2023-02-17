//
//  ExtrasSlideUpTableViewCell.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 15..
//

import UIKit

class ExtrasSlideUpTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private var item = Item()
    
    static let identifier = "ExtrasSlideUpTableViewCell"
    
    private let itemLabel = ExtraTitleLabel()
    private let priceLabel = BasePriceLabel()
    
    private let selectionButton: UIButton = {
        let button = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .default)
               
        let checkmark = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
        let circle = UIImage(systemName: "circle", withConfiguration: config)
        
        button.tintColor = .white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setImage(checkmark, for: .selected)
        button.setImage(circle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        selectionButton.isSelected = selected
    }
    
    // MARK: - Helpers
    
    public func configureCell(with item: Item) {
        self.item = item
        itemLabel.text = item.name
        priceLabel.text = "+ \((Float(item.price) / Float(10)).createFormattedBasePriceString())"
    }
    
    private func configureUI() {
        backgroundColor = .clear
        priceLabel.textColor = .white.withAlphaComponent(0.8)
        
        priceLabel.font = UIFont.preferredFont(forTextStyle: .callout).bold()
        
        addSubview(selectionButton)
        addSubview(itemLabel)
        addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            selectionButton.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            selectionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            itemLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            itemLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: selectionButton.trailingAnchor, multiplier: 2),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: priceLabel.trailingAnchor, multiplier: 2),
        ])
    }
    
    // MARK: - Selectors
}


