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
    @Published var selectedTroops = [Troop]()
    @Published var optimalTroops = [Troop]()

    func reset() {
        selectedTroops = [Troop]()
        optimalTroops = [Troop]()
    }
}
