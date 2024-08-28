//
//  CloseItLoad.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 21.11.21.
//

import Foundation

class CloseItData {
    static let fileExtension = "json"

    static let sourceBundleMain = "Bundle.main"
    static let sourceUserDomain = "UserDomain"
    static let sourceHHome = "UserHome"

    static func getURL (bundleFileName: String, fileExtension: String = CloseItData.fileExtension) -> URL {
        var fileName = bundleFileName
        
        if fileExtension != "" {
            fileName += "." + fileExtension
        }
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil)
        else {
            myMessage.error("Couldn't find fileNamE '\(fileName)' in main bundle.")
        }
        return url
    }

    static func getURL (userDomainFileName: String, fileExtension: String = CloseItData.fileExtension) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent(userDomainFileName).appendingPathExtension(fileExtension)
        
        return url
    }
    
    static func getURL (source: String, fileName: String, fileExtension: String = CloseItData.fileExtension) -> URL {
        switch source {
        case CloseItData.sourceBundleMain: return getURL(bundleFileName: fileName, fileExtension: fileExtension)
        case CloseItData.sourceUserDomain: return getURL(userDomainFileName: fileName, fileExtension: fileExtension)
        default: myMessage.error("unexpected source '\(source)'")
        }
    }
    
    static func load (url: URL) -> Data? {
        let data: Data
        
        do {
            data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }
    
    static func load (source: String, fileName: String, fileExtension: String = CloseItData.fileExtension) -> Data? {
        let url = getURL(source: source, fileName: fileName, fileExtension: fileExtension)
        
        return load(url: url)
    }
    
    static func removeFile (url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            myMessage.debug("file '\(url)' removed")
        } catch {
            myMessage.warning("cannot remove \(url):'\(error)'")
        }

    }
    
    static func removeFile (userDomainFileName: String, fileExtension: String = CloseItData.fileExtension) {
        let url = CloseItData.getURL(userDomainFileName: userDomainFileName, fileExtension: fileExtension)
        
        removeFile(url: url)
    }
 }

func loadCloseItData<T: Decodable>(url: URL) -> T {
    let data: Data
    
    do {
        data = try Data(contentsOf: url)
    } catch {
        myMessage.error("loadCloseItData: couldn't load \(url): '\(error)'")
    }

    do {
        let decoder = JSONDecoder()
        let t: T = try decoder.decode(T.self, from: data)
        myMessage.debug("loadCloseItData: file:'\(url)' loaded")
        return t
    } catch {
        myMessage.error("loadCloseItData: couldn't parse \(url) as \(T.self): '\(error)'")
    }
}

func loadCloseItData<T: Decodable>(data: Data) -> T {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        myMessage.error("Couldn't parse as \(T.self):\n\(error)")
    }
}

func storeCloseItData<T: Encodable>(t: T, url: URL) {
    let data: Data
    
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        data = try encoder.encode(t)
    } catch {
        myMessage.error("Couldn't encode \(T.self): '\(error)'")
    }
    
    do {
        try data.write(to: url)
        myMessage.debug("storeCloseItData: file:'\(url)' stored")
    } catch {
        myMessage.error("Couldn't write \(url):\n\(error)")
    }
}

func storeCloseItData<T: Encodable>(t: T, userDomainFileName: String, fileExtension: String = CloseItData.fileExtension) {
    let url = CloseItData.getURL(userDomainFileName: userDomainFileName, fileExtension: fileExtension)

    storeCloseItData(t: t, url: url)
}
