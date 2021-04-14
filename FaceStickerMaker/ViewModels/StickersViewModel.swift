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
    @Published var canDeleteStickers = false

    var indexPathOfSelectedStickers = Set<IndexPath>()
    
    let stickerService: StickerService
    
    init(stickerService: StickerService) {
        self.stickerService = stickerService
    }
    
    func getStickers() {
        stickers = stickerService.getStickers()
    }
    
    func changeViewMode() {
        switch currentViewMode {
        case .normal:
            currentViewMode = .selecting
        case .selecting:
            currentViewMode = .normal
        }
    }
    
    func removeSelectedStickers() {
        let stickersToRemove = indexPathOfSelectedStickers.map { indexPath in
            return self.stickers[indexPath.row]
        }
        
        let idsOfRemovedStickers = stickerService.removeStickers(stickers: stickersToRemove)
        
        stickers = stickers.filter { idsOfRemovedStickers.contains($0.id) }
    }

}

extension StickersViewModel: AddStickersResponder {
    func handleAddedStickers(newStickers: [FaceImage]) {
        if newStickers.count > 0 {
            stickers = newStickers + stickers
        }
    }
}
