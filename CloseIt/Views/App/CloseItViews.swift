//
//  CloseIItExpandButtonView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 16.12.21.
//

import SwiftUI

enum CloseItToolbarObject: String, CaseIterable {
    case buttonUndo = "arrow.uturn.backward"
    case buttonRedo = "arrow.uturn.forward"
    case buttonZoomOut = "minus.magnifyingglass"
    case buttonZoomIn = "plus.magnifyingglass"
    case buttonShapeSize = "square.resize"
    case buttonRestoreSize = "square.resize.down"
    case buttonStart = "backward.end"
    case buttonNewRestart = "restart.circle"
    case buttonPrevious = "arrowshape.backward"
    case buttonPause = "pause.circle"
    case buttonPlay = "play.circle"
    case buttonNext = "arrowshape.forward"
    case buttonEnd = "forward.end"
    case buttonScores = "line.3.horizontal.circle.fill"
}

struct CloseItToolbarGameButtonView: View {
    @EnvironmentObject var control: CloseItControl
    var obj: CloseItToolbarObject
    @ObservedObject var game: CloseItGame
    @Binding var shapeSize: Bool
    
    var show: Bool {
        if game.mode == .isSingleUser {
            switch obj {
            case .buttonUndo, .buttonRedo: return true
            case .buttonShapeSize: return !shapeSize
            case .buttonRestoreSize: return shapeSize
            case .buttonZoomIn, .buttonZoomOut: return true
            case .buttonNewRestart: return true
            case .buttonPause: return game.isProcessing && game.isAutoClose
            case .buttonPlay: return !game.isProcessing || !game.isAutoClose
            case .buttonScores: return true
            // not used
            case .buttonStart, .buttonEnd, .buttonNext, .buttonPrevious: return false
            }
        }
        else if game.mode == .isReview {
            switch obj {
            case .buttonZoomIn, .buttonZoomOut: return true
            case .buttonShapeSize: return !shapeSize
            case .buttonRestoreSize: return shapeSize
            case .buttonPause: return game.isProcessing && game.isAutoClose
            case .buttonPlay: return !game.isProcessing || !game.isAutoClose
            case .buttonStart, .buttonEnd: return true
            case .buttonNext, .buttonPrevious: return true
            // not used
            case .buttonUndo, .buttonRedo: return false
            case .buttonNewRestart: return false
            case .buttonScores: return false
            }
        }
        else if game.mode == .inDemo {
            switch obj {
            case .buttonZoomIn, .buttonZoomOut: return true
            case .buttonShapeSize: return !shapeSize
            case .buttonRestoreSize: return shapeSize
            case .buttonStart, .buttonEnd: return true
            case .buttonNext, .buttonPrevious: return true
            // not used
            case .buttonPause, .buttonPlay: return false
            case .buttonUndo, .buttonRedo: return false
            case .buttonNewRestart: return false
            case .buttonScores: return false
            }
        }
        else {
            myMessage.error("unexpected game.mode: \(game.mode)")
        }
    }
    
