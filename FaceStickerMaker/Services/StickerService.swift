//
//  StickerService.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 27/3/21.
//

import Foundation

class StickerService {
    
    func saveStickers(stickers: [FaceImage]) -> [String] {
        return saveStickersToUserDefaults(stickers: stickers)
    }
    
    private func saveStickerDataToFileSystem(sticker: FaceImage) -> String? {
        guard let imageData = sticker.image else { return nil }
        guard let filePath = Helper.filePath(forKey: sticker.id, forFormat: "png") else { return nil }
        
        do {
            try imageData.write(to: filePath, options: .atomic)
            return sticker.id
        } catch {
            return nil
        }
    }
    
    private func saveStickersToUserDefaults(stickers: [FaceImage]) -> [String] {
        var existingStickersIds = UserDefaults.standard.array(forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS) as? [String] ?? [String]()
        
        var newlySavedStickersIds = [String]()
        
        for sticker in stickers {
            if let newlySavedStickerId = saveStickerDataToFileSystem(sticker: sticker) {
                existingStickersIds.insert(newlySavedStickerId, at: 0)
                newlySavedStickersIds.insert(newlySavedStickerId, at: 0)
            }
        }
        
        UserDefaults.standard.set(existingStickersIds, forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS)
        
        return newlySavedStickersIds
    }
    
}
