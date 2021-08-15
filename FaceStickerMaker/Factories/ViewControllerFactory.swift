//
//  ViewControllerFactory.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 28/3/21.
//

import Foundation

protocol ViewControllerFactory {
    func makeMainTabViewController() -> MainTabViewController
    func makeStickersViewController() -> StickersViewController
    func makeChooseCroppedImagesViewController(with faceImages: [FaceImage]) -> ChooseCroppedImagesViewController
}
