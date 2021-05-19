//
//  StickersCollectionViewCellViewModel.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 29/3/21.
//

import Foundation

class StickersCollectionViewCellViewModel {
    
    let sticker: FaceImage
    
    @Published private(set) var isSelected = false
    
    init(sticker: FaceImage) {
        self.sticker = sticker
    }
    
    public func toggleSelectedState() {
        isSelected.toggle()
    }
    
}
