//
//  StickersViewModel.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 28/3/21.
//

import Foundation

enum StickersViewMode {
    case normal
    case selecting
}

class StickersViewModel {
    
    @Published private(set) var stickers = [FaceImage]()
    @Published private(set) var currentViewMode = StickersViewMode.normal
    
    let stickerRepository: StickerRepository
    
    init(stickerRepository: StickerRepository) {
        self.stickerRepository = stickerRepository
    }
    
    func getStickers() {
        stickers = stickerRepository.getStickers()
    }
    
    func changeViewMode() {
        switch currentViewMode {
        case .normal:
            currentViewMode = .selecting
        case .selecting:
            currentViewMode = .normal
        }
    }

}

extension StickersViewModel: AddStickersResponder {
    func handleAddedStickers(newStickers: [FaceImage]) {
        if newStickers.count > 0 {
            stickers = newStickers + stickers
        }
    }
}
