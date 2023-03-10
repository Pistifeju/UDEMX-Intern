//
//  IceCream.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 13..
//

import Foundation

struct IceCream: Codable, Hashable {
    let id: Int
    let name: String
    let status: Status
    let imageUrl: URL?
    
    init() {
        self.id = 0
        self.name = ""
        self.status = .Available
        self.imageUrl = nil
    }
    
    static func == (lhs: IceCream, rhs: IceCream) -> Bool {
        return lhs.id == rhs.id
    }
}

enum Status: String, Codable, Hashable {
    case Available = "available"
    case Melted = "melted"
    case Unavailable = "unavailable"
}

struct Basket: Codable {
    let price: Float
    let iceCreams: [IceCream: Int]
    let extras: [Item]
}

struct IceCreamResponse: Codable {
    let basePrice: Float
    let iceCreams: [IceCream]
}
