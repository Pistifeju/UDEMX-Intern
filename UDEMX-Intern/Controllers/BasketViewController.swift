//
//  BasketViewController.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 14..
//

import UIKit

protocol BasketViewControllerDataSource: AnyObject {
    var basket: [IceCream] { get set }
    var extras: [Extra] { get }
    var basePrice: Float { get }
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
    private var addedExtras: [ExtraType: [Item]] = [:]
    
    private let iceCreamsTableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.bounces = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
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
                
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .clear
        
        title = "Kosár tartalma"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1).bold()]
        
        createBlurEffect()
        
        guard let dataSource = dataSource, !dataSource.basket.isEmpty else {
            view.addSubview(basketIsEmptyLabel)
            basketIsEmptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            basketIsEmptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            return
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        
        scrollViewContainer.addArrangedSubview(iceCreamsTableView)
        scrollViewContainer.addArrangedSubview(extrasTitleLabel)
        scrollViewContainer.addArrangedSubview(extrasTableView)
        scrollViewContainer.addArrangedSubview(sendOrderButton)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContainer.topAnchor.constraint(equalToSystemSpacingBelow: scrollView.topAnchor, multiplier: 2),
            scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            extrasTitleLabel.centerXAnchor.constraint(equalTo: scrollViewContainer.centerXAnchor),
            sendOrderButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: sendOrderButton.trailingAnchor, multiplier: 2),
            
            iceCreamsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iceCreamsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            extrasTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            extrasTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

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
                UIView.performWithoutAnimation {
                    let sectionIndex = IndexSet(integer: 0)
                    tableView.reloadSections(sectionIndex, with: .none)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }

                addedExtras[key] = [item]
            } else {
                addedExtras[key] = (addedExtras[key] ?? []) + [item]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }
        
        if tableView == extrasTableView {
            let item = dataSource.extras[indexPath.section].items[indexPath.row]
            let key = dataSource.extras[indexPath.section].type

            if var items = addedExtras[key], let index = items.firstIndex(of: item) {
                items.remove(at: index)
                addedExtras[key] = items
            }
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
            cell.configureCell(with: dataSource.basket[indexPath.row], basePrice: dataSource.basePrice)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExtrasSlideUpTableViewCell.identifier, for: indexPath) as! ExtrasSlideUpTableViewCell
            let item = dataSource.extras[indexPath.section].items[indexPath.row]
            cell.configureCell(with: item)
            cell.selectionStyle = .none
            
            return cell
        }
    }
}
