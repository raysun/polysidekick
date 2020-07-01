//
//  CalcView.swift
//  Polytopia Sidekick
//
//  Created by Ray Sun on 6/28/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import SwiftUI

struct OptimizationValue {
    var defenderHealth: Double
    var sequence: [Troop]
}

struct CalcView: View {
    @EnvironmentObject private var userData: UserData
    @State var isBeforeCalculating = true
    @State var defender: Troop? = nil

    let rows = Row.all()
    let troopWidth = CGFloat(70.0)

    var body: some View {
        VStack {
            ForEach(rows) { row in
                HStack(alignment: .center) {
                    ForEach(row.cells) { troop in
                        Image(troop.imageURL)
                            .resizable()
                            .frame(width: self.troopWidth, height: self.troopWidth)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 2)
                            .onTapGesture {
                                self.userData.selectedTroops.append(troop.copy())
                        }
                    }
                }
            }

            if (isBeforeCalculating) {
                Divider()
                Text(userData.selectedTroops.count == 0 ? "Choose Defender" : "Defender")
                if (userData.selectedTroops.count > 0) {
                    TroopView(troop: userData.selectedTroops.first!, isDefender: true)
                        .padding()
                        .frame(maxHeight: troopWidth * 1.2)
                }
                Divider()
                Text(userData.selectedTroops.count == 1 ? "Choose Attackers" : userData.selectedTroops.count > 1 ? "Attackers" : "")
                ScrollView() {
                    if (userData.selectedTroops.count > 1) {
                        ForEach(userData.selectedTroops.suffix(userData.selectedTroops.count - 1)) { troop in
                            TroopView(troop: troop)
                                .padding()
                        }
                    }
                }.frame(maxHeight: .infinity)
            } else {
                Divider()
                Text("Defender")
                OptimalTroopView(troop: defender!)
                    .padding()
                    .frame(maxHeight: troopWidth * 1.2)
                Divider()
                Text("Optimal Attack Order")
                ScrollView() {
                    if (userData.optimalTroops.count > 0) {
                        ForEach(userData.optimalTroops) { troop in
                            OptimalTroopView(troop: troop)
                            .padding()
                        }
                    }
                }.frame(maxHeight: .infinity)
            }
            if (userData.selectedTroops.count > 0) {
                HStack(alignment: .center, spacing: 25.0) {
                    Button("Calculate") {
                        let optim = Calc.calculate(troops: self.userData.selectedTroops)
                        print(optim)
                        self.userData.optimalTroops = optim.sequence
                        var defender = self.userData.selectedTroops[0]
                        defender.originalHP = defender.hp
                        defender.hp = optim.defenderHealth
                        self.defender = defender
                        self.isBeforeCalculating = false
                    }
                    Button("Reset") {
                        self.isBeforeCalculating = true
                        self.userData.reset()
                    }
                }
            }
        }
        .animation(.easeInOut)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalcView()
    }
}
