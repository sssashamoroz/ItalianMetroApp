//
//  ConnectionModel.swift
//  ItalianMetroApp
//
//  Created by Aleksandr Morozov on 27/03/24.
//

import Foundation

struct Connection: Equatable, Hashable {
    let id = UUID()
    let from: Station
    let to: Station
    let weight: Double // Can represent distance or time
}
