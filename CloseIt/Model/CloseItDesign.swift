//
//  CloseItDesign.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 25.06.2024.
//

import Foundation

class CloseItDesign: ObservableObject, Identifiable, Equatable, CustomStringConvertible {
    @Published var data: CloseItDataDesign

    static func == (lhs: CloseItDesign, rhs: CloseItDesign) -> Bool {
        return lhs.id == rhs.id
    }
        
    static func load (objects: inout [CloseItDesign]) {
        var data: [CloseItDataDesign] = []
        
        CloseItDataDesign.load(data: &data)
        for d in data {
            let design = CloseItDesign(data: d)
            
            objects.append(design)
        }
    }

    init (design: CloseItDesign) {
        self.data = design.data
    }

    init (data: CloseItDataDesign) {
        self.data = data
    }
    
    var id: String {
        return data.id
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        return data.value(showName: showName, sep: sep)
    }

    var description: String {
        return "[CloseItDesign|id:\(data.id)]"
    }
}
