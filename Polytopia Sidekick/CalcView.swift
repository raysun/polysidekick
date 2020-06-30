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
//    var attackerHPs: [Double]
}

struct CalcView: View {
    @EnvironmentObject private var userData: UserData
    @State var isShowingAttackers = true

    let rows = Row.all()
    let troopWidth = CGFloat(70.0)

    var body: some View {
        VStack {
            List {
                ForEach(rows, id: \.id) { row in
                    HStack(alignment: .center) {
                        ForEach(row.cells, id: \.id) { troop in
                            VStack() {
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
                }
            }.frame(height: troopWidth * 3.5, alignment: .top)
            Divider()
            Text(userData.selectedTroops.count == 0 ? "Choose Defender" : "Defender")
            if (userData.selectedTroops.count > 0) {
                TroopView(troop: userData.selectedTroops.first!, isDefender: true)
                    .padding()
                    .frame(maxHeight: troopWidth * 1.2)
            }

            if (isShowingAttackers) {
                Divider()
                Text(userData.selectedTroops.count == 1 ? "Choose Attackers" : userData.selectedTroops.count > 1 ? "Attackers" : "")
                List {
                    if (userData.selectedTroops.count > 1) {
                        ForEach(userData.selectedTroops.suffix(userData.selectedTroops.count - 1), id: \.id) { troop in
                            VStack() {
                                TroopView(troop: troop)
                            }
                        }
                    }
                }.frame(maxHeight: .infinity)
            } else {
                Divider()
                Text("Optimal Attack Order")
                List {
                    if (userData.optimalTroops.count > 0) {
                        ForEach(userData.optimalTroops, id: \.id) { troop in
                            VStack() {
                                OptimalTroopView(troop: troop)
                            }
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
                        self.isShowingAttackers = false
                    }
                    Button("Reset") {
                        self.isShowingAttackers = true
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
