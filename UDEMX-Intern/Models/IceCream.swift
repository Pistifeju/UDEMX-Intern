//
//  IceCream.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 13..
//

import Foundation

struct IceCream: Codable {
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
}

enum Status: String, Codable {
    case Available = "available"
    case Melted = "melted"
    case Unavailable = "unavailable"
}

struct IceCreamResponse: Decodable {
    let basePrice: Float
    let iceCreams: [IceCream]
}
