//
//  MockAddStickersResponder.swift
//  FaceStickerMakerTests
//
//  Created by Spencer Feng on 19/4/21.
//

import Foundation
@testable import FaceStickerMaker

class MockAddStickersResponder: AddStickersResponder {
    
    var isHandleAddedStickersCalled = false
    
    func handleAddedStickers(newStickers: [FaceImage]) {
        isHandleAddedStickersCalled = true
    }
    
}
