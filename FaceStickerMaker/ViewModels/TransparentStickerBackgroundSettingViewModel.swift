//
//  TransparentStickerBackgroundSettingViewModel.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 22/8/21.
//

import Foundation

class TransparentStickerBackgroundSettingViewModel {
    
    @Published var labelText: String = ""
    @Published var isOn: Bool = false {
        didSet {
            setTransparentStickerBackgroundSetting(isOn)
        }
    }
    
    private let settingsService: SettingsService
    
    init(settingsService: SettingsService) {
        self.settingsService = settingsService
        self.isOn = settingsService.getTransparentStickerBackgroundSetting()
    }
    
    func getTransparentStickerBackgroundSetting() -> Bool {
        return settingsService.getTransparentStickerBackgroundSetting()
    }
    
    private func setTransparentStickerBackgroundSetting(_ value: Bool) {
        settingsService.setTransparentStickerBackgroundSetting(value)
    }
}
