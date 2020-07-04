//
//  TroopCell.swift
//  Polytopia Sidekick
//
//  Created by Ray Sun on 6/28/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import SwiftUI

struct Row: Identifiable {
    let id = UUID()
    let cells: [Troop]
}

extension Row {
    static func all() -> [Row] {
        return [
            Row(cells: [
                Troop(imageURL: "Warrior", maxHP: 10, attack: 2, defense: 2),
                Troop(imageURL: "Rider", maxHP: 10, attack: 2, defense: 1),
                Troop(imageURL: "Giant", maxHP: 40, attack: 5, defense: 4),
                Troop(imageURL: "Defender", maxHP: 15, attack: 1, defense: 3),
            ]),
            Row(cells: [
                Troop(imageURL: "Catapult", maxHP: 15, attack: 4, defense: 0),
                Troop(imageURL: "Knight", maxHP: 15, attack: 3.5, defense: 1),
                Troop(imageURL: "Archer", maxHP: 10, attack: 2, defense: 1),
                Troop(imageURL: "Swordsman", maxHP: 15, attack: 3, defense: 3),
            ]),
            Row(cells: [
                Troop(imageURL: "Boat", maxHP: 10, attack: 1, defense: 1),
                Troop(imageURL: "Ship", maxHP: 15, attack: 2, defense: 2),
                Troop(imageURL: "Battleship", maxHP: 40, attack: 4, defense: 3),
            ])
        ]
    }
}

struct Troop: Identifiable {
    var id = UUID()
    let imageURL: String
    var maxHP: Double
    var hp: Double
    let attack: Double
    let defense: Double

    var isWalled = false
    var isDefended = false
    var isUpgraded = false
    var originalHP = 0.0    // Used later to cache the starting HP before simulation

    var scaledAttack: Double {
        attack * hp / maxHP
    }
    var scaledDefense: Double {
        defense * hp / maxHP * (isWalled ? 4.0 : isDefended ? 1.5 : 1.0)
    }

    var isUpgradable: Bool {
        return !["Giant", "Battleship"].contains(imageURL)
    }

    mutating func upgrade() {
        if (hp == maxHP) {
            hp += 5
        }
        maxHP += 5
        isUpgraded = true
    }

    init(imageURL: String, maxHP: Double, attack: Double, defense: Double) {
        self.imageURL = imageURL
        self.maxHP = maxHP
        self.attack = attack
        self.defense = defense
        self.hp = maxHP
    }

    func copy() -> Troop {
        var copy = self
        copy.id = UUID()
        return copy
    }
}
