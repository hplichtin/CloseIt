//
//  CloseItUserListRowView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.12.21.
//

import SwiftUI

struct CloseItUserListRowView: View {
    @EnvironmentObject var control: CloseItControl
    @ObservedObject var user: CloseItUser
    
    var userIsCurrent: Bool {
        return control.applicationCurrentUser != nil ? control.applicationCurrentUser!.id == user.id : false
    }
    
    var body: some View {
        Image(systemName: CloseItControl.getCurrentUserImageName(isCurrent: userIsCurrent))
        Text(user.displayName)
    }
}
