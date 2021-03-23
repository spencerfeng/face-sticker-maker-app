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
    
    let tableView = UITableView()
    
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
        setupTableView()
        
        view.addSubview(topNavigationBar)
        topNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            topNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topNavigationBar.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            topNavigationBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            topNavigationBar.heightAnchor.constraint(equalToConstant: 44.0),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topNavigationBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cropped-image-selection-cell")
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

// MARK: UITableViewDataSource protocol
extension ChooseCroppedImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.croppedImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cropped-image-selection-cell", for: indexPath)
        cell.textLabel?.text = viewModel.croppedImages[indexPath.row].id
        return cell
    }
}
