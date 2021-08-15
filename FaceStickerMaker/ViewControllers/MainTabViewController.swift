//
//  MainTabViewController.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 15/8/21.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    typealias Factory = ViewControllerFactory
    
    // MARK: - Properties
    private let factory: Factory
    
    // MARK: - Initialisers
    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    // MARK: - Helpers
    private func configureViewControllers() {
        let home = factory.makeStickersViewController()
        home.tabBarItem.image = UIImage(systemName: "house")
        home.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        home.tabBarItem.title = "Home"
        
        viewControllers = [home]
    }
    
}
