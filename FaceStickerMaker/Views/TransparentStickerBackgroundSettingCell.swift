//
//  TransparentStickerBackgroundSettingCell.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 21/8/21.
//

import UIKit
import Combine

class TransparentStickerBackgroundSettingCell: UITableViewCell {
    
    // MARK: - Properties
    var vm: TransparentStickerBackgroundSettingViewModel?
    
    var subscriptions = Set<AnyCancellable>()
    
    let settingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var settingSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(settingChanged), for: .valueChanged)
        return toggle
    }()
    
    // MARK: - Initialisers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func configureLayout() {
        contentView.addSubview(settingLabel)
        contentView.addSubview(settingSwitch)
        
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        settingSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: settingLabel.leadingAnchor, constant: -20),
            contentView.topAnchor.constraint(equalTo: settingSwitch.topAnchor, constant: -10),
            contentView.bottomAnchor.constraint(equalTo: settingSwitch.bottomAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: settingSwitch.trailingAnchor, constant: 20),
            
            settingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Selectors
    @objc private func settingChanged(switchState: UISwitch) {
        vm?.isOn = switchState.isOn
    }
    
    // MARK: - Helpers
    func configureCell(viewModel: TransparentStickerBackgroundSettingViewModel) {
        vm = viewModel
        
        viewModel
            .$labelText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.settingLabel.text = value
            }
            .store(in: &subscriptions)
        
        viewModel
            .$isOn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.settingSwitch.setOn(value, animated: false)
            }
            .store(in: &subscriptions)
    }
    
}
