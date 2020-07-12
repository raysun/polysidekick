//
//  TroopPicker.swift
//  Polytopia Sidekick
//
//  Created by Karen and Ray Sun on 7/9/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Foundation
import SwiftUI

struct TroopPicker: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isShowingPopover = false
//    @State var previousShip: Troop?
    @State var selectedTroop = Troop(imageURL: "Warrior", maxHP: 10, attack: 2, defense: 2)
    var isDefender = false
    let troopSize = CGFloat(70.0)
    
    private func addTroop(withTroopInShip troopInShip: Troop? = nil) {
        var troopCopy = selectedTroop.copy()
        if let troopInShip = troopInShip {
            troopCopy.putInShip(troopInShip)
        }
        if self.userData.defenders.count == 0 {
            self.userData.defenders.append(troopCopy)
        } else {
            self.userData.attackers.append(troopCopy)

            // Calcuate optimal attacks
            let optim = Calc.calculate(defender: self.userData.defenders.first!, attackers: self.userData.attackers)
            print(optim)
            var defender = self.userData.defenders[0]
            defender.workingHP = optim.defenderHealth
            self.userData.defenders[0] = defender
            self.userData.attackers = optim.sequence
        }
        self.isShowingPopover = false
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            ForEach(Row.all()) { row in
                HStack(alignment: .center) {
                    ForEach(row.cells) { troop in
                        Image(troop.imageURL)
                            .resizable()
                            .frame(width: self.troopSize, height: self.troopSize)
                            .onTapGesture {
                                self.selectedTroop = troop
                                self.isShowingPopover = true
//                                } else {
//                                    self.selectTroop(troop)
//                                    self.selectedTroop = Troop(imageURL: "Warrior", maxHP: 10, attack: 2, defense: 2)
//                                }
                        }.sheet(isPresented: self.$isShowingPopover) {
                            TroopEditor(troop: self.$selectedTroop)
                            if self.selectedTroop.isShip {
                                Text("Select Troop in \(self.selectedTroop.imageURL)")
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
                                                            self.addTroop(withTroopInShip: troop)
//                                                            self.userData.previousShip = nil
//                                                            self.isShowingPopover = false
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                Button("Done") {
                                    self.addTroop()
//                                    self.isShowingPopover = false
                                }
                            }
                        }
                    }
                }
            }
        }.navigationBarTitle(Text(isDefender ? "Select Opponent" : "Select Attacker"))
    }
}
