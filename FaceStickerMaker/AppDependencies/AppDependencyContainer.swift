//
//  AppDependencyContainer.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 5/5/21.
//

import UIKit

class AppDependencyContainer {
    let stickerService = StickerServiceImpl()
    lazy var stickersVM = StickersViewModel(stickerService: stickerService)
}

extension AppDependencyContainer: ViewControllerFactory {
    func makeMainTabViewController() -> MainTabViewController {
        return MainTabViewController(factory: self)
    }
    
    func makeStickersViewController() -> StickersViewController {
        return StickersViewController(viewModel: stickersVM, factory: self)
    }
    
    func makeChooseCroppedImagesViewController(with faceImages: [FaceImage]) -> ChooseCroppedImagesViewController {
        return ChooseCroppedImagesViewController(faceImages: faceImages, factory: self)
    }
    
    func makeSettingsViewController() -> UINavigationController {
        return UINavigationController(rootViewController: SettingsViewController())
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
