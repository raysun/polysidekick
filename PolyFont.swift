//
//  PolyFont.swift
//  Polytopia Sidekick
//
//  Created by Karen and Ray Sun on 7/12/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Foundation
import SwiftUI

struct PolyFont: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("PoiretOne-Regular", size: size))
    }
}
extension View {
    func polyFont(size: CGFloat) -> some View {
        return self.modifier(PolyFont(size: size))
    }
}
