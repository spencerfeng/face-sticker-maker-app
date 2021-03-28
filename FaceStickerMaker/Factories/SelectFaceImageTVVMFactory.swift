//
//  SelectFaceImageTVVMFactory.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 28/3/21.
//

import Foundation

protocol SelectFaceImageTVVMFactory {
    func makeSelectFaceImageTVVM(for faceImage: FaceImage) -> SelectFaceImageTVViewModel
}
