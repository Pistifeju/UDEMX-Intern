//
//  IceCreamInBasketTableViewCell.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 14..
//

import UIKit

protocol IceCreamInBasketTableViewCellDelegate: AnyObject {
    func stepperValueDidChange(with iceCream: IceCream, _ stepperValue: Int)
}

class IceCreamInBasketTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "IceCreamInBasketTableViewCell"
    weak var delegate: IceCreamInBasketTableViewCellDelegate?
    private var iceCream = IceCream()
    
    private var flavorLabel = FlavorLabel()
    private var basePriceLabel = BasePriceLabel()
    
    private lazy var flavorCountStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [stepperValueLabel, flavorCountStepper])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.alignment = .center
        return stackview
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [flavorLabel, basePriceLabel])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.alignment = .leading
        return stackview
    }()
    
    private let stepperValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title3).bold()
        return label
    }()
    
    private let flavorCountStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.maximumValue = 999
        stepper.value = 1
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.tintColor = .white
        stepper.setDecrementImage(stepper.decrementImage(for: .normal), for: .normal)
        stepper.setIncrementImage(stepper.incrementImage(for: .normal), for: .normal)
        return stepper
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 100)
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        flavorCountStepper.addTarget(self, action: #selector(valueChangeForStepper(_:)), for: .valueChanged)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .clear
        
        stepperValueLabel.text = "\(Int(flavorCountStepper.value))"
        
        selectionStyle = .none
        
        addSubview(labelsStackView)
        contentView.addSubview(flavorCountStackView)
        
        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: labelsStackView.bottomAnchor, multiplier: 2),
            
            flavorCountStackView.centerYAnchor.constraint(equalTo: labelsStackView.centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: flavorCountStackView.trailingAnchor, multiplier: 2),
        ])
    }
    
    func configureCell(with iceCream: IceCream, basePrice: Float) {
        self.iceCream = iceCream
        flavorLabel.text = iceCream.name == "Vanília" ? iceCream.name.uppercased() : iceCream.name
        basePriceLabel.text = basePrice.createFormattedBasePriceString()
    }
    
    // MARK: - Selectors
    
    @objc private func valueChangeForStepper(_ sender: UIStepper) {
        let stepperValue = Int(sender.value)
        stepperValueLabel.text = "\(stepperValue)"
        delegate?.stepperValueDidChange(with: iceCream, stepperValue)
    }
}

