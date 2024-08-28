//
//  CloseItDemoViews.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 14.07.2024.
//

import SwiftUI

struct CloseItDemoGameView: View {
    @EnvironmentObject var control: CloseItControl
    @ObservedObject var demo: CloseItDemo
    var loop: Bool
    @State var shapeSize: Bool = false
    
    var design: CloseItDesign {
        let design = control.getDesign(designId: control.resources.dataControl.designId)
        
        return design
    }
    
    func startLoop () {
        if loop {
            demo.game!.isAutoClose = false
            control.loopActions(game: demo.game!)
            demo.game!.isAutoClose = true
        }
    }
   
    func stopLoop () {
        if loop {
            demo.game!.isAutoClose = false
        }
    }
    
    var body: some View {
        let welcomeText:LocalizedStringKey = "Welcome"
        
        if demo.id == "Welcome" {
            HStack {
                Text(welcomeText).font(.title).bold()
            }
        }
        CloseItGameView(control: control, design: design, game: demo.game!, controlZoom: $control.applicationZoom, shapeSize: $shapeSize, controlDebug: $control.applicationDebug, resize: loop, enable: !loop, showHelpAlways: true)
            .onAppear(perform: { startLoop() })
            .onDisappear(perform: { stopLoop() })
    }
}

struct CloseItDemoImageView: View {
    @EnvironmentObject var control: CloseItControl
    @ObservedObject var demo: CloseItDemo
    @State var shapeSize: Bool = false
    
    var helpText: String {
        var helpText = demo.helpText
        
        if helpText == "" {
            helpText = demo.helpId()
        }
        return helpText
    }
        
    var body: some View {
        List {
            let ht = helpText

            HStack(alignment: .top) {
                Image(systemName: CloseItControl.UserInterface.helpHideSystemImageName)
                Divider()
                if demo.objects.count > 1 {
                    Text("\(demo.objectIndex + 1) / \(demo.objects.count)")
                    Divider()
                }
                if #available(iOS 15.0, *) {
                    Text(ht).textSelection(.enabled)
                } else {
                    Text(ht)
                }
            }
            Image(demo.objects[demo.objectIndex])
        }
        .toolbar {
            HStack {
                ForEach(CloseItToolbarObject.allCases, id: \.self) { obj in
                    CloseItToolbarDemoButtonView(obj: obj, demo: demo, shapeSize: $shapeSize)
                }
            }
        }

    }
}

struct CloseItDemoTextView: View {
    @EnvironmentObject var control: CloseItControl
    @ObservedObject var demo: CloseItDemo
    @State var shapeSize: Bool = false
    
    var helpText: String {
        var helpText = demo.helpText
        
        if helpText == "" {
            helpText = demo.helpId()
        }
        return helpText
    }
        
    var body: some View {
        List {
            let ht = helpText

            HStack(alignment: .top) {
                Image(systemName: CloseItControl.UserInterface.helpHideSystemImageName)
                Divider()
                if demo.objects.count > 1 {
                    Text("\(demo.objectIndex + 1) / \(demo.objects.count)")
                    Divider()
                }
                if #available(iOS 15.0, *) {
                    Text(ht).textSelection(.enabled)
                } else {
                    Text(ht)
                }
            }
        }
        .toolbar {
            HStack {
                ForEach(CloseItToolbarObject.allCases, id: \.self) { obj in
                    CloseItToolbarDemoButtonView(obj: obj, demo: demo, shapeSize: $shapeSize)
                }
            }
        }

    }
}

struct CloseItDemosView: View {
    @EnvironmentObject var control: CloseItControl
    
    var index: Int = 0
    
    var body: some View {
        ForEach(control.resources.demos.demos) { demo in
            if demo.demoType == .board {
                NavigationLink(destination: CloseItDemoGameView(demo: demo, loop: demo.game!.steps.count == 0 )) {
                    Text(demo.game!.board.boardName)
                }
            }
            else if demo.demoType == .image {
                NavigationLink(destination: CloseItDemoImageView(demo: demo)) {
                    Text(demo.demoName)
                }
            }
            else if demo.demoType == .text {
                NavigationLink(destination: CloseItDemoTextView(demo: demo)) {
                    Text(demo.demoName)
                }
            }
            else {
                myMessage.error("unexpected demo.demoType: '\(demo.demoType))'")
            }
        }
    }
}
