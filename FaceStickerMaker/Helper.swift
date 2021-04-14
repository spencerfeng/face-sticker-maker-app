//
//  Helper.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 27/3/21.
//

import Foundation
import UIKit

class Helper {
    static func filePath(forKey key: String, forFormat format: String) -> URL? {
        guard let documentURL = FileManager().containerURL(forSecurityApplicationGroupIdentifier: Constants.APP_GROUP_NAME) else { return nil }
            
        return documentURL.appendingPathComponent("\(key).\(format)")
    }
    
    static func resizeImage(image: CGImage, size: CGSize, radius: CGFloat = 0, orientation: UIImage.Orientation = .up) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            let rounded = UIBezierPath(roundedRect: rect, cornerRadius: radius)
            rounded.addClip()
            UIImage(cgImage: image, scale: 1, orientation: orientation).draw(in: rect)
        }
            
        return resizedImage
    }
}
