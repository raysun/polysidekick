//
//  TroopInShipPicker.swift
//  Polytopia Sidekick
//
//  Created by Karen and Ray Sun on 7/10/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Foundation
import SwiftUI
//
//struct TroopInShipPicker: View {
//    let troop: Troop?
//
//    var body: some View {
//        Text("Select Troop in \(self.selectedTroop.imageURL)")
//            .polyFont(size: 24)
//        List {
//            ForEach(Row.all()) { row in
//                HStack(alignment: .center) {
//                    ForEach(row.cells) { troop in
//                        if !troop.isShip {
//                            Image(troop.imageURL)
//                                .resizable()
//                                .frame(width: self.troopSize, height: self.troopSize)
//                                .onTapGesture {
//                                    self.selectedTroop.putInShip(troop)
//                                    self.isShowingPopover = false
//                                    self.isShowingTroopEditor = true
//                            }
//                        }
//                    }
//                }
//            }
//
//        }
//    }
//}
