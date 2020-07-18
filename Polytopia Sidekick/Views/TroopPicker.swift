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
    
    @Binding var selectedTroop: Troop
    var isDefender = false

    private func addTroop() {
        self.isShowingPopover = false
        self.presentationMode.wrappedValue.dismiss()
        selectedTroop.isFinishedEditing = true
//        let troopCopy = selectedTroop.copy()
//        if self.userData.defenders.count == 0 {
//            self.userData.defenders.append(troopCopy)
//        } else {
//            self.userData.attackers.append(troopCopy)
//            self.userData.recalculate()
//        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Row.all()) { row in
                    HStack(alignment: .center) {
                        ForEach(row.cells) { troop in
                            Image(troop.imageURL)
                                .resizable()
                                .frame(width: TROOP_SIZE, height: TROOP_SIZE)
                                .onTapGesture {
                                    self.selectedTroop = troop
                                    self.isShowingPopover = true
                            }.sheet(isPresented: self.$isShowingPopover) {
                                TroopEditor(troop: self.$selectedTroop, isDefender: self.isDefender)
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
                                                            .frame(width: TROOP_SIZE, height: TROOP_SIZE)
                                                            .onTapGesture {
                                                                self.selectedTroop.putInShip(troop)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                Button("Done") {
                                    self.addTroop()
                                }
                            }
                        }
                    }
                }
            }
        }.navigationBarTitle(Text(isDefender ? "Select Opponent" : "Select Attacker"))
    }
}
