//
//  UserData.swift
//  Polytopia Sidekick
//
//  Created by Karen and Ray Sun on 6/30/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var defenders = [Troop]()
    @Published var attackers = [Troop]()
    @Published var optimalTroops = [Troop]()
    @Published var previousShip: Troop?

    func reset() {
        defenders.removeAll()
        attackers.removeAll()
        optimalTroops.removeAll()
        previousShip = nil
    }

    // Calculate optimal attacks
    func recalculate() {
        if !(defenders.count > 0 && attackers.count > 0) { return }

        let optim = Calc.calculate(defender: defenders.first!, attackers: attackers)
        print(optim)
        var defender = defenders[0]
        defender.workingHP = optim.defenderHealth
        defenders[0] = defender
        attackers = optim.sequence
    }
}
