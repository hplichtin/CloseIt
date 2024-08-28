//
//  CloseItGamesGroupView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 20.12.21.
//

import SwiftUI

struct CloseItGamesGroupView: View {
    @EnvironmentObject var control: CloseItControl
    var title: LocalizedStringKey
    @ObservedObject var group: CloseItGamesGroup
    @Binding var score: String
    @State var shapeSize: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(group.data.filter { $0.games.achievedObjects.level <= control.applicationLevel && $0.games.achievedObjects.num > 0 }) {
                    gg in CloseItGamesView(ggData: gg, shapeSize: $shapeSize)
                }
            }
            .navigationTitle(title)
            .toolbar {
                Text(score)
            }
        }
    }
}
