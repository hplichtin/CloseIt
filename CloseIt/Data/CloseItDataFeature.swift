//
//  CloseItDataFeature.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 04.12.21.
//

import Foundation
import Combine

struct CloseItDataFeature: Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "feature"
    static let version = "v1"
    
    var program: String
    var type: String
    var version: String
    var programVersion: String
    var programFeature: String
    var count: Int
    var programFeaturesText: [String]
    var current: Bool
        
    static func == (lhs: CloseItDataFeature, rhs: CloseItDataFeature) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func load (data: inout [CloseItDataFeature]) {
        let url = CloseItData.getURL(bundleFileName: type)
        let d: [CloseItDataFeature] = loadCloseItData(url: url)
        
        data += d
    }
    
    var id: String {
        return programFeature + CloseIt.separator + programVersion
    }
    
    init(program: String = CloseIt.program,
          type: String = CloseItDataFeature.type,
          version: String = CloseItDataFeature.version,
          programVersion: String,
          programFeature: String,
          count: Int,
          programFeatureText: [String],
          current: Bool = true) {
        self.program = program
        self.type = type
        self.version = version
        self.programVersion = programVersion
        self.programFeature = programFeature
        self.count = count
        self.programFeaturesText = programFeatureText
        self.current = current
    }
    
    func value (showName: Bool = false, sep: String =  CloseIt.separator) -> String {
        var s: String = ""
     
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "programVersion:" : "" ) + programVersion + sep
        s += ( showName ? "programFeature:" : "" ) + programFeature + sep
        s += ( showName ? "count:" : "" ) + "\(count)" + sep
        s += ( showName ? "programFeaturesText:" : "" ) + programFeaturesText[0] + sep
        s += ( showName ? "current:" : "" ) + "\(current)"
        return s
    }
    
    var description: String {
        return "[CloseItDataFeature|id:\(id)]"
    }
}

struct CloseItDataFeatureEntry: Identifiable {
    var id: String
    var features: [CloseItDataFeature] = []
    
    static func count (features: [CloseItDataFeatureEntry]) -> Int {
        var c = 0
        
        for f in features {
            c += f.count
        }
        return c
    }
        
    static func programVersions (features: [CloseItDataFeature]) -> [CloseItDataFeatureEntry] {
        var versions: [CloseItDataFeatureEntry] = []
        
        for f in features {
            var i: Int = 0
            
            while i < versions.count {
                if versions[i].id == f.programVersion {
                    break
                }
                i += 1
            }
            if i == versions.count {
                versions.append(CloseItDataFeatureEntry(id: f.programVersion))
            }
            versions[i].features.append(f)
        }
        return versions
    }
    
    static func programFeatures (features: [CloseItDataFeature]) -> [CloseItDataFeatureEntry] {
        var versions: [CloseItDataFeatureEntry] = []
        
        for f in features {
            var i: Int = 0
            
            while i < versions.count {
                if versions[i].id == f.programFeature {
                    break
                }
                i += 1
            }
            if i == versions.count {
                versions.append(CloseItDataFeatureEntry(id: f.programFeature))
            }
            versions[i].features.append(f)
        }
        return versions
    }
    
    static func current (features: [CloseItDataFeature]) -> [CloseItDataFeatureEntry] {
        var versions: [CloseItDataFeatureEntry] = []
        
        versions.append(CloseItDataFeatureEntry(id: CloseIt.version))
        let ff = features.filter { $0.current }
        for f in ff {
            versions[0].features.append(f)
        }
        return versions
    }
    
    var current: Bool {
        for f in features {
            if f.current {
                return true
            }
        }
        return false
    }
    
    var count: Int {
        var c = 0
        
        for f in features {
            c += f.count
        }
        return c
    }
}

