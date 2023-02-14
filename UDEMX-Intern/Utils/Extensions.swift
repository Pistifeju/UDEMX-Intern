//
//  Extensions.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 14..
//

import UIKit

extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

extension UIButton {
    func simpleSelectingAnimation() {
        UIView.animate(withDuration: 0.1) {
            self.layer.opacity = 0.8
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.layer.opacity = 1
            }
        }
    }
}
