//
//  CloseItProgramView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 18.09.22.
//

import SwiftUI

struct CloseItFeatureEntryView: View {
    var featureEntry: CloseItDataFeatureEntry
    var showCurrent: Bool
    @State var isCollapsed: Bool = true
    
    var count: Int {
        return featureEntry.count
    }

    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(featureEntry.id).font(.title3).bold()
            Divider()
            Text("\(featureEntry.features.count) (\(count))")
        }
        if !isCollapsed {
            ForEach(featureEntry.features) { feature in
                HStack {
                    Image(systemName: feature.current ? CloseItControl.UserInterface.currentSystemImageName : CloseItControl.UserInterface.notCurrentSystemImageName)
                    Divider()
                    Text(feature.programFeature).bold()
                    Divider()
                    Text(feature.programVersion)
                    Divider()
                    Text("\(feature.count)")
                    Divider()
                    Text(feature.programFeaturesText.description)
                }
            }
        }
    }
}

struct CloseItFeaturesView: View {
    var features: [CloseItDataFeatureEntry]
    var showCurrent: Bool
    
    var count: Int {
        return CloseItDataFeatureEntry.count(features: features)
    }

    var body: some View {
        HStack {
            Text("Features:").font(.title2).bold()
            Divider()
            Text("\(count)")
        }
        ForEach(features) { feature in
            CloseItFeatureEntryView(featureEntry: feature, showCurrent: showCurrent)
        }
    }
}

struct CloseItProgramView: View {
    @EnvironmentObject var control: CloseItControl

    var body: some View {
            List {
                HStack {
                    Text("Program").font(.title).bold()
                }
                HStack {
                    Text(CloseIt.program).bold()
                    Divider()
                    Text(CloseIt.version).bold()
                    Divider()
                    Text(CloseIt.build).bold()
                }
                HStack {
                    Text(CloseIt.designer).bold()
                    Divider()
                    Text(CloseIt.designerEmail).bold()
                }
                if control.applicationShowAll {
                    CloseItFeaturesView(features: CloseItDataFeatureEntry.programVersions(features: control.resources.features), showCurrent: true)
                }
                else {
                    CloseItFeaturesView(features: CloseItDataFeatureEntry.current(features: control.resources.features), showCurrent: false)
                }
            }
            .toolbar {
                HStack {
                    Button(action: { control.toggleShowAll() }) {
                        Text("Show " + (control.applicationShowAll ? "Current Version Only" : "All Versions")).bold()
                    }
                }
            }
    }
}
