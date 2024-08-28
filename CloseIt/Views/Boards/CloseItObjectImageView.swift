//
//  CloseItObjectImageView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 19.09.21.
//

import SwiftUI

struct CloseItObjectImageView: View {
    var control: CloseItControl
    var game: CloseItGame
    @ObservedObject var obj: CloseItObject
    var imageName: String
    var size: CGFloat
    
    var body: some View {
        if imageName != "" {
            if obj.isSelectable {
                Image(imageName).resizable()
                    .onTapGesture ( count: 2 ) {
                        if obj.isCell {
                            control.selectGameCell(game: game, obj: obj)
                        }
                    }
                    .onLongPressGesture() {
                        if obj.isCell {
                            control.selectGameCell(game: game, obj: obj)
                        }
                        else if obj.isLine {
                            control.selectGameLine(game: game, obj: obj)
                        }
                    }
            }
            else {
                Image(imageName).resizable()
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let location = value.location
                                control.selectLineNearCell(game: game, obj: obj, size: size, x: location.x, y: location.y)
                            }
                    )
            }
        }
        if control.applicationDebug {
            if #available(iOS 15.0, *) {
                let _ = Self._printChanges()
            }
        }
    }
}
