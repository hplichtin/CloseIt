//
//  CloseItPlayerControl.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 18.06.2024.
//

import GameKit

class CloseItPlayer: CloseItLog {
    static let sourceId = "GameKit"
    
    private var control: CloseItControl? = nil
    var id: String = ""
    
    func set () {
        CLOSEIT_TYPE_FUNC_START(self)
        if GKLocalPlayer.local.isAuthenticated {
            let localPlayerID: String? = GKLocalPlayer.local.gamePlayerID
            
            if localPlayerID != nil && id != localPlayerID! {
                id = localPlayerID!
                if control != nil {
                    control!.addPlayerToUsers()
                }
            }
            myMessage.debug("CloseItPlayer: \(value(showName: true))")
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    init () {
        set()
    }
    
    var source: String {
        return CloseItPlayer.sourceId
    }
    
    var isAuthenticated: Bool {
        if GKLocalPlayer.local.isAuthenticated {
            let localPlayerID: String? = GKLocalPlayer.local.gamePlayerID

            if localPlayerID != nil {
                return localPlayerID! == id
            }
        }
        return false
    }
    
    var alias: String {
        return isAuthenticated ? GKLocalPlayer.local.alias : ""
    }
    
    var name: String {
        return isAuthenticated ? GKLocalPlayer.local.displayName : ""
    }
    
    func authenticate () {
        CLOSEIT_TYPE_FUNC_START(self)
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let vc = viewController {
                // Show the authentication dialog when reasonable
                if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    keyWindow.rootViewController?.present(vc, animated: true)
                }
                self.set()
            } else if GKLocalPlayer.local.isAuthenticated {
                self.set()
            } else {
                myMessage.warning(#function + ": GKLocalPlayer not authenticated")
            }
            if let error = error {
                var errorString: String
                
                errorString = error.localizedDescription
                myMessage.warning("GKLocalPlayer.local.authenticateHandler: error: \(errorString)")
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    class MyGameCenterDelegate: NSObject, GKGameCenterControllerDelegate {
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            // Handle dismissal (e.g., return to your game screen)
            gameCenterViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func dashboard() {
        if isAuthenticated {
            let gameCenterController = GKGameCenterViewController(state: .dashboard)
            let gameCenterDelegate = MyGameCenterDelegate()
            
            gameCenterController.gameCenterDelegate = gameCenterDelegate
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                if let rootVC = keyWindow.rootViewController, rootVC.presentedViewController == nil {
                    rootVC.present(gameCenterController, animated: true, completion: nil)
                }
                else {
                    myMessage.warning("Dashboard is not visible. Cannot present game center.")
                }
            }
        }
    }
    
    func setControl (control: CloseItControl) {
        if self.control == nil {
            self.control = control
            set()
        }
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
     
        s += ( showName ? "id:" : "" ) + id + sep
        s += ( showName ? "isAuthenticated:" : "" ) + "\(GKLocalPlayer.local.isAuthenticated)"
        return s
    }
}
