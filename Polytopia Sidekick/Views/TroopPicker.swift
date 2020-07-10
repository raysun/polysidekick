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
    @State var previousShip: Troop?
    let troopSize = CGFloat(70.0)
    
    private func selectTroop(_ troop: Troop) {
        var troopCopy = troop
        troopCopy = troopCopy.copy(andConvertIntoShip: self.previousShip)
        if self.userData.defenders.count == 0 {
            self.userData.defenders.append(troopCopy)
        } else {
            self.userData.attackers.append(troopCopy)
            let optim = Calc.calculate(defender: self.userData.defenders.first!, attackers: self.userData.attackers)
            print(optim)
            var defender = self.userData.defenders[0]
//            defender.originalHP = defender.hp
            defender.hp = optim.defenderHealth
            self.userData.defenders[0] = defender
            self.userData.attackers = optim.sequence
        }
        
        
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
                                if (troop.isShip) {
                                    self.previousShip = troop
                                    self.isShowingPopover = true
                                } else {
                                    self.selectTroop(troop)
                                    self.previousShip = nil
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
}
