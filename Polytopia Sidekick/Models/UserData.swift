//
//  UserData.swift
//  Polytopia Sidekick
//
//  Created by Karen and Ray Sun on 6/30/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var defenders = [Troop]()
    @Published var attackers = [Troop]()
    @Published var optimalTroops = [Troop]()
    @Published var previousShip: Troop?

    func reset() {
        DispatchQueue.main.async {
            self.defenders.removeAll()
            self.attackers.removeAll()
            self.optimalTroops.removeAll()
            self.previousShip = nil
        }
    }
}
