//
//  StickerServiceImpl.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 14/4/21.
//

import Foundation

class StickerServiceImpl: StickerService {
    
    func addStickers(stickers: [FaceImage]) -> [FaceImage] {
        return addStickersToUserDefaults(stickers: stickers)
    }
    
    // TODO: needs to do error handling instead of returning an empty array
    func getStickers() -> [FaceImage] {
        if let userDefaults = UserDefaults.init(suiteName: Constants.APP_GROUP_NAME) {
            let stickerIds = userDefaults.array(forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS) as? [String] ?? [String]()
            
            return stickerIds.compactMap { stickerId in
                guard let faceImageURL = Helper.filePath(forKey: stickerId, forFormat: "png") else { return nil }
                let imageData = NSData(contentsOf: faceImageURL) as Data?
                guard let data = imageData else { return nil }
                return FaceImage(id: stickerId, image: data)
            }
        }
        
        return [FaceImage]()
    }
    
    // TODO: needs to do error handling instead of returning an empty array
    func removeStickers(stickers: [FaceImage]) -> [String] {
        if let userDefaults = UserDefaults.init(suiteName: Constants.APP_GROUP_NAME) {
            let idsOfStickersToRemove = stickers.map { $0.id }
            let existingStickersIds = userDefaults.array(
                forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS) as? [String] ?? [String]()
            
            let filteredStickersIds = existingStickersIds.filter { !idsOfStickersToRemove.contains($0) }
            
            userDefaults.set(filteredStickersIds, forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS)
            
            return filteredStickersIds
        }
        return [String]()
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
    
    // TODO: needs to do error handling instead of returning an empty array
    private func addStickersToUserDefaults(stickers: [FaceImage]) -> [FaceImage] {
        if let userDefaults = UserDefaults.init(suiteName: Constants.APP_GROUP_NAME) {
            var existingStickersIds = userDefaults.array(
                forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS) as? [String] ?? [String]()
            
            var newlySavedStickersIds = [String]()
            
            for sticker in stickers {
                if let newlySavedStickerId = saveStickerDataToFileSystem(sticker: sticker) {
                    existingStickersIds.insert(newlySavedStickerId, at: 0)
                    newlySavedStickersIds.insert(newlySavedStickerId, at: 0)
                }
            }
            
            userDefaults.set(existingStickersIds, forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS)
            
            return stickers.filter { sticker in
                newlySavedStickersIds.contains(sticker.id)
            }
        }
        
        return [FaceImage]()
    }
    
}
