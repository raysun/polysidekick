//
//  OptimalTroopView.swift
//  Polytopia Sidekick
//
//  Created by Karen and Ray Sun on 6/30/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Foundation
import SwiftUI

struct OptimalTroopView: View {
    let troop: Troop
    let troopWidth = CGFloat(60.0)
    var isOpponent = false

    var startingHP: String {
        String(format: "%.0f", troop.hp)
    }

    var body: some View {
        HStack() {
            TroopIconView(troop: troop)
            if isOpponent {
                Text(startingHP + " → " + String(format: "%.0f", troop.workingHP))
                ShieldIcon(troop: troop)
            } else {
                if troop.didAttack && troop.takesDamageFromOpponent {
                    Text(startingHP + " → " + String(format: "%.0f", troop.workingHP))
                } else {
                    Text(startingHP + (troop.didAttack ? " (ranged attack)" : " (did not attack)"))
                }
            }
        }
    }
}
