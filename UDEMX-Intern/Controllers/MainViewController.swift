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
    private let extrasSlideUpView = ExtrasSlideUpView()
    private weak var heightAnchorForExtrasSlideUpView: NSLayoutConstraint!
    
    internal var basket: [IceCream] = []
    private var iceCreams: IceCreamResponse?
    private var extras: [Extra]?
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
        
        header.delegate = self
        iceCreamsTableView.delegate = self
        iceCreamsTableView.dataSource = self
        
        heightAnchorForExtrasSlideUpView = extrasSlideUpView.heightAnchor.constraint(equalToConstant: 0)
        containerViewForExtrasView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapContainerView)))
        
        configureUI()
        fetchIceCreams()
        fetchExtras()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .red
        
        view.addSubview(iceCreamsTableView)
        containerViewForExtrasView.alpha = 0
        containerViewForExtrasView.backgroundColor = .black.withAlphaComponent(0.9)
        containerViewForExtrasView.frame = self.view.frame
        view.addSubview(containerViewForExtrasView)
        view.addSubview(extrasSlideUpView)
        
        heightAnchorForExtrasSlideUpView = extrasSlideUpView.heightAnchor.constraint(equalToConstant: 0)
        heightAnchorForExtrasSlideUpView.isActive = true
        
        NSLayoutConstraint.activate([
            iceCreamsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            iceCreamsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            iceCreamsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iceCreamsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            extrasSlideUpView.leadingAnchor.constraint(equalTo: containerViewForExtrasView.leadingAnchor),
            extrasSlideUpView.trailingAnchor.constraint(equalTo: containerViewForExtrasView.trailingAnchor),
            extrasSlideUpView.bottomAnchor.constraint(equalTo: containerViewForExtrasView.bottomAnchor),
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
    
    private func animateExtrasSlideUpView(animateIn: Bool) {
        heightAnchorForExtrasSlideUpView.constant = animateIn ? extrasSlideUpView.intrinsicContentSize.height : 0
        
        UIView.animate(withDuration: 0.5,
                         delay: 0, usingSpringWithDamping: 1.0,
                         initialSpringVelocity: 1.0,
                         options: .curveEaseInOut, animations: {
            self.containerViewForExtrasView.alpha = animateIn ? 0.8 : 0
            self.extrasSlideUpView.alpha = animateIn ? 1 : 0
            self.view.layoutIfNeeded()
          }, completion: nil)
    }
        
    // MARK: - Selectors
    
    @objc private func didTapContainerView() {
        animateExtrasSlideUpView(animateIn: false)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: IceCreamTableViewCell.identifier, for: indexPath) as! IceCreamTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.delegate = self
        // TODO: - Fix force unwrap
        cell.configureCell(with: self.iceCreams!.iceCreams[indexPath.row], basePrice: self.iceCreams!.basePrice)
        return cell
    }
}

// MARK: - IceCreamTableViewCellDelegate

extension MainViewController: IceCreamTableViewCellDelegate {
    func didTapAddToBasketButton(with iceCream: IceCream) {
        animateExtrasSlideUpView(animateIn: true)
        basket.append(iceCream)
    }
}

// MARK: - IceCreamTableViewHeaderDelegate

extension MainViewController: IceCreamTableViewHeaderDelegate {
    func didTapBasketButton() {
        let vc = BasketViewController()
        vc.dataSource = self
        present(vc, animated: true)
    }
}

// MARK: - BasketViewControllerDataSource

extension MainViewController: BasketViewControllerDataSource {
    var basePrice: Float {
        guard let iceCreams = iceCreams else { return 0 }
        return iceCreams.basePrice
    }
}
