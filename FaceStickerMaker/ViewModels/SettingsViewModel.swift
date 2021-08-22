//
//  SettingsViewModel.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 22/8/21.
//

import Foundation

enum UserSettingType: String {
    case TransparentStickerBackground
}

class SettingsViewModel {
    
    let settings: [SettingsGroup]
    
    init() {
        let transparentStickerBackgroundSetting = Setting(
            type: UserSettingType.TransparentStickerBackground,
            label: "Transparent background"
        )
        let generalSettingsGroup = SettingsGroup(name: "Sticker", settings: [transparentStickerBackgroundSetting])
        self.settings = [generalSettingsGroup]
    }
    
}
