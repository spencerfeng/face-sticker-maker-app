//
//  ChooseCroppedImagesViewModel.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 23/3/21.
//

import Foundation

class ChooseCroppedImagesViewModel: SelectFaceImageToggleResponder {
    
    var stickerRepository: StickerRepository
    var addStickersResponder: AddStickersResponder
    
    var croppedImages = [FaceImage]()
    var selectedFaceImages = [FaceImage]()
    
    init(stickerRepository: StickerRepository, addStickersResponder: AddStickersResponder) {
        self.stickerRepository = stickerRepository
        self.addStickersResponder = addStickersResponder
    }
    
    func toggleFaceImageSelection(faceImage: FaceImage, selected: Bool) {
        if selected {
            selectedFaceImages.append(faceImage)
        } else {
            if let index = selectedFaceImages.firstIndex(where: { $0.id == faceImage.id }) {
                selectedFaceImages.remove(at: index)
            }
        }
    }
    
    func saveStickers() {
        let addedStickers = stickerRepository.saveStickers(stickers: selectedFaceImages)
        addStickersResponder.handleAddedStickers(newStickers: addedStickers)
    }
    
}
