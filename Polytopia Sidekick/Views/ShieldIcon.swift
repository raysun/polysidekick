//
//  ShieldIcon.swift
//  Polytopia Sidekick
//
//  Created by Karen and Ray Sun on 7/12/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Foundation
import SwiftUI

struct ShieldIcon: View {
    let troop: Troop
    var showHPInsideShield = false

    var body: some View {
        HStack {
            ZStack {
                Image(systemName: self.troop.isDefended ? "shield" : "shield.slash")
                    .resizable( )
                    .opacity(self.troop.isDefended ? 1.0 : 0.5)
                    .frame(width: 22, height: 22)
                if (self.troop.isWalled) {
                    Image(systemName: "shield")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
//                if showHPInsideShield {
//                    Text(String(format: "%.0f", troop.hp))
//                }
            }
//            if !showHPInsideShield {
//                Text(String(format: "%.0f", troop.hp))
//            }
        }
    }
}
