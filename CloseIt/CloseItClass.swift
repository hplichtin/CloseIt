//
//  CloseItClass.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 10-Jul-2024.
//

import Foundation
import SwiftUI

extension Bundle {
    var appName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

struct CloseIt {
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var isPortrait: Bool {
        return UIDevice.current.orientation.isPortrait
    }
    
    static var isLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    static var program: String {
        let appName = Bundle.main.appName
        
        precondition(appName != nil)
        return appName!
    }
    
    static var version: String {
        let appVersion = Bundle.main.releaseVersionNumber
        
        precondition(appVersion != nil)
        return appVersion!
    }

    static var build: String {
        let buildVersion = Bundle.main.buildVersionNumber
        
        precondition(buildVersion != nil)
        return buildVersion!
    }
    
    static let designer = "Hans-Peter Lichtin"
    static let designerEmail = "hans-peter.lichtin@outlook.com"

    static let localizedKeyPrefix = "["
    static let localizedKeySuffix = "]"
    static let separator: String =  "|"
    
    static let helpClass = "HELP"
    static let keyClass = "KEY"
    static let textClass = "TEXT"

    static func getLocalizedText (className: String = keyClass, type: String, id: String) -> String {
        var localizedKey: String
        
        localizedKey = localizedKeyPrefix + className
        if type != "" {
            localizedKey += separator + type
        }
        if id != "" {
            localizedKey += separator + id
        }
        localizedKey += localizedKeySuffix
        
        let localizedText = Bundle.main.localizedString(forKey: localizedKey, value: nil, table: nil)
        
        if localizedKey == localizedText && className != CloseIt.keyClass {
            return ""
        }
        return localizedText
    }

    static func dateAsSring (date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium

        let formattedString = formatter.string(from: date)
        
        return formattedString
    }
    
    static func relativeDateAsSring (date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true

        let formattedString = formatter.string(from: date)
        
        return formattedString
    }

    
    static func timeIntervalAsString (timeInterval: TimeInterval) -> String {
        /*
         let ti: TimeInterval = timeInterval
         let hours = floor(ti / 3600)
         let minutes = floor((ti - hours * 3600) / 60)
         let seconds = ti - hours * 3600 - minutes * 60
         var s: String = ""
         
         s = String(format: "%02.0f", hours) + ":"
         + String(format: "%02.0f", minutes) + ":"
         + String(format: "%05.2f", seconds)
         return s
         */
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        
        let elapsedString = formatter.string(from: timeInterval)
        return elapsedString!
    }
}

protocol CloseItLog {
    var className: String { get }
}

extension CloseItLog {
    var className: String {
        return String(describing: Self.self)
    }
}

protocol CloseItProtocol {
    func helpType () -> String
    func helpId () -> String
    var helpText: String { get }
    
    func getLocalizedText (className: String, type: String, id: String) -> String
}

extension CloseItProtocol {
    var separator: String {
        return CloseIt.separator
    }
    
    var helpText: String {
        let type = helpType()
        let id = helpId()
        let helpText = getLocalizedText(className: CloseIt.helpClass, type: type, id: id)
        
        return helpText
    }
    
    func getLocalizedText (className: String = CloseIt.keyClass, type: String, id: String) -> String {
        let localizedText = CloseIt.getLocalizedText(className: className, type: type, id: id)
        
        return localizedText
    }
}

class CloseItClass: CloseItLog, CloseItProtocol {
    func helpType () -> String {
        return ""
    }
    
    func helpId () -> String {
        return ""
    }
}
