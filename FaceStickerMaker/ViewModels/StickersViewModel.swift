//
//  StickersViewModel.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 28/3/21.
//

import Foundation

class StickersViewModel {
    
    @Published private(set) var stickers = [FaceImage]()
    
    let stickerRepository: StickerRepository
    
    init(stickerRepository: StickerRepository) {
        self.stickerRepository = stickerRepository
    }
    
    func getStickers() {
        stickers = stickerRepository.getStickers()
    }
    
}

extension StickersViewModel: AddStickersResponder {
    func handleAddedStickers(newStickers: [FaceImage]) {
        if newStickers.count > 0 {
            stickers = newStickers + stickers
        }
    }
}
