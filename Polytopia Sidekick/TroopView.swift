//
//  TroopView.swift
//  Polytopia Sidekick
//
//  Created by Karen and Ray Sun on 6/30/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Foundation
import SwiftUI

struct TroopView: View {
    @EnvironmentObject private var userData: UserData

    let troop: Troop
    var troopIndex: Int { userData.selectedTroops.firstIndex(where: { $0.id == troop.id }) ?? -1 }

    let troopWidth = CGFloat(60.0)
    var isDefender = false

    var body: some View {
        HStack() {
            if (troopIndex != -1) {
                Image(troop.imageURL)
                    .resizable()
                    .frame(width: self.troopWidth, height: self.troopWidth)
                Slider(value: $userData.selectedTroops[troopIndex].hp, in: 0...userData.selectedTroops[troopIndex].maxHP)
                Text(String(format: "%.0f", userData.selectedTroops[troopIndex].hp))
                Image(systemName: "arrow.up.circle")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .opacity(userData.selectedTroops[self.troopIndex].isUpgraded || troop.imageURL == "Giant" ? 0 : 1)
                    .onTapGesture {
                        self.userData.selectedTroops[self.troopIndex].hp += 5
                        self.userData.selectedTroops[self.troopIndex].maxHP += 5
                        self.userData.selectedTroops[self.troopIndex].isUpgraded = true
                }
                if (isDefender) {
                    ZStack {
                        Image(systemName: self.userData.selectedTroops[self.troopIndex].isDefended ? "shield" : "shield.slash")
                            .resizable()
                            .opacity(self.userData.selectedTroops[self.troopIndex].isDefended ? 1.0 : 0.5)
                            .frame(width: 22, height: 22)
                        if (self.userData.selectedTroops[self.troopIndex].isWalled) {
                            Image(systemName: self.userData.selectedTroops[self.troopIndex].isWalled ? "shield" : "")
                            .resizable()
                            .frame(width: 30, height: 30)
                        }

                    }
                    .onTapGesture {
                        if !self.userData.selectedTroops[self.troopIndex].isDefended {
                            self.userData.selectedTroops[self.troopIndex].isDefended = true
                        } else if !self.userData.selectedTroops[self.troopIndex].isWalled {
                            self.userData.selectedTroops[self.troopIndex].isWalled = true
                        } else {
                            self.userData.selectedTroops[self.troopIndex].isDefended = false
                            self.userData.selectedTroops[self.troopIndex].isWalled = false
                        }
                    }
                }
            }
        }
    }
}
