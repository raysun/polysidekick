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
            if (isBeforeCalculating) {

                // Troop Picker

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
                                    if self.userData.defenders.count == 0 {
                                        self.userData.defenders.append(troop.copy())
                                    } else {
                                        self.userData.attackers.append(troop.copy())
                                    }
                            }
                        }
                    }
                }
                Divider()

                // Defender

                Text(userData.defenders.count == 0 ? "Choose Defender" : "Defender")
                    .bold()
                ForEach(0..<userData.defenders.count, id: \.self) { i in
                    TroopView(troop: self.$userData.defenders[i])
                        .padding()
                }
                Divider()

                // Attackers

                Text(userData.defenders.count == 0 ? "" : userData.attackers.count == 0 ? "Choose Attackers" : "Attackers")
                    .bold()
                ScrollView() {
                        ForEach(0..<userData.attackers.count, id: \.self) { i in
                            TroopView(troop: self.$userData.attackers[i])
                                .padding()
                        }
                }.frame(maxHeight: .infinity)

            } else {

                // Optimal Attack Results

                Divider()
                Text("Defender").bold()
                OptimalTroopView(troop: self.defender!)
                    .padding()
                    .frame(maxHeight: troopWidth * 1.2)
                Divider()
                Text("Optimal Attack Order").bold()
                ScrollView() {
                    if (userData.optimalTroops.count > 0) {
                        ForEach(userData.optimalTroops) { troop in
                            OptimalTroopView(troop: troop)
                            .padding()
                        }
                    }
                }.frame(maxHeight: .infinity)
            }

            // Buttons

            if (userData.attackers.count > 0) {
                HStack(alignment: .center, spacing: 25.0) {
                    Button("Calculate") {
                        let optim = Calc.calculate(defender: self.userData.defenders.first!, attackers: self.userData.attackers)
                        print(optim)
                        self.userData.optimalTroops = optim.sequence
                        var defender = self.userData.attackers[0]
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
        CalcView().environmentObject(UserData())
    }
}
