//
//  AppService.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 29/8/21.
//

import Foundation

protocol AppService {
    func getVersionNumber() -> String?
    func getBuildNumber() -> String?
}
