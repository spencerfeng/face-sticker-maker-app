//
//  StickerRepository.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 25/3/21.
//

import Foundation

class StickerRepository {
    
    let stickerService: StickerService
    
    init(stickerService: StickerService) {
        self.stickerService = stickerService
    }
    
    func saveStickers(stickers: [FaceImage]) -> [FaceImage] {
        return stickerService.saveStickers(stickers: stickers)
    }
    
    func getStickers() -> [FaceImage] {
        return stickerService.getStickers()
    }
    
    func removeStickers(stickers: [FaceImage]) -> [String] {
        return stickerService.removeStickers(stickers: stickers)
    }
}
