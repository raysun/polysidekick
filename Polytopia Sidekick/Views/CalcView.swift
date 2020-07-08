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
    @ObservedObject private var userData: UserData = userDataStore
    
    @State var viewState: CalcViewState = .input
    @State var defender: Troop? = nil
    @State var isShowingPopover = false

    let troopSize = CGFloat(70.0)

    private func selectTroop(_ troop: Troop) {
        var troopCopy = troop
        troopCopy = troopCopy.copy(andConvertIntoShip: self.userData.previousShip)
        if self.userData.defenders.count == 0 {
            self.userData.defenders.append(troopCopy)
        } else {
            self.userData.attackers.append(troopCopy)
        }
    }

    var TroopPicker: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(Row.all()) { row in
                    HStack(alignment: .center) {
                        ForEach(row.cells) { troop in
                            Image(troop.imageURL)
                                .resizable()
                                .frame(width: self.troopSize, height: self.troopSize)
                                .onTapGesture {
                                    if (troop.isShip) {
                                        self.userData.previousShip = troop
                                        self.isShowingPopover = true
                                    } else {
                                        self.selectTroop(troop)
                                        self.userData.previousShip = nil
                                    }
                            }.sheet(isPresented: self.$isShowingPopover) {
                                Text("Select Troop in \(self.userData.previousShip?.imageURL ?? "")")
                                    .polyFont(size: 24)
                                VStack {
                                    ForEach(Row.all()) { row in
                                        HStack(alignment: .center) {
                                            ForEach(row.cells) { troop in
                                                if !troop.isShip {
                                                    Image(troop.imageURL)
                                                        .resizable()
                                                        .frame(width: self.troopSize, height: self.troopSize)
                                                        .onTapGesture {
                                                            self.selectTroop(troop)
                                                            self.userData.previousShip = nil
                                                            self.isShowingPopover = false
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(maxHeight: troopSize * 3.5)
    }
    
    var Defender: some View {
        VStack {
            Divider()
            Text(userData.defenders.count == 0 ? "Select Opponent" : "Opponent")
                .polyFont(size: 20)
            ForEach(0..<userData.defenders.count, id: \.self) { i in
                TroopView(troop: self.$userData.defenders[i], isDefender: true)
                    .padding()
            }
        }
    }
    
    var Attackers: some View {
        VStack {
            if (userData.defenders.count != 0) {
                Divider()
                Text(userData.attackers.count == 0 ? "Select Attackers" : "Attackers")
                    .polyFont(size: 20)
                ScrollView() {
                    ForEach((0..<userData.attackers.count).reversed(), id: \.self) { i in
                        TroopView(troop: self.$userData.attackers[i])
                            .padding([.leading, .trailing])
                    }
                }
            }
        }.frame(maxHeight: .infinity)
    }
    
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
    
    var Buttons: some View {
        HStack(alignment: .center, spacing: 25.0) {
            Button("Calculate") {
                let optim = Calc.calculate(defender: self.userData.defenders.first!, attackers: self.userData.attackers)
                print(optim)
                self.userData.optimalTroops = optim.sequence
                var defender = self.userData.defenders[0]
                defender.originalHP = defender.hp
                defender.hp = optim.defenderHealth
                self.defender = defender
                self.viewState = .output
            }
            Button("Reset") {
                self.userData.reset()
                self.viewState = .input
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Polytopia Sidekick")
                .polyFont(size: 28)
            Divider()
            if (viewState == .input) {
                TroopPicker
                //                    .padding()
                Defender
                Attackers
            } else if (viewState == .output) {
                BestAttacks
            }
            if (userData.defenders.count > 0) {
                Buttons
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
