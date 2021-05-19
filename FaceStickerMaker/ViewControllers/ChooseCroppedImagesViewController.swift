//
//  ChooseCroppedImagesViewController.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 23/3/21.
//

import Foundation
import UIKit

class ChooseCroppedImagesViewController: UIViewController {
    typealias Factory = SelectFaceImageTVCVMFactory & ChooseCroppedImagesViewModelFactory
    
    // MARK: - Properties
    var viewModel: ChooseCroppedImagesViewModel
    
    let factory: Factory
    
    // UI components
    var topNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        
        navigationBar.backgroundColor = .systemBackground
        navigationBar.isTranslucent = true
        navigationBar.setValue(false, forKey: "hidesShadow")
        
        return navigationBar
    }()
    
    var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        return btn
    }()
    
    var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        return btn
    }()
    
    let tableView = UITableView()
    
    // MARK: - Initializers
    init(faceImages: [FaceImage], factory: Factory) {
        let viewModel = factory.makeChooseCroppedImagesViewModel()
        viewModel.croppedImages = faceImages
        self.viewModel = viewModel
        
        self.factory = factory
        
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
            // note: we do not need to set the height of topNavigationBar explicitly, since it has its inherent value
            
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
        tableView.delegate = self
        tableView.register(SelectFaceImageTableViewCell.self, forCellReuseIdentifier: SelectFaceImageTableViewCell.identifier)
    }
    
    @objc
    private func handleCancelBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func handleSaveBtnClick() {
        viewModel.saveStickers()
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource protocol
extension ChooseCroppedImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.croppedImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(
            withIdentifier: SelectFaceImageTableViewCell.identifier,
            for: indexPath) as? SelectFaceImageTableViewCell
        
        guard let cell = tableCell else { return SelectFaceImageTableViewCell() }
        let selectFaceImageTVCVM = factory.makeSelectFaceImageTVCVM(for: viewModel.croppedImages[indexPath.row], with: viewModel)
        cell.configureCell(viewModel: selectFaceImageTVCVM)
        
        return cell
    }
}

// MARK: - UITableViewDelegate protocol
extension ChooseCroppedImagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
