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
    func availibilitySegmentedControlDidChange(to status: Status)
}

class IceCreamTableViewHeader: UIView {
    
    // MARK: - Properties
    
    weak var delegate: IceCreamTableViewHeaderDelegate?
    
    private var selectedSegmentIndex = -1 {
        didSet {
            if selectedSegmentIndex == -1 {
                availibilitySegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
            } else {
                availibilitySegmentedControl.selectedSegmentIndex = selectedSegmentIndex
            }
            
        }
    }
    
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
    
    private let availibilitySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.strokeColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .application)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentedControl.selectedSegmentTintColor = .black.withAlphaComponent(0.5)
        return segmentedControl
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cartImageTapped))
        cartImageView.addGestureRecognizer(tap)
        
        availibilitySegmentedControl.addTarget(self, action: #selector(didChangeSegmentedControl(_:)), for: .valueChanged)
        
        cartItemNumberLabelView.delegate = self
        
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cartItemNumberLabelView.layer.cornerRadius = cartItemNumberLabelView.frame.size.width / 2
        let segmentedControlFont = UIFont.systemFont(ofSize: availibilitySegmentedControl.frame.size.height / 2)
        availibilitySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: segmentedControlFont], for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        let constraintHeight = 32 // 16 for segmentedControl top and bottom anchor
        return CGSize(width: UIScreen.main.bounds.width, height: logoImageView.frame.size.height + availibilitySegmentedControl.frame.size.height + CGFloat(constraintHeight))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    public func setSegmentedControlTitles(with: IceCreamResponse) {
        let iceCreams = with.iceCreams
        var items: [Status] = []

        for iceCream in iceCreams {
            let status = iceCream.status
            var hungarianStatus = ""
            
            switch status {
            case .Available:
                hungarianStatus = "Elérhető"
            case .Melted:
                hungarianStatus = "Kifogyott"
            case .Unavailable:
                hungarianStatus = "Nem is volt"
            }
            
            if !items.contains(status) {
                DispatchQueue.main.async {
                    self.availibilitySegmentedControl.selectedSegmentIndex = 0
                    self.availibilitySegmentedControl.insertSegment(withTitle: hungarianStatus, at: 1, animated: false)
                }
                items.append(status)
            }
        }
    }
    
    private func configureUI() {
        backgroundColor = .red
        
        let logoImage = UIImage(named: "logo")!
        logoImageView.image = logoImage
        let cartImage = UIImage(named: "cart-outline")!
        cartImageView.image = cartImage
        
        addSubview(logoImageView)
        addSubview(cartImageView)
        addSubview(availibilitySegmentedControl)
        cartImageView.addSubview(cartItemNumberLabelView)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: logoImage.size.height / logoImage.size.width),
            
            availibilitySegmentedControl.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: availibilitySegmentedControl.trailingAnchor, multiplier: 2),
            availibilitySegmentedControl.topAnchor.constraint(equalToSystemSpacingBelow: logoImageView.bottomAnchor, multiplier: 2),
            availibilitySegmentedControl.heightAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 0.7),
            
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
    
    @objc private func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        var status = Status.Available
        switch sender.titleForSegment(at: sender.selectedSegmentIndex) {
        case "Elérhető":
            status = .Available
        case "Kifogyott":
            status = .Melted
        case "Nem is volt":
            status = .Unavailable
        case .none:
            break
        case .some(_):
            break
        }
        delegate?.availibilitySegmentedControlDidChange(to: status)
    }
}

extension IceCreamTableViewHeader: CartItemNumberLabelViewDelegate {
    func CartItemNumberViewIsHidden(isHidden: Bool) {
        cartItemNumberLabelView.isHidden = isHidden
    }
}
