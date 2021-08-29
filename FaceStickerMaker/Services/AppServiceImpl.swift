//
//  AppServiceImpl.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 29/8/21.
//

import Foundation

struct AppServiceImpl: AppService {
    
    func getVersionNumber() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    func getBuildNumber() -> String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
}
