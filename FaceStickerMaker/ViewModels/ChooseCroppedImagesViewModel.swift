//
//  ChooseCroppedImagesViewModel.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 23/3/21.
//

import Foundation

class ChooseCroppedImagesViewModel: SelectFaceImageToggleResponder {
    
    let croppedImages: [FaceImage]
    private let stickerService: StickerService
    private let addStickersResponder: AddStickersResponder
    
    var selectedFaceImages = [FaceImage]()
    
    init(
        croppedImages: [FaceImage],
        stickerService: StickerService,
        addStickersResponder: AddStickersResponder
    ) {
        self.croppedImages = croppedImages
        self.stickerService = stickerService
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
        let addedStickers = stickerService.addStickers(stickers: selectedFaceImages)
        addStickersResponder.handleAddedStickers(newStickers: addedStickers)
    }
    
}
