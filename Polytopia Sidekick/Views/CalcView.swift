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
    @EnvironmentObject private var userData: UserData
    //    @State private var userData = UserData()
    
    @State var viewState: CalcViewState = .input
    @State var defender: Troop? = nil


    let troopSize = CGFloat(70.0)

    var Defender: some View {
        //        VStack {
        //            Divider()
        //            Text(userData.defenders.count == 0 ? "Select Opponent" : "Opponent")
        //                .polyFont(size: 20)
        Group {
            ForEach(0..<userData.defenders.count, id: \.self) { i in
                TroopView(troop: self.$userData.defenders[i], isDefender: true)
                    .padding()
            }
        }
    }
    
    var Attackers: some View {
        Group {
            //            if (userData.defenders.count != 0) {
            //                Divider()
            //                Text(userData.attackers.count == 0 ? "Select Attackers" : "Attackers")
            //                    .polyFont(size: 20)
            //                ScrollView() {
            ForEach((0..<userData.attackers.count).reversed(), id: \.self) { i in
                TroopView(troop: self.$userData.attackers[i])
                    .padding([.leading, .trailing])
            }
            //                }
        }
        //        }.frame(maxHeight: .infinity)
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
    
    //    var Buttons: some View {
    //        HStack(alignment: .center, spacing: 25.0) {
    //            Button("Calculate") {
    //                let optim = Calc.calculate(defender: self.userData.defenders.first!, attackers: self.userData.attackers)
    //                print(optim)
    //                self.userData.optimalTroops = optim.sequence
    //                var defender = self.userData.defenders[0]
    //                defender.originalHP = defender.hp
    //                defender.hp = optim.defenderHealth
    //                self.defender = defender
    //                self.viewState = .output
    //            }
    //            Button("Reset") {
    //                self.userData.reset()
    //                self.viewState = .input
    //            }
    //        }
    //    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Opponent")) {

                    ForEach(userData.defenders) { defender in
                        OptimalTroopView(troop: defender)
                            .padding()
                    }
                    .onDelete { offsets in
                        self.userData.defenders.remove(atOffsets: offsets)
                    }
                    if (userData.defenders.count < 1) {
                        NavigationLink(destination: TroopPicker()) {
                            Text("Add Opponent")
                        }
                    }

                }
                Section(header: Text("Attackers")) {

                    ForEach(userData.attackers) { attacker in
                        OptimalTroopView(troop: attacker)
                            .padding()
                    }
                    .onDelete { offsets in
                        self.userData.attackers.remove(atOffsets: offsets)
                    }
                    NavigationLink(destination: TroopPicker()) {
                        Text("Add Attacker")
                    }

                }
                //                if (userData.defenders.count > 0) {
                //                    Buttons
                //                }
                //                Section(header: "Attackers") {
                //                    Attackers
                //                }
                //                Text("Polytoolpia")
                //                    .polyFont(size: 28)
                //                Divider()
                //                if (viewState == .input) {
                //                    TroopPicker
                //                    .padding()
                //                    Defender
                //                    Attackers
                //                } else if (viewState == .output) {
                //                    BestAttacks
                //                }

            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Polytoolpia")
            .navigationBarItems(trailing:
                HStack {
                    Button("Calculate") {
                        let optim = Calc.calculate(defender: self.userData.defenders.first!, attackers: self.userData.attackers)
                        print(optim)
                        self.userData.optimalTroops = optim.sequence
                        var defender = self.userData.defenders[0]
                        defender.originalHP = defender.hp
                        defender.hp = optim.defenderHealth
                        self.userData.defenders[0] = defender
                        self.userData.attackers = optim.sequence
                        self.viewState = .output
                    }
                    Button("Reset") {
                        self.userData.reset()
                        self.viewState = .input
                    }
                }
            )
        }
        .animation(.easeInOut)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalcView().environmentObject(UserData())
    }
}
