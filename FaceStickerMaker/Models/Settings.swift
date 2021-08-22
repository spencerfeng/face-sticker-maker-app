//
//  Settings.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 22/8/21.
//

import Foundation

struct Setting {
    let type: UserSettingType
    let label: String
}

struct SettingsGroup {
    let name: String
    let settings: [Setting]
}
