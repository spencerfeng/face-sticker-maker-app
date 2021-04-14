//
//  StickerService.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 27/3/21.
//

import Foundation

protocol StickerService {
    func addStickers(stickers: [FaceImage]) -> [FaceImage]
    func getStickers() -> [FaceImage]
    func removeStickers(stickers: [FaceImage]) -> [String]
}
