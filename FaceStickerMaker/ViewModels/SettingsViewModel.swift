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

struct SettingsViewModel {
    
    var appVersionBuildInfo: String?
    let settings: [SettingsGroup]
    
    init(appService: AppService) {
        let transparentStickerBackgroundSetting = Setting(
            type: UserSettingType.TransparentStickerBackground,
            label: "Transparent background"
        )
        let generalSettingsGroup = SettingsGroup(name: "Sticker", settings: [transparentStickerBackgroundSetting])
        self.settings = [generalSettingsGroup]
        
        let versionNumber = appService.getVersionNumber()
        let buildNumber = appService.getBuildNumber()
        
        if let versionNumber = versionNumber, let buildNumber = buildNumber {
            self.appVersionBuildInfo = "Version \(versionNumber)(\(buildNumber))"
        }
    }
    
}
