//
//  StationModel.swift
//  ItalianMetroApp
//
//  Created by Aleksandr Morozov on 27/03/24.
//

import Foundation
import SwiftUI

struct Station: Identifiable, Equatable, Hashable {
    let id: UUID
    let name: String
    let xCoordinate: Double
    let yCoordinate: Double
    let lines: [String]
    let titleOrientation: String
    let titleShown: Bool
    let accentColor: Color

    init(id: UUID = UUID(), name: String, xCoordinate: Double, yCoordinate: Double, lines: [String], titleOrientation: String, titleShown: Bool = true, accentColor: Color = .gray) {
        self.id = id
        self.name = name
        self.xCoordinate = xCoordinate
        self.yCoordinate = yCoordinate
        self.lines = lines
        self.titleOrientation = titleOrientation
        self.titleShown = titleShown
        self.accentColor = accentColor
    }
    
    static func == (lhs: Station, rhs: Station) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
