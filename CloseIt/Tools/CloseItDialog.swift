//
//  CloseItDialogs.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 24.06.2024.
//

import SwiftUI

class CloseItDialog {
    class CustomDialogViewController: UIViewController {
        
    }
    
    func myCustomMethod() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let customDialogVC = storyboard.instantiateViewController(withIdentifier: "CustomDialogViewController") as? CustomDialogViewController {
            // Customize any properties or data for your dialog here
            // For example, set a delegate or pass data to the dialog
            
            // Present the custom dialog modally
            customDialogVC.modalPresentationStyle = .overCurrentContext
            customDialogVC.modalTransitionStyle = .crossDissolve
            customDialogVC.present(customDialogVC, animated: true, completion: nil)
        }
    }
}
