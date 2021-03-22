//
//  FaceImage.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 22/3/21.
//

import Foundation
import UIKit

struct FaceImage: Identifiable {
    var id: String
    var image: CGImage
    var orientation: UIImage.Orientation
}
