//
//  Helper.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 27/3/21.
//

import Foundation

class Helper {
    static func filePath(forKey key: String, forFormat format: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        
        return documentURL.appendingPathComponent("\(key).\(format)")
    }
}
