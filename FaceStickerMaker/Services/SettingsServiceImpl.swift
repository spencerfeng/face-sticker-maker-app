//
//  SettingsServiceImpl.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 22/8/21.
//

import Foundation

class SettingsServiceImpl: SettingsService {
    
    private let defaults = UserDefaults.standard
    
    func getTransparentStickerBackgroundSetting() -> Bool {
        defaults.bool(forKey: UserSettingType.TransparentStickerBackground.rawValue)
    }
    
    func setTransparentStickerBackgroundSetting(_ value: Bool) {
        defaults.set(value, forKey: UserSettingType.TransparentStickerBackground.rawValue)
    }
    
}
