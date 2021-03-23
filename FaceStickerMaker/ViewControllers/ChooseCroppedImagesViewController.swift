//
//  ChooseCroppedImagesViewController.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 23/3/21.
//

import Foundation
import UIKit

class ChooseCroppedImagesViewController: UIViewController {
    
    // MARK: - Properties
    // View model
    var viewModel: ChooseCroppedImagesViewModel
    
    // UI components
    var topNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        
        navigationBar.backgroundColor = .white
        navigationBar.isTranslucent = false
        
        return navigationBar
    }()
    
    var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        return btn
    }()
    
    var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        return btn
    }()
    
    // MARK: - Initializers
    init(viewModel: ChooseCroppedImagesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        cancelBtn.addTarget(self, action: #selector(handleCancelBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(handleSaveBtnClick), for: .touchUpInside)
        
        item.leftBarButtonItem = UIBarButtonItem(customView: cancelBtn)
        item.rightBarButtonItem = UIBarButtonItem(customView: saveBtn)
        
        topNavigationBar.items = [item]
    }
    
    @objc
    private func handleCancelBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func handleSaveBtnClick() {
        dismiss(animated: true, completion: nil)
    }
}
