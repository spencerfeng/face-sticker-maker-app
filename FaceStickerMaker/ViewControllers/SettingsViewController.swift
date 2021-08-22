//
//  SettingsViewController.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 21/8/21.
//

import UIKit

class SettingsViewController: UIViewController {
    typealias Factory = SettingsViewModelFactory & TransparentStickerBackgroundSettingViewModelFactory
    
    // MARK: - Properties
    private let factory: Factory
    
    private let settingsVM: SettingsViewModel
    
    lazy private var settingsTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(
            TransparentStickerBackgroundSettingCell.self,
            forCellReuseIdentifier: UserSettingType.TransparentStickerBackground.rawValue)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemGray6
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Initialisers
    init(factory: Factory) {
        self.factory = factory
        self.settingsVM = factory.makeSettingsViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    override func loadView() {
        super.loadView()
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupSettingsTable()
    }
    
    // MARK: - UI
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Layout
    private func setupSettingsTable() {
        view.addSubview(settingsTable)
        settingsTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsVM.settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsVM.settings[section].settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settingsVM.settings[indexPath.section].settings[indexPath.row]
        
        switch setting.type {
        case .TransparentStickerBackground:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: UserSettingType.TransparentStickerBackground.rawValue,
                    for: indexPath) as? TransparentStickerBackgroundSettingCell
            else { fatalError("TransparentStickerBackgroundSettingCell is not found") }
            
            let transparentStickerBackgroundSettingVM = factory.makeTransparentStickerBackgroundSettingViewModel()
            cell.configureCell(viewModel: transparentStickerBackgroundSettingVM)
            transparentStickerBackgroundSettingVM.labelText = setting.label
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsVM.settings[section].name
    }
}
