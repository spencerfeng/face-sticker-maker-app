//
//  StickersViewController.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 20/3/21.
//

import Foundation
import UIKit
import PhotosUI

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
    
    var stickersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        return collectionView
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        setupNavigationBarItems()
        
        view.addSubview(topNavigationBar)
        topNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stickersCollectionView)
        stickersCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            topNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topNavigationBar.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            topNavigationBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            topNavigationBar.heightAnchor.constraint(equalToConstant: 44.0),
            
            stickersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickersCollectionView.topAnchor.constraint(equalTo: topNavigationBar.bottomAnchor),
            stickersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Other Methods
    private func setupNavigationBarItems() {
        let item = UINavigationItem()
        
        addStickersBtn.addTarget(self, action: #selector(handleAddStickersBtnClick), for: .touchUpInside)
        
        item.rightBarButtonItem = UIBarButtonItem(customView: addStickersBtn)
        item.title = "Stickers"
        
        topNavigationBar.items = [item]
    }
    
    @objc
    private func handleAddStickersBtnClick() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 10
        
        let photoPickerVC = PHPickerViewController(configuration: configuration)
        photoPickerVC.delegate = self
        
        self.present(photoPickerVC, animated: true, completion: nil)
    }
}

extension StickersViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let group = DispatchGroup()
        var faceImages = [FaceImage]()
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                    defer { group.leave() }
                    
                    guard let image = image as? UIImage, let uncroppedCgImage = image.cgImage else { return }
                    
                    group.enter()
                    uncroppedCgImage.faceCrop { result in
                        defer { group.leave() }
                        
                        switch result {
                        case .success(let cgImages):
                            for cgImage in cgImages {
                                let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: image.imageOrientation)
                                
                                faceImages.append(FaceImage(id: UUID().uuidString, image: uiImage.pngData()))
                            }
                            return
                        case .notFound, .failure:
                            return
                        }
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            if !faceImages.isEmpty {
                let stickerService = StickerService()
                let stickerRepository = StickerRepository(stickerService: stickerService)
                
                let chooseCroppedImagesVM = ChooseCroppedImagesViewModel(stickerRepository: stickerRepository)
                chooseCroppedImagesVM.croppedImages = faceImages
                
                let chooseCroppedImagesVC = ChooseCroppedImagesViewController(viewModel: chooseCroppedImagesVM)
                self.present(chooseCroppedImagesVC, animated: true, completion: nil)
            }
        }
    }
}
