//
//  CloseItUser.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import Foundation

class CloseItUser: ObservableObject, Identifiable, Equatable, CustomStringConvertible {
    @Published var data: CloseItDataUser

    static func == (lhs: CloseItUser, rhs: CloseItUser) -> Bool {
        return lhs.id == rhs.id
    }
        
    static func load (objects: inout [CloseItUser]) {
        var data: [CloseItDataUser] = []
        
        CloseItDataUser.load(data: &data)
        for d in data {
            let user = CloseItUser(data: d)
            
            objects.append(user)
        }
    }

    static func store (objects: [CloseItUser]) {
        var data: [CloseItDataUser] = []
        
        for o in objects {
            data.append(o.data)
        }
        CloseItDataUser.store(data: data)
    }
    
    init (user: CloseItUser) {
        self.data = user.data
    }

    init (data: CloseItDataUser) {
        self.data = data
    }
    
    init (player: CloseItPlayer) {
        data = CloseItDataUser(source: player.source, id: player.id, alias: player.alias, name: player.name)
    }
    
    init (name: String) {
        data = CloseItDataUser(name: name)
    }
    
    init (id: String) {
        data = CloseItDataUser(id: id, name: id)
    }
    
    init () {
        self.data = CloseItDataUser()
    }
    
    func set (player: CloseItPlayer) {
        data.source = player.source
        data.id = player.id
        data.alias = player.alias
        data.name = player.name
    }

    var id: String {
        return data.id
    }
    
    var displayName: String {
        return data.alias == "" ? data.name : data.alias
    }
    
    var level: Level {
        return data.level
    }
    
    var isAutoClose: Bool {
        return data.isAutoClose
    }
    
    var sleepSeconds: Double {
        return data.sleepSeconds
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        return data.value(showName: showName, sep: sep)
    }

    var description: String {
        return "[CloseItUser|id:\(data.id)|name:\(data.name)]"
    }
}

class CloseItUsers: CloseItLog, RandomAccessCollection, ObservableObject, Identifiable {
    
    @Published var users: [CloseItUser] = []
    
    init () {
        CLOSEIT_TYPE_FUNC_START(self)
        // empty
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    init (array: CloseItUsers) {
        for u in array.users {
            users.append(CloseItUser(user: u))
        }
    }
    
    subscript(y: Int) -> CloseItUser {
        return users[y]
    }
    
    var count: Int {
        return users.count
    }
    
    var startIndex: Int {
        return users.startIndex
    }
    
    var endIndex: Int {
        return users.endIndex
    }
    
    func find (userId: String) -> CloseItUser {
        CLOSEIT_TYPE_FUNC_START(self)
        var i = 0
        
        for u in users {
            if u.id == userId {
                CLOSEIT_TYPE_FUNC_END(self)
                return u
            }
            i += 1
        }
        CLOSEIT_TYPE_FUNC_END(self)
        myMessage.error("userId '\(userId)' not found")
    }

    func find (userId: String) -> Int {
        var i = 0
        
        while i < users.count {
            if users[i].id == userId {
                return i
            }
            i += 1
        }
        return i
    }
    
    func append (user: CloseItUser) {
        users.append(user)
    }
    
    func remove (at: Int) {
        users.remove(at: at)
    }
    
    func remove (userId: String) {
        var i: Int = 0
        
        while i < count {
            if users[i].id == userId {
                users.remove(at: i)
                return
            }
            i += 1
        }
        myMessage.error("unexpected userId: \(userId)")
    }

    
    func reset () {
        users = []
    }
    
    func load () {
        CloseItUser.load(objects: &users)
    }
    
    func store () {
        CloseItUser.store(objects: users)
    }
}
