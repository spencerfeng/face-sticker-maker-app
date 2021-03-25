//
//  SelectFaceImageTVViewModel.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 23/3/21.
//

import Foundation

class SelectFaceImageTVViewModel {
    
    @Published private(set) var willKeep = false
    
    let faceImage: FaceImage
    let selectFaceImageToggleResponder: SelectFaceImageToggleResponder
    
    init(faceImage: FaceImage, selectFaceImageToggleResponder: SelectFaceImageToggleResponder) {
        self.faceImage = faceImage
        self.selectFaceImageToggleResponder = selectFaceImageToggleResponder
    }
    
    func toggleWillKeepState() {
        willKeep.toggle()
        selectFaceImageToggleResponder.toggleFaceImageSelection(faceImage: faceImage, selected: willKeep)
    }
    
}
