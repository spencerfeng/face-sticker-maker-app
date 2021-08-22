//
//  SettingsService.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 22/8/21.
//

import Foundation

protocol SettingsService {
    func getTransparentStickerBackgroundSetting() -> Bool
    func setTransparentStickerBackgroundSetting(_ value: Bool)
}