    var disable: Bool {
        if game.mode == .isSingleUser {
            switch obj {
            case .buttonUndo: return game.isProcessing || game.isDisabled || !game.canUndo
            case .buttonRedo: return game.isProcessing || game.isDisabled || !game.canRedo
            case .buttonZoomIn, .buttonZoomOut: return game.isProcessing || shapeSize
            case .buttonShapeSize, .buttonRestoreSize: return game.isProcessing
            case .buttonNewRestart: return game.isProcessing || !game.hasScore
            case .buttonPause: return false
            case .buttonPlay: return game.isAutoClose
            case .buttonScores: return game.isProcessing
            // not used
            case .buttonStart, .buttonEnd, .buttonNext, .buttonPrevious: return false
            }
        }
        else if game.mode == .isReview {
            switch obj {
            case .buttonZoomIn, .buttonZoomOut: return game.isProcessing || shapeSize
            case .buttonShapeSize, .buttonRestoreSize: return game.isProcessing
            case .buttonPause: return false
            case .buttonPlay: return game.isAutoClose
            case .buttonStart: return game.isProcessing || game.isFirstAction
            case .buttonEnd: return game.isProcessing || game.isLastAction
            case .buttonNext: return game.isProcessing || game.isLastAction
            case .buttonPrevious: return game.isProcessing || game.isFirstAction
            // not used
            case .buttonUndo, .buttonRedo: return false
            case .buttonNewRestart: return false
            case .buttonScores: return false
            }
        }
        else if game.mode == .inDemo {
            switch obj {
            case .buttonZoomIn, .buttonZoomOut: return game.isProcessing || shapeSize
            case .buttonShapeSize, .buttonRestoreSize: return game.isProcessing
            case .buttonPause: return false
            case .buttonPlay: return game.isAutoClose
            case .buttonStart: return game.isProcessing || game.isFirstAction
            case .buttonEnd: return game.isProcessing || game.isLastAction
            case .buttonNext: return game.isProcessing || game.isLastAction
            case .buttonPrevious: return game.isProcessing || game.isFirstAction
            // not used
            case .buttonUndo, .buttonRedo: return false
            case .buttonNewRestart: return false
            case .buttonScores: return false
            }
        }
        else {
            myMessage.error("unexpected game.mode: \(game.mode)")
        }

    }
 
    func action () {
        switch obj {
        case .buttonUndo: control.undo(game: game)
        case .buttonRedo: control.redo(game: game)
        case .buttonZoomOut: 
            control.zoomMinus()
            shapeSize = false
        case .buttonZoomIn:
            control.zoomPlus()
            shapeSize = false
        case .buttonShapeSize: shapeSize = true
        case .buttonRestoreSize: shapeSize = false
        case .buttonNewRestart: control.restartGame(game: game)
        case .buttonPause, .buttonPlay: control.toggleIsAutoClose(game: game)
        case .buttonStart: control.undoAllActions(game: game)
        case .buttonEnd: control.doAllActions(game: game)
        case .buttonScores: control.reviewGame(game: game)
        case .buttonNext: 
            if game.mode == .inDemo {
                control.doNexStepActions(game: game)
            }
            else if game.mode == .isReview {
                control.doNextAction(game: game)
            }
            else {
                myMessage.error("unexpected game.mode: \(game.mode)")
            }
        case .buttonPrevious:
            if game.mode == .inDemo {
                control.doPreviousStepActions(game: game)
            }
            else if game.mode == .isReview {
                control.doPreviousAction(game: game)
            }
            else {
                myMessage.error("unexpected game.mode: \(game.mode)")
            }
        }
    }
    
    var body: some View {
        if show {
            Button(action: { action() }) {
                Label(obj.rawValue, systemImage: obj.rawValue)
            }
            .disabled(disable)
        }
    }
}

struct CloseItToolbarDemoButtonView: View {
    @EnvironmentObject var control: CloseItControl
    var obj: CloseItToolbarObject
    @ObservedObject var demo: CloseItDemo
    @Binding var shapeSize: Bool
    
    var show: Bool {
        switch obj {
        case .buttonUndo, .buttonRedo: return false
        case .buttonZoomIn, .buttonZoomOut: return false
        case .buttonShapeSize, .buttonRestoreSize: return false
        case .buttonNewRestart, .buttonPause, .buttonPlay: return false
        case .buttonStart, .buttonEnd: return true
        case .buttonNext, .buttonPrevious: return true
        case .buttonScores: return false
        }
    }
    
    var disable: Bool {
        switch obj {
        case .buttonUndo, .buttonRedo: return true
        case .buttonZoomIn, .buttonZoomOut: return true
        case .buttonShapeSize, .buttonRestoreSize: return true
        case .buttonNewRestart, .buttonPause, .buttonPlay: return true
        case .buttonStart, .buttonPrevious: return demo.objectIndex == 0
        case .buttonEnd, .buttonNext: return demo.objectIndex >= demo.objects.count - 1
        case .buttonScores: return true
        }
    }
 
