//
//  ChooseCroppedImagesDependencyContainer.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 28/8/21.
//

import UIKit

class ChooseCroppedImagesDependencyContainer {
    
    // From parent container
    let sharedStickerService: StickerService
    let sharedStickersViewModel: StickersViewModel
    
    let sharedChooseCroppedImagesViewModel: ChooseCroppedImagesViewModel
    
    init(appDependencyContainer: AppDependencyContainer, croppedImages: [FaceImage]) {
        self.sharedStickerService = appDependencyContainer.sharedStickerService
        self.sharedStickersViewModel = appDependencyContainer.sharedStickersViewModel
        
        func makeChooseCroppedImagesViewModel(croppedImages: [FaceImage]) -> ChooseCroppedImagesViewModel {
            return ChooseCroppedImagesViewModel(
                croppedImages: croppedImages,
                stickerService: appDependencyContainer.sharedStickerService,
                addStickersResponder: appDependencyContainer.sharedStickersViewModel
            )
        }
        
        self.sharedChooseCroppedImagesViewModel = makeChooseCroppedImagesViewModel(croppedImages: croppedImages)
    }
    
    func makeChooseCroppedImagesViewController() -> ChooseCroppedImagesViewController {
        let selectFaceImageTVCViewModelFactory = { (faceImage: FaceImage) in
            return self.makeSelectFaceImageTVCViewModel(for: faceImage)
        }
        
        return ChooseCroppedImagesViewController(
            viewModel: self.sharedChooseCroppedImagesViewModel,
            selectFaceImageTVCViewModelFactory: selectFaceImageTVCViewModelFactory
        )
    }
    
    func makeSelectFaceImageTVCViewModel(for faceImage: FaceImage) -> SelectFaceImageTVCViewModel {
        return SelectFaceImageTVCViewModel(faceImage: faceImage, selectFaceImageToggleResponder: self.sharedChooseCroppedImagesViewModel)
    }
    
    func makeChooseCroppedImagesViewModel(croppedImages: [FaceImage]) -> ChooseCroppedImagesViewModel {
        return ChooseCroppedImagesViewModel(
            croppedImages: croppedImages,
            stickerService: self.sharedStickerService,
            addStickersResponder: self.sharedStickersViewModel
        )
    }
    
}
