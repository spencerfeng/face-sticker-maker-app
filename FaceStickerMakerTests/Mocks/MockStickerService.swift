//
//  MockStickerService.swift
//  FaceStickerMakerTests
//
//  Created by Spencer Feng on 19/4/21.
//

import Foundation
import UIKit
@testable import FaceStickerMaker

class MockStickerService: StickerService {
    
    var allStickers: [FaceImage]
    
    init() {
        let bundle = Bundle(for: MockStickerService.self)
        let imageNames = [
            "stickerImg1",
            "stickerImg2",
            "stickerImg3",
            "stickerImg4",
            "stickerImg5"
        ]
        
        self.allStickers = imageNames.map { imageName in
            return FaceImage(
                id: imageName,
                image: UIImage(named: imageName, in: bundle, compatibleWith: nil)!.pngData()
            )
        }
    }
    
    func addStickers(stickers: [FaceImage]) -> [FaceImage] {
        return [allStickers[0]]
    }
    
    func getStickers() -> [FaceImage] {
        return allStickers
    }
    
    func removeStickers(stickers: [FaceImage]) -> [String] {
        return ["stickerImg1"]
    }
    
}
