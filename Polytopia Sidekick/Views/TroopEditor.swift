//
//  TroopView.swift
//  Polytopia Sidekick
//
//  Created by Karen and Ray Sun on 6/30/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Foundation
import SwiftUI

struct TroopEditor: View {
    @Binding var troop: Troop
    
    let troopWidth = CGFloat(60.0)
    var isDefender = false
    
    var body: some View {
        HStack() {
            TroopIconView(troop: troop)
            Slider(value: $troop.hp, in: 1...troop.maxHP, step: 1)
            Text(String(format: "%.0f", troop.hp))
            Image(systemName: "arrow.up.circle")
                .resizable()
                .frame(width: 22, height: 22)
                .opacity((troop.isUpgraded || !troop.isUpgradable) ? 0 : 1)
                .onTapGesture {
                    self.troop.upgrade()
            }
            if (isDefender) {
                ShieldIcon(troop: troop)
                .onTapGesture {
                    if !self.troop.isDefended {
                        self.troop.isDefended = true
                    } else if !self.troop.isWalled {
                        self.troop.isWalled = true
                    } else {
                        self.troop.isDefended = false
                        self.troop.isWalled = false
                    }
                }
            }
        }.padding()
    }
    
}
