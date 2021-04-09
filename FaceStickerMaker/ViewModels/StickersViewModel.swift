//
//  StickersViewModel.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 28/3/21.
//

import Foundation

class StickersViewModel {
    
    enum viewMode {
        case normal
        case selecting
    }
    
    @Published private(set) var stickers = [FaceImage]()
    @Published private(set) var currentViewMode = viewMode.normal
    
    let stickerRepository: StickerRepository
    
    init(stickerRepository: StickerRepository) {
        self.stickerRepository = stickerRepository
    }
    
    func getStickers() {
        stickers = stickerRepository.getStickers()
    }
    
    func startSelectingStickers() {
        currentViewMode = viewMode.selecting
    }
    
    func finishSelectingStickers() {
        currentViewMode = viewMode.normal
    }

}

extension StickersViewModel: AddStickersResponder {
    func handleAddedStickers(newStickers: [FaceImage]) {
        if newStickers.count > 0 {
            stickers = newStickers + stickers
        }
    }
}
