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
    var troopInShipSize: CGFloat {
        TROOP_SIZE / 2.0
    }
    
    var body: some View {
        HStack {
            Image(troop.imageURL)
                .resizable()
                .frame(width: TROOP_SIZE, height: TROOP_SIZE)
            if troop.typeOfTroopInShip != "" {
                Image(troop.typeOfTroopInShip)
                    .resizable()
                    .frame(width: troopInShipSize, height: troopInShipSize)
            }
        }
    }
}
