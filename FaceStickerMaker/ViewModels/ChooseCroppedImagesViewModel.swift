//
//  ChooseCroppedImagesViewModel.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 23/3/21.
//

import Foundation

class ChooseCroppedImagesViewModel: SelectFaceImageToggleResponder {
    
    var stickerRepository: StickerRepository
    
    var croppedImages = [FaceImage]()
    var selectedFaceImages = [FaceImage]()
    
    init(stickerRepository: StickerRepository) {
        self.stickerRepository = stickerRepository
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
        _ = stickerRepository.saveStickers(stickers: selectedFaceImages)
    }
    
}
