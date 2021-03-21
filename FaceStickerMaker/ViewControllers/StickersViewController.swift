//
//  StickersViewController.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 20/3/21.
//

import Foundation
import UIKit

class StickersViewController: UIViewController {
    
    // MARK: - Properties
    // UI components
    var topNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        
        navigationBar.backgroundColor = .white
        navigationBar.isTranslucent = false
        
        return navigationBar
    }()
    
    var addStickersBtn: UIButton = {
        let btnBgImg = UIImage(systemName: "plus")
        let btn = UIButton()
        btn.setImage(btnBgImg, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .regular)
        btn.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return btn
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        setupNavigationBarItems()
        
        view.addSubview(topNavigationBar)
        topNavigationBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            topNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topNavigationBar.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            topNavigationBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            topNavigationBar.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
    
    // MARK: - Other Methods
    private func setupNavigationBarItems() {
        let item = UINavigationItem()
        
        item.rightBarButtonItem = UIBarButtonItem(customView: addStickersBtn)
        item.title = "Stickers"
        
        topNavigationBar.items = [item]
    }
}