    func action () {
        switch obj {
        case .buttonUndo, .buttonRedo: return
        case .buttonZoomOut: 
            control.zoomMinus()
            shapeSize = false
        case .buttonZoomIn:
            control.zoomPlus()
            shapeSize = false
        case .buttonShapeSize: shapeSize = true
        case .buttonRestoreSize: shapeSize = false
        case .buttonNewRestart, .buttonPause, .buttonPlay: return
        case .buttonStart: demo.objectIndex = 0
        case .buttonEnd: demo.objectIndex = demo.objects.count - 1
        case .buttonScores: return
        case .buttonNext: demo.objectIndex += 1
        case .buttonPrevious: demo.objectIndex -= 1
        }
    }
    
    var body: some View {
        if show {
            Button(action: { action() }) {
                Label(obj.rawValue, systemImage: obj.rawValue)
            }
            .disabled(disable)
        }
    }
}


struct CloseItDebugTextView: View {
    var body: some View {
        let debugText:LocalizedStringKey = "Debug"
        
        Text(debugText).font(.title).bold()
    }
}

struct CloseItExpandButtonView: View {
    @Binding var isSet: Bool
    
    var body: some View {
        Button(action: { isSet.toggle() }) {
            Image(systemName: isSet ? CloseItControl.UserInterface.expandSystemImageName : CloseItControl.UserInterface.collapseSystemImageName)
        }
    }
}

struct CloseItContactView: View {
    let designer = CloseIt.designer
    let email = CloseIt.designerEmail
    
    var body: some View {
        let contactText:LocalizedStringKey = "Please contact"
        
        Text(contactText)
        Divider()
        Text(designer).bold()
        Divider()
        Text(email).bold()
    }
}

struct CloseItValueView: View {
    var text: LocalizedStringKey
    var value: Int
    
    var body: some View {
        HStack {
            Text(text).bold()
            Divider()
            Text("\(value)")
        }
    }
}

struct CloseItDateView: View {
    var text: LocalizedStringKey
    var value: Date
    
    let formatter = DateFormatter()
    
    var body: some View {
        HStack {
            Text(text).bold()
            Divider()
            Text(CloseIt.dateAsSring(date: value))
        }
    }
}

struct CloseItTimelineView: View {
    var text: LocalizedStringKey
    var from: Date
    var to: Date
    
    let formatter = DateFormatter()
    
    var body: some View {
        HStack {
            Text(text).bold()
            Divider()
            Text(CloseIt.dateAsSring(date: from))
            Divider()
            Text(CloseIt.dateAsSring(date: to))
        }
    }
}

struct CloseItInfoTextsView: View {
    var title: String
    var textI = 0
    
    class Data: Identifiable {
        var id: Int
        var text: String
        
        init (id: Int, text: String) {
            self.id = id
            self.text = text
        }
    }
    
    var texts: [Data] {
        var i = 0
        var data: [Data] = []
        var text: String
        
        repeat {
            text = CloseIt.getLocalizedText(className: CloseIt.textClass, type: title, id: "\(i)")
            if text != "" {
                data.append(Data(id: i, text: text))
            }
            i += 1
        } while text != ""
        return data
    }
    
    var body: some View {
        let titleText:LocalizedStringKey = LocalizedStringKey(title)
        List {
            let t = texts
            
            Text(titleText).font(.title).bold()
            ForEach(t) { text in
                Text(text.text)
            }
        }
    }
}



/* not used yet
struct CloseItHelpTextView: View {
    @State var numberText: String
    @State var helpText: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: CloseItControl.UserInterface.helpHideSystemImageName)
            Divider()
            if numberText != "" {
                Text(numberText)
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
*/


