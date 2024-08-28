//
//  CloseItColor.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 16.12.21.
//

import Foundation
import SwiftUI

func CloseItColor (_ name: String) -> Color {
    switch name {
    case "black": return Color.black
    case "blue": return Color.blue
    case "gray": return Color.gray
    case "white": return Color.white
    default:
        myMessage.warning("unexpected color:\(name)")
        return Color.black
    }
}
