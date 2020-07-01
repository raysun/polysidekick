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
            Image(troop.imageURL)
                .resizable()
                .frame(width: self.troopWidth, height: self.troopWidth)
            Text(String(format: "%.0f", troop.originalHP) + " → " + String(format: "%.0f", troop.hp))
        }
    }
}
