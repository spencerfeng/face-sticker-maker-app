//
//  SelectFaceImageTableViewCell.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 23/3/21.
//

import Foundation
import UIKit
import Combine

class SelectFaceImageTableViewCell: UITableViewCell {
    
    static let identifier = "SelectFaceImageTableViewCell"
    
    // MARK: - Properties
    var viewModel: SelectFaceImageTVCViewModel?
    
    var subscriptions = Set<AnyCancellable>()
    
    var faceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var actionBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(faceImageView)
        contentView.addSubview(actionBtn)
        
        actionBtn.addTarget(self, action: #selector(handleActionBtnClick), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            faceImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            faceImageView.widthAnchor.constraint(equalToConstant: 50),
            faceImageView.heightAnchor.constraint(equalToConstant: 50),
            faceImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            actionBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            actionBtn.heightAnchor.constraint(equalToConstant: 40),
            actionBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actionBtn.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - Other Methods
    public func configureCell(viewModel: SelectFaceImageTVCViewModel) {
        // configure faceImageView
        if let imageData = viewModel.faceImage.image {
            let uiImage = UIImage(data: imageData) ?? UIImage()
            faceImageView.image = uiImage
        } else {
            faceImageView.image = UIImage()
        }
        
        self.viewModel = viewModel
        
        viewModel
            .$willKeep
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value {
                    self?.actionBtn.setTitle("Discard", for: .normal)
                    self?.actionBtn.backgroundColor = .red
                } else {
                    self?.actionBtn.setTitle("Keep", for: .normal)
                    self?.actionBtn.backgroundColor = .green
                }
            }.store(in: &subscriptions)
    }
    
    @objc
    private func handleActionBtnClick() {
        self.viewModel?.toggleWillKeepState()
    }
}
