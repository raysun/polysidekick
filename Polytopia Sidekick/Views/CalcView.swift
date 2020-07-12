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
//    let remaining: [Troop]
}

enum CalcViewState {
    case input
    case output
}

enum TroopPickerState {
    case normal
    case secondPick
}

struct PolyFont: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("PoiretOne-Regular", size: size))
    }
}
extension View {
    func polyFont(size: CGFloat) -> some View {
        return self.modifier(PolyFont(size: size))
    }
}

struct CalcView: View {
    @EnvironmentObject private var userData: UserData
    //    @State private var userData = UserData()
    @State var viewState: CalcViewState = .input
    @State var defender: Troop? = nil

    var isPickingDefender: Bool {
        self.userData.defenders.count < 1
    }

    let troopSize = CGFloat(70.0)

    var BestAttacks: some View {
        VStack {
            Text("Opponent")
                .polyFont(size: 20)
            OptimalTroopView(troop: self.defender!)
            Divider()
            Text("Optimal Attack Order")
                .polyFont(size: 20)
            ScrollView() {
                ForEach(userData.optimalTroops) { troop in
                    OptimalTroopView(troop: troop)
                }
            }.frame(maxHeight: .infinity)
        }
    }

    var body: some View {
        NavigationView {
            List {
                if userData.defenders.count > 0 {
                    Section(header: Text("Opponent")) {
                        ForEach(userData.defenders) { defender in
                            OptimalTroopView(troop: defender, isOpponent: true)
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
                            OptimalTroopView(troop: attacker)
                                .padding()
                        }
                        .onDelete { offsets in
                            self.userData.attackers.remove(atOffsets: offsets)
                            self.userData.recalculate()
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Polytoolpia")
            .navigationBarItems(leading:
                Button("Reset") {
                    self.userData.reset()
                    self.viewState = .input
                }, trailing:
                Button(action: {}) {
                    NavigationLink(destination: TroopPicker(isDefender: isPickingDefender)) {
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

