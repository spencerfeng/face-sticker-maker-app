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
    
    var stickerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
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
            stickerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setupViews() {
        contentView.addSubview(stickerImageView)
    }
    
    public func configureCell(viewModel: StickersCollectionViewCellViewModel) {
        if let imageData = viewModel.sticker.image {
            let uiImage = UIImage(data: imageData) ?? UIImage()
            stickerImageView.image = uiImage
        } else {
            stickerImageView.image = UIImage()
        }
    }
    
}
