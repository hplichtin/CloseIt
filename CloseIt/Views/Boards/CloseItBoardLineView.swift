//
//  CloseItBoardLineView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 18.09.21.
//

import SwiftUI

struct CloseItBoardLineView: View {
    var control: CloseItControl
    var design: CloseItDesign
    var game: CloseItGame
    var line: CloseItObjectArray
    var enable: Bool
    var zoom: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(line) { obj in
                CloseItObjectView(control: control, design: design, game: game, obj: obj, enable: enable, zoom: zoom)
            }
        }
    }
}
