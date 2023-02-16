//
//  Extras.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 15..
//

import Foundation

struct Extra: Codable {
    let required: Bool?
    let type: ExtraType
    let items: [Item]
    
    init() {
        self.required = nil
        self.type = .Cones
        self.items = []
    }
}

struct Item: Codable {
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
        // Implement the equality check for the Item type
        // For example, if Item has a property called "id", you can compare ids
        return lhs.id == rhs.id
    }
}

enum ExtraType: String, Codable {
    case Cones = "Tölcsérek"
    case Other = "Egyéb"
    case Dressings = "Öntetek"
}

