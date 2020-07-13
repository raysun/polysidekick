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
                Troop(imageURL: "Knight", maxHP: 15, attack: 3.5, defense: 1),
                Troop(imageURL: "Swordsman", maxHP: 15, attack: 3, defense: 3),

            ]),
            Row(cells: [
                Troop(imageURL: "Catapult", maxHP: 15, attack: 4, defense: 0, takesDamageFromOpponent: false),
                Troop(imageURL: "Archer", maxHP: 10, attack: 2, defense: 1, takesDamageFromOpponent: false),
                Troop(imageURL: "Defender", maxHP: 15, attack: 1, defense: 3),
            ]),
            Row(cells: [
                Troop(imageURL: "Boat", maxHP: 10, attack: 1, defense: 1, isShip: true, takesDamageFromOpponent: false),
                Troop(imageURL: "Ship", maxHP: 15, attack: 2, defense: 2, isShip: true, takesDamageFromOpponent: false),
                Troop(imageURL: "Battleship", maxHP: 40, attack: 4, defense: 3, isShip: true, takesDamageFromOpponent: false),
            ]),
            Row(cells: [
                Troop(imageURL: "Battle Sled", maxHP: 15, attack: 3, defense: 2),
                Troop(imageURL: "Ice Archer", maxHP: 10, attack: 0.1, defense: 1, takesDamageFromOpponent: false),
                Troop(imageURL: "Ice Fortress", maxHP: 20, attack: 4, defense: 3, takesDamageFromOpponent: false),
                Troop(imageURL: "Gaami", maxHP: 30, attack: 4, defense: 4),
            ]),
            Row(cells: [
                Troop(imageURL: "Polytaur", maxHP: 15, attack: 3, defense: 1),
                Troop(imageURL: "Baby Dragon", maxHP: 15, attack: 3, defense: 3, takesDamageFromOpponent: false),
                Troop(imageURL: "Fire Dragon", maxHP: 20, attack: 4, defense: 3, takesDamageFromOpponent: false),
                Troop(imageURL: "Navalon", maxHP: 30, attack: 4, defense: 4),
            ]),
            Row(cells: [
                Troop(imageURL: "Amphibian", maxHP: 10, attack: 2, defense: 1),
                Troop(imageURL: "Tridention", maxHP: 15, attack: 3, defense: 1),
                Troop(imageURL: "Crab", maxHP: 40, attack: 4, defense: 4),
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
    var takesDamageFromOpponent = true

    var isWalled = false
    var isDefended = false
    var isUpgraded = false    
    var typeOfTroopInShip = ""
    var _workingHP: Double?
    var workingHP: Double {
        get {
            if let value = _workingHP {
                return value
            } else {
                return hp
            }
        }
        set {
            _workingHP = newValue
        }
    }
    var didAttack = false
    
    var scaledAttack: Double {
        attack * workingHP / maxHP
    }
    var scaledDefense: Double {
        defense * workingHP / maxHP * (isWalled ? 4.0 : isDefended ? 1.5 : 1.0)
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
    
    init(imageURL: String, maxHP: Double, attack: Double, defense: Double, isShip: Bool = false, takesDamageFromOpponent: Bool = true) {
        self.imageURL = imageURL
        self.maxHP = maxHP
        self.attack = attack
        self.defense = defense
        self.hp = maxHP
        self.isShip = isShip
        self.takesDamageFromOpponent = takesDamageFromOpponent
    }
    
    mutating func copy() -> Troop {
        var copy = self
        copy.id = UUID()
        return copy
    }

    mutating func putInShip(_ troop: Troop) {
        typeOfTroopInShip = troop.imageURL
        maxHP = troop.maxHP
        hp = troop.hp
    }
}
