//
//  CloseITObjectView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 17.09.21.
//

import SwiftUI

struct CloseItObjectView: View {
    var control: CloseItControl
    var design: CloseItDesign
    var game: CloseItGame
    @ObservedObject var obj: CloseItObject
    var enable: Bool
    var zoom: CGFloat
    
    var width: CGFloat {
        var w: Float
        
        if obj.isCell {
            w = Float(design.data.size)
        }
        else if obj.isLineX {
            w = Float(design.data.size + design.data.width)
            if obj.x == 0 || obj.x == game.board.sizeX - 1 {
                w += Float(design.data.width) / 2
            }
        }
        else {
            w = Float(design.data.width)
        }
        return CGFloat(w) * zoom
    }
    
    var height: CGFloat {
        var h: Int
        
        if obj.isCell || obj.isLineY {
            h = design.data.size
        }
        else {
            h = design.data.width
        }
        return CGFloat(h) * zoom
    }
  
    var body: some View {
        let w = width
        let h = height
        
        Button(action: {
            if obj.isLine {
                control.selectGameLine(game: game, obj: obj)
            }
        }) {
            CloseItObjectImageView(control: control, game: game, obj: obj, imageName: obj.getImageName(design: design), size: w)
        }
        .frame(width: w, height: h, alignment: .leading)
        .disabled(!enable || obj.isOut || obj.isLine && !obj.isSelectable || game.isFinished || game.mode == .isReview || game.mode == .inDemo)
        if control.applicationDebug {
            if #available(iOS 15.0, *) {
                let _ = Self._printChanges()
            }
        }
    }
}
