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
    
    init(faceImage: FaceImage) {
        self.faceImage = faceImage
    }
    
    func toggleWillKeepState() {
        willKeep.toggle()
    }
    
}
