//
//  SharedHelper.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 6/5/21.
//

import Foundation

public class SharedHelper {
    public static func filePath(forKey key: String, forFormat format: String) -> URL? {
        guard let documentURL = FileManager().containerURL(forSecurityApplicationGroupIdentifier: SharedConstants.APP_GROUP_NAME) else { return nil }
            
        return documentURL.appendingPathComponent("\(key).\(format)")
    }
}
