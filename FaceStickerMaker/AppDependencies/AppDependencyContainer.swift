//
//  AppDependencyContainer.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 5/5/21.
//

import Foundation

class AppDependencyContainer {
    let stickerService = StickerServiceImpl()
    lazy var stickersVM = StickersViewModel(stickerService: stickerService)
}

extension AppDependencyContainer: ViewControllerFactory {
    func makeStickersViewController() -> StickersViewController {
        return StickersViewController(viewModel: stickersVM, factory: self)
    }
    
    func makeChooseCroppedImagesViewController(with faceImages: [FaceImage]) -> ChooseCroppedImagesViewController {
        return ChooseCroppedImagesViewController(faceImages: faceImages, factory: self)
    }
}

extension AppDependencyContainer: SelectFaceImageTVCVMFactory {
    func makeSelectFaceImageTVCVM(for faceImage: FaceImage, with selectFaceImageToggleResponder: SelectFaceImageToggleResponder) -> SelectFaceImageTVCViewModel {
        return SelectFaceImageTVCViewModel(faceImage: faceImage, selectFaceImageToggleResponder: selectFaceImageToggleResponder)
    }
}

extension AppDependencyContainer: StickersCollectionViewCellVMFactory {
    func makeStickersCollectionViewCellVMFactory(for sticker: FaceImage) -> StickersCollectionViewCellViewModel {
        return StickersCollectionViewCellViewModel(sticker: sticker)
    }
}

extension AppDependencyContainer: ChooseCroppedImagesViewModelFactory {
    func makeChooseCroppedImagesViewModel() -> ChooseCroppedImagesViewModel {
        return ChooseCroppedImagesViewModel(stickerService: stickerService, addStickersResponder: stickersVM)
    }
}
