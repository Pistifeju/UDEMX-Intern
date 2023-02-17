//
//  BasketViewController.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 14..
//

import UIKit

protocol BasketViewControllerDataSource: AnyObject {
    var basket: [IceCream: Int] { get set }
    var extras: [Extra] { get }
    var basePrice: Float { get }
    var addedExtras: [ExtraType: [Item]] { get set }
}

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class BasketViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var dataSource: BasketViewControllerDataSource?
    
    private let iceCreamsTableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.bounces = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.register(IceCreamInBasketTableViewCell.self, forCellReuseIdentifier: IceCreamInBasketTableViewCell.identifier)
        return tableView
    }()
    
    private let extrasTableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.separatorColor = .black
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(ExtrasSlideUpTableViewCell.self, forCellReuseIdentifier: ExtrasSlideUpTableViewCell.identifier)
        return tableView
    }()
    
    private let basketIsEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Üres a kosarad"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let extrasTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Extrák a fagyidhoz"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scv = UIScrollView()
        scv.backgroundColor = .clear
        scv.showsVerticalScrollIndicator = false
        scv.showsHorizontalScrollIndicator = false
        scv.translatesAutoresizingMaskIntoConstraints = false
        return scv
    }()
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sendOrderButton = CustomRedButton(with: "Rendelés elküldése")
    let hiddenButtonForHeight = CustomRedButton(with: "Rendelés elküldése")
    
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
        extrasTableView.dataSource = self
        extrasTableView.delegate = self
                
        setSendOrderButtonLabel()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .clear
        
        hiddenButtonForHeight.layer.opacity = 0
        
        title = "Kosár tartalma"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1).bold()]
        
        createBlurEffect()
        
        showStackViewIfBasketIsNotEmpty()
        
        view.addSubview(basketIsEmptyLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        
        scrollViewContainer.addArrangedSubview(iceCreamsTableView)
        scrollViewContainer.addArrangedSubview(extrasTitleLabel)
        scrollViewContainer.addArrangedSubview(extrasTableView)
        scrollViewContainer.addArrangedSubview(hiddenButtonForHeight)
        scrollView.addSubview(sendOrderButton)
        
        NSLayoutConstraint.activate([
            basketIsEmptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            basketIsEmptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContainer.topAnchor.constraint(equalToSystemSpacingBelow: scrollView.topAnchor, multiplier: 2),
            scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            iceCreamsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iceCreamsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            extrasTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            extrasTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sendOrderButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            sendOrderButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: sendOrderButton.trailingAnchor, multiplier: 2),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: sendOrderButton.bottomAnchor, multiplier: 2),
        ])
    }
    
    private func showStackViewIfBasketIsNotEmpty() {
        guard let dataSource = dataSource, !dataSource.basket.isEmpty else {
            basketIsEmptyLabel.isHidden = false
            scrollView.isHidden = true
            return
        }
        basketIsEmptyLabel.isHidden = true
        scrollView.isHidden = false
    }
    
    private func calculateCurrentPrice() -> Float {
        guard let dataSource = dataSource else { return 0 }
        var price: Float = 0
        
        for iceCream in dataSource.basket {
            price += Float(iceCream.value) * dataSource.basePrice
        }
        
        for extra in dataSource.addedExtras {
            for item in extra.value {
                price += Float(item.price) / 10
            }
        }
        
        return price
    }
    
    private func setSendOrderButtonLabel() {
        let price = calculateCurrentPrice()
        sendOrderButton.setTitle("Rendelés leadás \(price.createFormattedBasePriceString())", for: .normal)
    }
    
    // MARK: - Selectors
    
    @objc private func didTapSendOrderButton(_ sender: UIButton) {
        sender.simpleSelectingAnimation()
        guard let dataSource = dataSource else {
            return
        }
        
        let extras = dataSource.addedExtras
        
        if let cones = extras[.Cones], cones.isEmpty {
            AlertManager.showOnlyDismissAlert(on: self, with: "Hiányzó tölcsér", and: "Kérlek válassz egy tölcsért")
            return
        }

        if !extras.keys.contains(.Cones) {
            AlertManager.showOnlyDismissAlert(on: self, with: "Hiányzó tölcsér", and: "Kérlek válassz egy tölcsért")
        }
    }
}

// MARK: - UITableViewDelegate

extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == iceCreamsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: IceCreamInBasketTableViewCell.identifier) as! IceCreamInBasketTableViewCell
            return cell.intrinsicContentSize.height
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let text = UILabel()
        text.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        text.text = "PLACEHOLDER"
        text.sizeToFit()
        return text.frame.height + 16
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        header.textLabel?.font = UIFont.preferredFont(forTextStyle: .title3).bold()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }
        
        if tableView == extrasTableView {
            let item = dataSource.extras[indexPath.section].items[indexPath.row]
            let key = dataSource.extras[indexPath.section].type

            if indexPath.section == 0 {
                dataSource.addedExtras[key] = [item]
                
                UIView.performWithoutAnimation {
                    let sectionIndex = IndexSet(integer: 0)
                    tableView.reloadSections(sectionIndex, with: .none)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            } else {
                dataSource.addedExtras[key] = (dataSource.addedExtras[key] ?? []) + [item]
            }
            
            setSendOrderButtonLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }
        
        if tableView == extrasTableView {
            let item = dataSource.extras[indexPath.section].items[indexPath.row]
            let key = dataSource.extras[indexPath.section].type

            if var items = dataSource.addedExtras[key], let index = items.firstIndex(of: item) {
                items.remove(at: index)
                dataSource.addedExtras[key] = items
            }
            
            setSendOrderButtonLabel()
        }
    }
}

// MARK: - UITableViewDataSource

extension BasketViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let dataSource = dataSource else { return nil }
        if tableView == extrasTableView {
            return dataSource.extras[section].type.rawValue
        } else {
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataSource = dataSource else { return 0 }
        
        if tableView == extrasTableView {
            return dataSource.extras.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        
        if tableView == iceCreamsTableView {
            return dataSource.basket.count
        } else {
            return dataSource.extras[section].items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = dataSource else {
            return UITableViewCell.init()
        }
        
        if tableView == iceCreamsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: IceCreamInBasketTableViewCell.identifier, for: indexPath) as! IceCreamInBasketTableViewCell
            
            var iceCreamsInBasket: [IceCream] = []
            
            for basket in dataSource.basket {
                iceCreamsInBasket.append(basket.key)
            }
            
            let iceCream = iceCreamsInBasket[indexPath.row]
            
            cell.configureCell(with: iceCream, iceCreamCount: dataSource.basket[iceCream]!, basePrice: dataSource.basePrice)
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExtrasSlideUpTableViewCell.identifier, for: indexPath) as! ExtrasSlideUpTableViewCell
            
            let cellItem = dataSource.extras[indexPath.section].items[indexPath.row]
            
            for items in dataSource.addedExtras.values {
                for item in items {
                    if cellItem == item {
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    }
                }
            }
            
            cell.configureCell(with: cellItem)
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

// MARK: - IceCreamInBasketTableViewCellDelegate

extension BasketViewController: IceCreamInBasketTableViewCellDelegate {
    func userDidChangeStepperValue(on iceCream: IceCream, toValue: Int) {
        guard let dataSource = dataSource else { return }
        
        if toValue == 0 {
            dataSource.basket[iceCream] = nil
        } else {
            dataSource.basket[iceCream] = toValue
        }
        
        setSendOrderButtonLabel()
        iceCreamsTableView.reloadData()
        showStackViewIfBasketIsNotEmpty()
    }
}
