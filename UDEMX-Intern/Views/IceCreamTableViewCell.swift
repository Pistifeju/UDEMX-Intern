//
//  IceCreamTableViewCell.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 14..
//

import Kingfisher
import UIKit

protocol IceCreamTableViewCellDelegate: AnyObject {
    func didTapAddToBasketButton(with iceCream: IceCream)
}

class IceCreamTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "IceCreamTableViewCell"
    weak var delegate: IceCreamTableViewCellDelegate?
    private var iceCream = IceCream()
    
    private let flavorImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        iv.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        iv.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
        iv.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .vertical)
        return iv
    }()
    
    private let flavorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 249/255, green: 216/255, blue: 73/255, alpha: 1.0)
        label.text = "ERROR"
        label.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        return label
    }()
    
    private lazy var basePriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = createFormattedBasePriceString(from: 999)
        label.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [flavorLabel, basePriceLabel])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.alignment = .leading
        return stackview
    }()
    
    let toTheBasketButton = ToTheBasketButton()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        toTheBasketButton.addTarget(self, action: #selector(didSelectAddToBaskedButton(_:)), for: .touchUpInside)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .green
        
        addSubview(labelsStackView)
        contentView.addSubview(toTheBasketButton)
        addSubview(flavorImageView)
        
        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: labelsStackView.bottomAnchor, multiplier: 2),
            toTheBasketButton.centerYAnchor.constraint(equalTo: labelsStackView.centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: toTheBasketButton.trailingAnchor, multiplier: 2),
            
            flavorImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            flavorImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            flavorImageView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.topAnchor.constraint(equalToSystemSpacingBelow: flavorImageView.bottomAnchor, multiplier: 2),
        ])
    }
    
    private func createFormattedBasePriceString(from basePrice: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.generatesDecimalNumbers = false
        formatter.currencyCode = "EUR"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: basePrice)) ?? "Error"
    }
    
    func configureCell(with iceCream: IceCream, basePrice: Float) {
        self.iceCream = iceCream
        flavorLabel.text = iceCream.name == "Vanília" ? iceCream.name.uppercased() : iceCream.name
        
        if let url = iceCream.imageUrl {
            flavorImageView.kf.setImage(with: url)
            flavorImageView.contentMode = .scaleAspectFill
        } else {
            flavorImageView.image = UIImage(named: "placeholder")
        }
        
        switch iceCream.status {
        case .Unavailable, .Melted:
            toTheBasketButton.isEnabled = false
            toTheBasketButton.setTitleColor(UIColor.gray, for: .normal)
            basePriceLabel.text = iceCream.name == "Csokoládé" ? "Nem is volt :[" : "Kifogyott"
        case .Available:
            toTheBasketButton.isEnabled = true
            toTheBasketButton.setTitleColor(UIColor.red, for: .normal)
            basePriceLabel.text = createFormattedBasePriceString(from: basePrice)
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didSelectAddToBaskedButton(_ sender: UIButton) {
        sender.simpleSelectingAnimation()
        delegate?.didTapAddToBasketButton(with: self.iceCream)
    }
}

