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
    case blending
}

class StickersViewModel {
    
    @Published private(set) var stickers = [FaceImage]()
    @Published var currentViewMode = StickersViewMode.normal
    @Published private(set) var indexPathOfSelectedStickers = Set<IndexPath>()
    
    let stickerService: StickerService
    
    init(stickerService: StickerService) {
        self.stickerService = stickerService
    }
    
    func getStickers() {
        stickers = stickerService.getStickers()
    }
    
    func clearAllIndexPathOfSelectedStickers() {
        self.indexPathOfSelectedStickers.removeAll()
    }
    
    func removeItemFromSelectedStickers(item: IndexPath) {
        self.indexPathOfSelectedStickers.remove(item)
    }
    
    func insertItemToSelectedStickers(item: IndexPath) {
        self.indexPathOfSelectedStickers.insert(item)
    }
    
    // remove selected stickers from the persistence store
    func removeSelectedStickers() {
        let idsOfStickersAfterRemoval = stickerService.removeStickers(stickers: getSelectedStickers())
        
        stickers = stickers.filter { idsOfStickersAfterRemoval.contains($0.id) }
    }
    
    func getSelectedStickers() -> [FaceImage] {
        return indexPathOfSelectedStickers.map { indexPath in
            return self.stickers[indexPath.row]
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
