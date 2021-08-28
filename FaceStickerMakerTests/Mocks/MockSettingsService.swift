//
//  MockSettingsService.swift
//  FaceStickerMakerTests
//
//  Created by Spencer Feng on 28/8/21.
//

import Foundation
@testable import FaceStickerMaker

class MockSettingsService: SettingsService {
    
    func getTransparentStickerBackgroundSetting() -> Bool {
        return true
    }
    
    func setTransparentStickerBackgroundSetting(_ value: Bool) {}
    
}
