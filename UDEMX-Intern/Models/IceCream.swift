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
}

struct IceCreamResponse: Decodable {
    let basePrice: Int
    let iceCreams: [IceCream]
}

enum Status: String, Codable {
    case Available = "available"
    case Melted = "melted"
    case Unavailable = "unavailable"
}
