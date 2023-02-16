//
//  ExtrasSlideUpViewController.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 15..
//


import UIKit

protocol ExtrasSlideUpViewControllerDataSource: AnyObject {
    var extras: [Extra] { get }
}

class ExtrasSlideUpViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var dataSource: ExtrasSlideUpViewControllerDataSource?
    
    private var addedExtras: [ExtraType: [Item]] = [:]
    
    private let extrasTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.separatorColor = .black
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        tableView.register(ExtrasSlideUpTableViewCell.self, forCellReuseIdentifier: ExtrasSlideUpTableViewCell.identifier)
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Extrák a fagyidhoz"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addToBasketButton = CustomRedButton(with: "Kosárba helyez")
    
    // MARK: - Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extrasTableView.delegate = self
        extrasTableView.dataSource = self
        
        addToBasketButton.addTarget(self, action: #selector(didTapAddToBasketButton), for: .touchUpInside)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false

        createBlurEffect()
        
        view.addSubview(addToBasketButton)
        view.addSubview(titleLabel)
        view.addSubview(extrasTableView)
        view.insertSubview(extrasTableView, belowSubview: titleLabel)
        view.insertSubview(extrasTableView, belowSubview: addToBasketButton)
        
        NSLayoutConstraint.activate([
            addToBasketButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: addToBasketButton.trailingAnchor, multiplier: 2),
            addToBasketButton.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: -2),
            addToBasketButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToBasketButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            extrasTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            extrasTableView.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2),
            extrasTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            extrasTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func createBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.95
        blurEffectView.frame = view.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    private func createExtrasMap() {
        
    }
    
    // MARK: - Selectors
    
    @objc private func didTapAddToBasketButton(sender: UIButton) {
        sender.simpleSelectingAnimation()
        print("-------")
        print(addedExtras)
    }
}

// MARK: - UITableViewDelegate

extension ExtrasSlideUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension ExtrasSlideUpViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.preferredFont(forTextStyle: .title3).bold()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }
        
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }

        let item = dataSource.extras[indexPath.section].items[indexPath.row]
        let key = dataSource.extras[indexPath.section].type

        if var items = addedExtras[key], let index = items.firstIndex(of: item) {
            items.remove(at: index)
            addedExtras[key] = items
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource?.extras[section].type.rawValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.extras.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.extras[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExtrasSlideUpTableViewCell.identifier, for: indexPath) as! ExtrasSlideUpTableViewCell
        let item = dataSource?.extras[indexPath.section].items[indexPath.row]
        cell.configureCell(with: item ?? Item())
        cell.selectionStyle = .none
        return cell
    }
}
