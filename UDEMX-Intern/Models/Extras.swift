//
//  Extras.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 15..
//

import Foundation

struct Item: Codable {
    let price: Int
    let name: String
    let id: Int
}

struct Extra: Codable {
    let required: Bool?
    let type: ExtraType
    let items: [Item]
}

enum ExtraType: String, Codable {
    case Cones = "Tölcsérek"
    case Other = "Egyéb"
    case Dressings = "Öntetek"
}


