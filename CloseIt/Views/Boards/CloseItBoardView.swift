//
//  CloseItBoardView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 17.09.21.
//

import SwiftUI

struct CloseItHelpTextView: View {
    @ObservedObject var game: CloseItGame
    var showHelpAlways: Bool
    @State var showHelp: Bool

    var body: some View {
        let helpText = game.helpText
        if helpText != "" && (showHelpAlways || showHelp) {
            HStack(alignment: .top) {
                Image(systemName: CloseItControl.UserInterface.helpHideSystemImageName)
                Divider()
                if game.mode == .inDemo && game.steps.count != 0 {
                    Text("\(game.stepsIndex + 1) / \(game.steps.count + 1)")
                    Divider()
                }
                if #available(iOS 15.0, *) {
                    Text(helpText).textSelection(.enabled)
                } else {
                    Text(helpText)
                }
            }
        }
    }
}

struct CloseItBoardView: View {
    var control: CloseItControl
    var design: CloseItDesign
    var game: CloseItGame
    @State var maxSize: CGSize = CGSize()
    var resize: Bool
    @Binding var controlZoom: Double
    @Binding var shapeSize: Bool
    var enable: Bool
    var showHelpAlways: Bool
    @State var showHelp: Bool = false
    @Binding var controlDebug: Bool

    func getZoom () -> CGFloat {
        if (resize || shapeSize) && maxSize.width != 0 && maxSize.height != 0 {
            let widthPercent = CloseIt.isPhone ? 0.8 : 0.95
            let heightPercent = 0.8
            let sizeX = CGFloat(game.board.sizeX)
            let sizeY = CGFloat(game.board.sizeY)
            let size = CGFloat(design.data.size)
            let width = CGFloat(design.data.width)
            let widthZoom: CGFloat = maxSize.width  * widthPercent / (sizeX * size + (sizeX + 1) * width)
            let heightZoom: CGFloat = maxSize.height * heightPercent / (sizeY * size + (sizeY + 1) * width)
            
            return min(widthZoom, heightZoom)
        }
        else {
            return CGFloat(controlZoom)
        }
    }
    
    var body: some View {
        CloseItHelpTextView(game: game, showHelpAlways: showHelpAlways, showHelp: showHelp)
        ScrollView(.horizontal, showsIndicators: true) {
            let zoom = getZoom()
            
            VStack(spacing: 0) {
                ForEach(game.board.getBoardView()) { line in
                    CloseItBoardLineView(control: control, design: design, game: game, line: line, enable: enable, zoom: zoom)
                }
            }
            .toolbar {
                if enable {
                    HStack {
                        let helpText = game.helpText

                        ForEach(CloseItToolbarObject.allCases, id: \.self) { obj in
                            CloseItToolbarGameButtonView(obj: obj, game: game, shapeSize: $shapeSize)
                        }
                        if helpText != "" && game.mode != .inDemo && game.mode != .isReview {
                            Button(action: { showHelp.toggle() }) {
                                Label("Help", systemImage: CloseItControl.getHelpImageName(help: showHelp))
                            }
                        }
                    }
                }
            }
            if controlDebug {
                CloseItDebugTextView()
                if #available(iOS 15.0, *) {
                    let _ = Self._printChanges()
                }
                Text("controlZoom: \(controlZoom)")
                Text("maxSize: \(maxSize)")
                Text("zoom: \(zoom)")
            }

        }
    }
}
