//
//  Helper.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 27/3/21.
//

import Foundation
import UIKit

class Helper {
    static func resizeImage(image: CGImage, size: CGSize, radius: CGFloat = 0, orientation: UIImage.Orientation = .up, maxSize: Double, decrementStep: CGFloat = 10.0) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            let rounded = UIBezierPath(roundedRect: rect, cornerRadius: radius)
            rounded.addClip()
            UIImage(cgImage: image, scale: 1, orientation: orientation).draw(in: rect)
        }
        
        guard let imgData = resizedImage.pngData() else { fatalError("Image cannot be converted to Data") }
        
        let imgSize = Double(imgData.count) / 1000.0
        
        if imgSize < maxSize {
            return resizedImage
        }
            
        return resizeImage(
            image: image,
            size: CGSize(
                width: size.width - decrementStep,
                height: size.height - decrementStep
            ),
            radius: radius,
            orientation: orientation,
            maxSize: maxSize,
            decrementStep: decrementStep
        )
    }
}
