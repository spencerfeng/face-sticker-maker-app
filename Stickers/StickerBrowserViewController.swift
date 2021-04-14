//
//  StickerBrowserViewController.swift
//  Stickers
//
//  Created by Spencer Feng on 14/4/21.
//

import UIKit
import Messages

class StickerBrowserViewController: MSStickerBrowserViewController {
    var stickers = [MSSticker]()
    
    override var stickerSize: MSStickerSize {
        get {
            return .small
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStickers()
    }
    
    func loadStickers() {
        if let userDefaults = UserDefaults.init(suiteName: Constants.APP_GROUP_NAME) {
            let stickerIds = (userDefaults.array(forKey: Constants.USER_DEFAULTS_KEY_FOR_EXISTING_STICKERS_IDS) as? [String]) ?? [String]()
            
            for stickerId in stickerIds {
                createSticker(stickerId: stickerId)
            }
        }
    }
    
    func createSticker(stickerId: String) {
        guard let url = filePath(forKey: stickerId) else { return }
        
        do {
            let sticker = try MSSticker(contentsOfFileURL: url, localizedDescription: "Face Sticker")
            stickers.append(sticker)
        } catch {
            print(error)
        }
    }
    
    func filePath(forKey key: String) -> URL? {
        guard let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: Constants.APP_GROUP_NAME) else { return nil }
        
        return documentsDirectory.appendingPathComponent(key + ".png")
    }
}

extension StickerBrowserViewController {
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }
}
