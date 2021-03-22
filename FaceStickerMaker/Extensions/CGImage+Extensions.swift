//
//  CGImage+Extensions.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 22/3/21.
//

import Foundation
import Vision

public extension CGImage {
    @available(iOS 11.0, *)
    func faceCrop(_ completion: @escaping (FaceCropResult) -> Void) {
        let req = VNDetectFaceRectanglesRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let results = request.results else {
                completion(.notFound)
                return
            }
            
            var faces: [VNFaceObservation] = []
            for result in results {
                guard let face = result as? VNFaceObservation else { continue }
                faces.append(face)
            }
            
            var faceImages: [CGImage] = []
            for face in faces {
                let w = face.boundingBox.width * CGFloat(self.width)
                let h = face.boundingBox.height * CGFloat(self.height)
                let x = face.boundingBox.origin.x * CGFloat(self.width)
                let y = (1 - face.boundingBox.origin.y) * CGFloat(self.height) - h
                
                let faceContainer = CGRect(x: x, y: y, width: w, height: h)
                
                guard let faceImage = self.cropping(to: faceContainer) else { continue }
                faceImages.append(faceImage)
            }
            
            
            completion(.success(faceImages))
        }
        
        do {
            try VNImageRequestHandler(cgImage: self, options: [:]).perform([req])
        } catch let error {
            completion(.failure(error))
        }
    }
}

public enum FaceCropResult {
    case success([CGImage])
    case notFound
    case failure(Error)
}

