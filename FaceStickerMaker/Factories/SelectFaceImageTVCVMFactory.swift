//
//  SelectFaceImageTVCVMFactory.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 29/3/21.
//

import Foundation

protocol SelectFaceImageTVCVMFactory {
    func makeSelectFaceImageTVCVM(for faceImage: FaceImage, with selectFaceImageToggleResponder: SelectFaceImageToggleResponder) -> SelectFaceImageTVCViewModel
}
