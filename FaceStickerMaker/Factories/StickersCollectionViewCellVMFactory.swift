//
//  StickersCollectionViewCellVMFactory.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 29/3/21.
//

import Foundation

protocol StickersCollectionViewCellVMFactory {
    func makeStickersCollectionViewCellVMFactory(for sticker: FaceImage) -> StickersCollectionViewCellViewModel
}
