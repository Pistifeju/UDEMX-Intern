//
//  IceCreamInBasketTableViewCell.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 14..
//

import UIKit

protocol IceCreamInBasketTableViewCellDelegate: AnyObject {
    func userDidChangeStepperValue(on iceCream: IceCream, toValue: Int)
}

class IceCreamInBasketTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "IceCreamInBasketTableViewCell"
    private var iceCream = IceCream()
    
    weak var delegate: IceCreamInBasketTableViewCellDelegate?
    
    private var flavorLabel = FlavorLabel()
    private var priceLabel = BasePriceLabel()
    
    private let stepperLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        label.text = "1"
        return label
    }()
    
    private let countStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.maximumValue = 100
        stepper.minimumValue = 0
        stepper.value = 1
        stepper.tintColor = .white
        stepper.setDecrementImage(stepper.decrementImage(for: .normal), for: .normal)
        stepper.setIncrementImage(stepper.incrementImage(for: .normal), for: .normal)
        return stepper
    }()
    
    private let countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        countStepper.addTarget(self, action: #selector(stepperValueDidChange(_:)), for: .touchUpInside)
        
        configureUI()
    }
    
    override var intrinsicContentSize: CGSize {
        layoutSubviews()
        layoutIfNeeded()
        let height = countStackView.frame.size.height + 16
        return CGSize(width: UITableView.noIntrinsicMetric, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .clear
        
        priceLabel.textColor = .white.withAlphaComponent(0.8)
        priceLabel.font = UIFont.preferredFont(forTextStyle: .callout).bold()
        
        selectionStyle = .none
        
        contentView.addSubview(flavorLabel)
        contentView.addSubview(priceLabel)
        countStackView.addArrangedSubview(stepperLabel)
        countStackView.addArrangedSubview(countStepper)
        contentView.addSubview(countStackView)
        
        NSLayoutConstraint.activate([
            countStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            countStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            flavorLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: countStepper.trailingAnchor, multiplier: 2),
            flavorLabel.centerYAnchor.constraint(equalTo: countStackView.centerYAnchor),
            
            trailingAnchor.constraint(equalToSystemSpacingAfter: priceLabel.trailingAnchor, multiplier: 2),
            priceLabel.centerYAnchor.constraint(equalTo: countStackView.centerYAnchor)
        ])
    }
    
    func configureCell(with iceCream: IceCream, iceCreamCount: Int, basePrice: Float) {
        self.iceCream = iceCream
        countStepper.value = Double(iceCreamCount)
        stepperLabel.text = "\(Int(countStepper.value))"
        priceLabel.text = "+ \(Float(countStepper.value).createFormattedBasePriceString())"
        flavorLabel.text = iceCream.name == "Vanília" ? iceCream.name.uppercased() : iceCream.name
    }
    
    // MARK: - Selectors
    
    @objc private func stepperValueDidChange(_ sender: UIStepper) {
        let value = sender.value
        
        stepperLabel.text = "\(Int(value))"
        priceLabel.text = "+ \(Float(countStepper.value).createFormattedBasePriceString())"
        delegate?.userDidChangeStepperValue(on: iceCream, toValue: Int(value))
    }
}
