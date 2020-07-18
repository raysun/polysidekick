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
    @State var defender: Troop? = nil
    @State var selectedTroop = Troop(imageURL: "Warrior", maxHP: 10, attack: 2, defense: 2)

    var isPickingDefender: Bool {
        self.userData.defenders.count < 1
    }
    var shouldShowCalculations: Bool {
        self.userData.defenders.count > 0 && self.userData.attackers.count > 0
    }

    var body: some View {
        NavigationView {
            List {
                if userData.defenders.count > 0 {
                    Section(header: Text("Opponent")) {
                        ForEach(userData.defenders) { defender in
                            OptimalTroopView(troop: defender, isOpponent: true, shouldShowCalculations: self.shouldShowCalculations)
                                .opacity(self.shouldShowCalculations && defender.workingHP.isZero ? 0.4 : 1.0)
                                .padding()
                        }
                        .onDelete { offsets in
                            self.userData.defenders.remove(atOffsets: offsets)
                        }
                    }
                }

                if userData.attackers.count > 0 {
                    Section(header: Text("Attackers")) {
                        ForEach(userData.attackers) { attacker in
                            OptimalTroopView(troop: attacker, shouldShowCalculations: self.shouldShowCalculations)
                                .opacity(self.shouldShowCalculations && attacker.workingHP.isZero ? 0.4 : 1.0)
                                .padding()
                        }
                        .onDelete { offsets in
                            self.userData.attackers.remove(atOffsets: offsets)
                            self.userData.recalculate()
                        }
                    }
                }
            }
//            .id(UUID())
            .onAppear(perform: {
                if !self.selectedTroop.isFinishedEditing { return }
                self.selectedTroop.isFinishedEditing = false
                
                let troopCopy = self.selectedTroop.copy()
                if self.userData.defenders.count == 0 {
                    self.userData.defenders.append(troopCopy)
                } else {
                    self.userData.attackers.append(troopCopy)
                    self.userData.recalculate()
                }
            })
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Polytoolpia")
            .navigationBarItems(leading:
                Button("Reset") {
                    self.userData.reset()
                }, trailing:
                Button(action: {}) {
                    NavigationLink(destination: TroopPicker(selectedTroop: $selectedTroop, isDefender: isPickingDefender)) {
                        HStack {
                            Image(systemName: "plus")
                            Text(isPickingDefender ? "Opponent" : "Attacker")
                        }
                    }
            })
            .animation(.easeInOut)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalcView().environmentObject(UserData())
    }
}

