//
//  StickerCollectionViewCell.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 28/3/21.
//

import Foundation
import UIKit
import Combine

class StickerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "StickerCollectionViewCell"
    
    var viewModel: StickersCollectionViewCellViewModel?
    
    var subscriptions = Set<AnyCancellable>()
    
    var stickerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.STICKER_CORNER_RADIUS
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        let image = UIImage(systemName: "checkmark.circle.fill")
        imageView.image = image
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var stickerSelectedOverlay: UIView = {
        let overlay = UIView(frame: .zero)
        overlay.layer.cornerRadius = Constants.STICKER_CORNER_RADIUS
        overlay.isHidden = true
        overlay.backgroundColor = .white
        overlay.alpha = 0.7
        overlay.translatesAutoresizingMaskIntoConstraints = false
        
        return overlay
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            stickerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stickerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stickerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stickerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stickerSelectedOverlay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stickerSelectedOverlay.topAnchor.constraint(equalTo: contentView.topAnchor),
            stickerSelectedOverlay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stickerSelectedOverlay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkmarkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setupViews() {
        contentView.addSubview(stickerImageView)
        contentView.addSubview(stickerSelectedOverlay)
        contentView.addSubview(checkmarkImageView)
    }
    
    public func configureCell(viewModel: StickersCollectionViewCellViewModel) {
        self.viewModel = viewModel
        
        if let imageData = viewModel.sticker.image {
            let uiImage = UIImage(data: imageData) ?? UIImage()
            stickerImageView.image = uiImage
        } else {
            stickerImageView.image = UIImage()
        }
        
        viewModel
            .$isSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.stickerSelectedOverlay.isHidden = !value
                self?.checkmarkImageView.isHidden = !value
            }.store(in: &subscriptions)
    }
    
}
