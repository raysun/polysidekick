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

    var body: some View {
        HStack() {
            TroopIconView(troop: troop)
            Text(String(format: "%.0f", troop.hp) + " → " + String(format: "%.0f", troop.workingHP))
        }
    }
}
