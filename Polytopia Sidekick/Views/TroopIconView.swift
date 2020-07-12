//
//  TroopIconView.swift
//  Polytopia Sidekick
//
//  Created by Ray Sun on 7/5/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Foundation
import SwiftUI

struct TroopIconView: View {
    let troop: Troop
    let troopSize = CGFloat(60.0)
    var troopInShipSize: CGFloat {
        troopSize / 2.0
    }
    
    var body: some View {
        HStack {
            Image(troop.imageURL)
                .resizable()
                .frame(width: troopSize, height: troopSize)
            if troop.typeOfTroopInShip != "" {
                Image(troop.typeOfTroopInShip)
                    .resizable()
                    .frame(width: troopInShipSize, height: troopInShipSize)
            }
        }
    }
}
