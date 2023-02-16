//
//  BasketViewController.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 14..
//

import UIKit

protocol BasketViewControllerDataSource: AnyObject {
    var basket: [IceCream] { get set }
    var basePrice: Float { get }
}

class BasketViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var dataSource: BasketViewControllerDataSource?
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Kosár tartalma"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iceCreamsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.bounces = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(IceCreamInBasketTableViewCell.self, forCellReuseIdentifier: IceCreamInBasketTableViewCell.identifier)
        return tableView
    }()
    
    let sendOrderButton = CustomRedButton(with: "Rendelés elküldése")
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        sendOrderButton.addTarget(self, action: #selector(didTapSendOrderButton(_:)), for: .touchUpInside)
        
        iceCreamsTableView.dataSource = self
        iceCreamsTableView.delegate = self
        
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .clear
        
        createBlurEffect()
        
        view.addSubview(titleLabel)
        view.addSubview(sendOrderButton)
        view.addSubview(iceCreamsTableView)
        view.insertSubview(iceCreamsTableView, belowSubview: sendOrderButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: sendOrderButton.bottomAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: sendOrderButton.trailingAnchor, multiplier: 2),
            sendOrderButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            sendOrderButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            
            iceCreamsTableView.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2),
            iceCreamsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            iceCreamsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iceCreamsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didTapSendOrderButton(_ sender: UIButton) {
        sender.simpleSelectingAnimation()
    }
}

// MARK: - UITableViewDelegate

extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.basket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IceCreamInBasketTableViewCell.identifier, for: indexPath) as! IceCreamInBasketTableViewCell
        cell.delegate = self
        // TODO: - Fix force unwrap
        cell.configureCell(with: dataSource!.basket[indexPath.row], basePrice: dataSource!.basePrice)
        return cell
    }
}

extension BasketViewController: IceCreamInBasketTableViewCellDelegate {
    func stepperValueDidChange(with iceCream: IceCream, _ stepperValue: Int) {
        guard let dataSource = dataSource else { return }
        dataSource.basket.append(iceCream)
    }
}
