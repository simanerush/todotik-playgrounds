//
//  FontAshot.swift
//  Todotik
//
//  Created by Serafima Nerush on 2/18/22.
//

import SwiftUI

struct FontAshot {
    static func commonFont(fontSize: CGFloat) -> Font {
        return Font.custom("FiraCode-Regular", size: fontSize)
    }
    
    static func titleFont(fontSize: CGFloat) -> Font {
        return Font.custom("FiraCode-Bold", size: fontSize, relativeTo: .title)
    }
}

