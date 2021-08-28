//
//  AppDependencyContainer.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 5/5/21.
//

import UIKit

class AppDependencyContainer {
    
    let sharedStickerService: StickerService
    let sharedStickersViewModel: StickersViewModel
    
    init() {
        let stickerService = StickerServiceImpl()
        
        func makeStickersViewModel() -> StickersViewModel {
            return StickersViewModel(stickerService: stickerService)
        }
        
        self.sharedStickerService = stickerService
        self.sharedStickersViewModel = makeStickersViewModel()
    }
    
    // MARK: - MainTabViewController
    // Factories needed to create a MainTabViewController
    
    func makeMainTabViewController() -> MainTabViewController {
        let stickersViewControllerFactory = {
            return self.makeStickersViewController()
        }
        
        let settingsViewControllerFactory = {
            return self.makeSettingsViewController()
        }
        
        return MainTabViewController(
            stickersViewControllerFactory: stickersViewControllerFactory,
            settingsViewControllerFactory: settingsViewControllerFactory
        )
    }
    
    // MARK: - StickersViewController
    // Factories needed to create a StickersViewController
    
    func makeStickersViewController() -> StickersViewController {
        let chooseCroppedImagesViewControllerFactory = { (croppedImages: [FaceImage]) in
            return self.makeChooseCroppedImagesViewController(croppedImages: croppedImages)
        }
        
        let stickersCollectionViewCellViewModelFactory = { (sticker: FaceImage) in
            return self.makeStickersCollectionViewCellViewModel(sticker: sticker)
        }
        
        return StickersViewController(
            viewModel: self.sharedStickersViewModel,
            chooseCroppedImagesViewControllerFactory: chooseCroppedImagesViewControllerFactory,
            stickersCollectionViewCellViewModelFactory: stickersCollectionViewCellViewModelFactory
        )
    }
    
    func makeStickersCollectionViewCellViewModel(sticker: FaceImage) -> StickersCollectionViewCellViewModel {
        return StickersCollectionViewCellViewModel(sticker: sticker)
    }
    
    // MARK: - ChooseCroppedImagesViewController
    // Factories needed to create a ChooseCroppedImagesViewController
    
    func makeChooseCroppedImagesViewController(croppedImages: [FaceImage]) -> ChooseCroppedImagesViewController {
        let chooseCroppedImagesDependencyContainer = ChooseCroppedImagesDependencyContainer(
            appDependencyContainer: self,
            croppedImages: croppedImages
        )
        
        return chooseCroppedImagesDependencyContainer.makeChooseCroppedImagesViewController()
    }
    
    // MARK: - SettingsViewController
    // Factories needed to create a SettingsViewController
    
    func makeSettingsViewController() -> SettingsViewController {
        let settingsViewModel = self.makeSettingsViewModel()
        
        let transparentStickerBackgroundSettingViewModelFactory = {
            return self.makeTransparentStickerBackgroundSettingViewModel()
        }
        
        return SettingsViewController(
            viewModel: settingsViewModel,
            transparentStickerBackgroundSettingViewModelFactory: transparentStickerBackgroundSettingViewModelFactory
        )
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel()
    }
    
    func makeSettingsService() -> SettingsService {
        return SettingsServiceImpl()
    }
    
    func makeTransparentStickerBackgroundSettingViewModel() -> TransparentStickerBackgroundSettingViewModel {
        let settingsService = makeSettingsService()
        return TransparentStickerBackgroundSettingViewModel(settingsService: settingsService)
    }
    
}
