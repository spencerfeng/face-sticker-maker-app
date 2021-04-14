//
//  StickerService.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 27/3/21.
//

import Foundation

class StickerService {
    
    func addStickers(stickers: [FaceImage]) -> [FaceImage] {
        return addStickersToUserDefaults(stickers: stickers)
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
    
    private func addStickersToUserDefaults(stickers: [FaceImage]) -> [FaceImage] {
        var existingStickersIds = UserDefaults.standard.array(
            forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS) as? [String] ?? [String]()
        
        var newlySavedStickersIds = [String]()
        
        for sticker in stickers {
            if let newlySavedStickerId = saveStickerDataToFileSystem(sticker: sticker) {
                existingStickersIds.insert(newlySavedStickerId, at: 0)
                newlySavedStickersIds.insert(newlySavedStickerId, at: 0)
            }
        }
        
        UserDefaults.standard.set(existingStickersIds, forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS)
        
        return stickers.filter { sticker in
            newlySavedStickersIds.contains(sticker.id)
        }
    }
    
    func getStickers() -> [FaceImage] {
        let stickerIds = UserDefaults.standard.array(forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS) as? [String] ?? [String]()
        
        return stickerIds.compactMap { stickerId in
            guard let faceImageURL = Helper.filePath(forKey: stickerId, forFormat: "png") else { return nil }
            let imageData = NSData(contentsOf: faceImageURL) as Data?
            guard let data = imageData else { return nil }
            return FaceImage(id: stickerId, image: data)
        }
    }
    
    func removeStickers(stickers: [FaceImage]) -> [String] {
        let idsOfStickersToRemove = stickers.map { $0.id }
        let existingStickersIds = UserDefaults.standard.array(
            forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS) as? [String] ?? [String]()
        
        let filteredStickersIds = existingStickersIds.filter { !idsOfStickersToRemove.contains($0) }
        
        UserDefaults.standard.set(filteredStickersIds, forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS)
        
        return filteredStickersIds
    }
    
}
