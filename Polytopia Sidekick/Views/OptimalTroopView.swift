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
    var shouldShowCalculations = false

    var startingHP: String {
        String(format: "%.0f", troop.hp)
    }
    var endingHP: String {
        troop.workingHP.isZero ? "❌" : String(format: "%.0f", troop.workingHP)
    }

    var body: some View {
        HStack() {
            TroopIconView(troop: troop)
            if isOpponent {
                Text(startingHP + (shouldShowCalculations ? " → " + endingHP : ""))
                ShieldIcon(troop: troop)
            } else {
                if troop.didAttack && troop.takesDamageFromOpponent {
                    Text(startingHP + (shouldShowCalculations ? " → " + endingHP : ""))
                } else {
                    Text(startingHP + (shouldShowCalculations ? troop.didAttack ? " (ranged attack)" : " (did not attack)" : ""))
                }
            }
        }
    }
}
