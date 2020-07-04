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

struct CalcView: View {
    @EnvironmentObject private var userData: UserData
    
    @State var viewState: CalcViewState = .input
    @State var defender: Troop? = nil
    
    let rows = Row.all()
    let troopWidth = CGFloat(70.0)
    
    var TroopPicker: some View {
        ScrollView(.horizontal) {
            VStack {
                ForEach(rows) { row in
                    HStack(alignment: .center) {
                        ForEach(row.cells) { troop in
                            Image(troop.imageURL)
                                .resizable()
                                .frame(width: self.troopWidth, height: self.troopWidth)
//                                .clipShape(Circle())
//                                .overlay(
//                                    Circle().stroke(Color.white, lineWidth: 2))
//                                .shadow(radius: 2)
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
            }
        }
    }
    var Defender: some View {
        VStack {
            Divider()
            Text(userData.defenders.count == 0 ? "Choose Defender" : "Defender")
                .bold()
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
                Text(userData.attackers.count == 0 ? "Choose Attackers" : "Attackers")
                    .bold()
                ScrollView() {
                    ForEach(0..<userData.attackers.count, id: \.self) { i in
                        TroopView(troop: self.$userData.attackers[i])
                            .padding([.leading, .trailing])
                    }
                }
            }
        }.frame(maxHeight: .infinity)
    }
    var BestAttacks: some View {
        VStack {
            Text("Defender").bold()
            OptimalTroopView(troop: self.defender!)
            Divider()
            Text("Optimal Attack Order").bold()
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
        NavigationView {
            VStack {
                if (viewState == .input) {
                    TroopPicker
                        .padding()
                    Defender
                    Attackers
                } else if (viewState == .output) {
                    BestAttacks
                }
                if (userData.defenders.count > 0) {
                    Buttons
                }
            }
            .navigationBarTitle("Yadakkvisor")
        }
        .animation(.easeInOut)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalcView().environmentObject(UserData())
    }
}
