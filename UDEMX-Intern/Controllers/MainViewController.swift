//
//  MainViewController.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 13..
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var containerViewForExtrasView = UIView()
    private weak var heightAnchorForExtrasSlideUpView: NSLayoutConstraint!
    
    internal var basket: [IceCream: Int] = [:]
    internal var extras: [Extra] = []
    internal var addedExtras: [ExtraType: [Item]] = [:]
    
    private var iceCreams: IceCreamResponse?
    private let header = IceCreamTableViewHeader()
    
    private let iceCreamsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .red
        tableView.clipsToBounds = true
        tableView.bounces = false
        tableView.register(IceCreamTableViewCell.self, forCellReuseIdentifier: IceCreamTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        basket = loadDataFromUserDefaults(forKey: "basket", defaultValue: [IceCream: Int]())
        addedExtras = loadDataFromUserDefaults(forKey: "addedExtras", defaultValue: [ExtraType: [Item]]())
        
        header.delegate = self
        iceCreamsTableView.delegate = self
        iceCreamsTableView.dataSource = self
        
        configureUI()
        fetchIceCreams()
        fetchExtras()
    }
    
    // MARK: - Helpers
    
    func loadDataFromUserDefaults<T: Codable>(forKey key: String, defaultValue: T) -> T {
        let defaults = UserDefaults.standard
        guard let encodedData = defaults.data(forKey: key),
              let decodedValue = try? JSONDecoder().decode(T.self, from: encodedData) else {
            return defaultValue
        }
        return decodedValue
    }
    
    func saveDataToUserDefaults<T: Codable>(forKey key: String, array: T) {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(array) {
            defaults.set(encodedData, forKey: key)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .red
        
        view.addSubview(iceCreamsTableView)
        
        NSLayoutConstraint.activate([
            iceCreamsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            iceCreamsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            iceCreamsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iceCreamsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        view.layoutIfNeeded()
    }
    
    private func fetchIceCreams() {
        NetworkCaller.shared.getIceCreams { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let iceCreams):
                strongSelf.iceCreams = iceCreams
                DispatchQueue.main.async {
                    strongSelf.iceCreamsTableView.reloadData()
                }
            case .failure(let error):
                // TODO: - Show Error Alert
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchExtras() {
        NetworkCaller.shared.getExtras { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let extras):
                strongSelf.extras = extras
            case .failure(let error):
                // TODO: - Show Error Alert
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc private func applicationWillResignActive(_ notification: Notification) {
        saveDataToUserDefaults(forKey: "basket", array: basket)
        saveDataToUserDefaults(forKey: "addedExtras", array: addedExtras)
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        header.intrinsicContentSize.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 3
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iceCreams?.iceCreams.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let iceCreamsResponse = iceCreams else {
            return UITableViewCell.init()
        }
        let iceCream = iceCreamsResponse.iceCreams[indexPath.row]
        let basePrice = iceCreamsResponse.basePrice
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IceCreamTableViewCell.identifier, for: indexPath) as! IceCreamTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configureCell(with: iceCream, basePrice: basePrice)
        return cell
    }
}

// MARK: - IceCreamTableViewCellDelegate

extension MainViewController: IceCreamTableViewCellDelegate {
    func didTapAddToBasketButton(with iceCream: IceCream) {
        if !basket.contains(where: { $0.key == iceCream }) {
            basket[iceCream] = 1
        } else {
            basket[iceCream]! += 1
        }
    }
}

// MARK: - IceCreamTableViewHeaderDelegate

extension MainViewController: IceCreamTableViewHeaderDelegate {
    func didTapBasketButton() {
        let vc = BasketViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.dataSource = self
        present(nav, animated: true)
    }
}

// MARK: - BasketViewControllerDataSource

extension MainViewController: BasketViewControllerDataSource {
    var basePrice: Float {
        guard let iceCreams = iceCreams else { return 0 }
        return iceCreams.basePrice
    }
}
