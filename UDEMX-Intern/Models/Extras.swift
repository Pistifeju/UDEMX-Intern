//
//  Extras.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 15..
//

import Foundation

struct Extra: Codable, Hashable {
    let required: Bool?
    let type: ExtraType
    let items: [Item]
    
    init() {
        self.required = nil
        self.type = .Cones
        self.items = []
    }
}

struct Item: Codable, Hashable {
    let price: Int
    let name: String
    let id: Int
    
    init() {
        self.price = 0
        self.name = ""
        self.id = 0
    }
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}

enum ExtraType: String, Codable {
    case Cones = "Tölcsérek"
    case Other = "Egyéb"
    case Dressings = "Öntetek"
}


