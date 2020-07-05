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
    let isShipRow = false
}

extension Row {
    static func all() -> [Row] {
        return [
            Row(cells: [
                Troop(imageURL: "Warrior", maxHP: 10, attack: 2, defense: 2),
                Troop(imageURL: "Rider", maxHP: 10, attack: 2, defense: 1),
                Troop(imageURL: "Giant", maxHP: 40, attack: 5, defense: 4),
                Troop(imageURL: "Knight", maxHP: 15, attack: 3.5, defense: 1),
                Troop(imageURL: "Catapult", maxHP: 15, attack: 4, defense: 0),
            ]),
            Row(cells: [
                Troop(imageURL: "Defender", maxHP: 15, attack: 1, defense: 3),                
                Troop(imageURL: "Archer", maxHP: 10, attack: 2, defense: 1),
                Troop(imageURL: "Swordsman", maxHP: 15, attack: 3, defense: 3),
            ]),
            Row(cells: [
                Troop(imageURL: "Boat", maxHP: 10, attack: 1, defense: 1, isShip: true),
                Troop(imageURL: "Ship", maxHP: 15, attack: 2, defense: 2, isShip: true),
                Troop(imageURL: "Battleship", maxHP: 40, attack: 4, defense: 3, isShip: true),
            ]),
            Row(cells: [
                Troop(imageURL: "Battle Sled", maxHP: 10, attack: 1, defense: 1),
                Troop(imageURL: "Ice Archer", maxHP: 15, attack: 2, defense: 2),
                Troop(imageURL: "Ice Fortress", maxHP: 40, attack: 4, defense: 3),
                Troop(imageURL: "Gaami", maxHP: 40, attack: 4, defense: 3),
            ]),
            Row(cells: [
                Troop(imageURL: "Polytaur", maxHP: 40, attack: 4, defense: 3),
                Troop(imageURL: "Baby Dragon", maxHP: 10, attack: 1, defense: 1),
                Troop(imageURL: "Fire Dragon", maxHP: 15, attack: 2, defense: 2),
                Troop(imageURL: "Navalon", maxHP: 40, attack: 4, defense: 3, isShip: true),
            ]),
            Row(cells: [
                Troop(imageURL: "Amphibian", maxHP: 10, attack: 1, defense: 1),
                Troop(imageURL: "Tridention", maxHP: 15, attack: 2, defense: 2),
                Troop(imageURL: "Crab", maxHP: 40, attack: 4, defense: 3),
            ]),
        ]
    }
}

struct Troop: Identifiable {
    var id = UUID()
    let imageURL: String
    var maxHP: Double
    var hp: Double
    var attack: Double
    var defense: Double
    var isShip = false
    
    var isWalled = false
    var isDefended = false
    var isUpgraded = false
    var originalHP = 0.0    // Used later to cache the starting HP before simulation
    var shipType = ""
    
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
    
    init(imageURL: String, maxHP: Double, attack: Double, defense: Double, isShip: Bool = false) {
        self.imageURL = imageURL
        self.maxHP = maxHP
        self.attack = attack
        self.defense = defense
        self.hp = maxHP
        self.isShip = isShip
    }
    
    mutating func inShip(ship: Troop? = nil) -> Troop {
        var copy = self
        copy.id = UUID()
        if (ship != nil) {
            copy.isShip = true
            copy.shipType = ship?.imageURL ?? ""
            switch(copy.shipType) {
            case "Boat":
                copy.attack = 1
                copy.defense = 1
            case "Ship":
                copy.attack = 2
                copy.defense = 2
            default:
                copy.attack = 4
                copy.defense = 3
            }
        }
        return copy
    }
}
