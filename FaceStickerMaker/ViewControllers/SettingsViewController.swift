//
//  SettingsViewController.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 21/8/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Life Cycles
    override func loadView() {
        super.loadView()
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - UI
    
    // MARK: - Layout
    
}
