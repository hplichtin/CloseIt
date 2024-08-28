//
//  CloseItScoreListRowView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.12.21.
//

import SwiftUI

struct CloseItScoreListRowView: View {
    @EnvironmentObject var control: CloseItControl
    var groupRank: Int
    var scoreRank: Int
    var userId: String
    var text: String
    
    var body: some View {
        if scoreRank != 0 {
            Text("\(groupRank).\(scoreRank).")
        }
        else {
            Text("-.")
        }
        Text(text)
    }
}
