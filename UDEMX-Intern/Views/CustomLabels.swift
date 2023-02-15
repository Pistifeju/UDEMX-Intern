//
//  BasePriceLabel.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 15..
//

import UIKit

class BasePriceLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .white
        text = Float(999).createFormattedBasePriceString()
        font = UIFont.preferredFont(forTextStyle: .title3).bold()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FlavorLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        textColor = UIColor(red: 249/255, green: 216/255, blue: 73/255, alpha: 1.0)
        text = "ERROR"
        font = UIFont.preferredFont(forTextStyle: .title1).bold()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

