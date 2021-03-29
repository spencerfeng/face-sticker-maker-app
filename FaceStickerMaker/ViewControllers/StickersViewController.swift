//
//  StickersViewController.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 20/3/21.
//

import Foundation
import UIKit
import PhotosUI
import Combine

class StickersViewController: UIViewController {
    
    typealias Factory = ViewControllerFactory & StickersCollectionViewCellVMFactory
    
    // MARK: - Properties
    private let viewModel: StickersViewModel
    
    private let factory: Factory
    
    var subscriptions = Set<AnyCancellable>()
    
    private let gridSpacing: CGFloat = 20
    
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
    
    lazy var stickersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: gridSpacing, left: gridSpacing, bottom: gridSpacing, right: gridSpacing)
        layout.minimumLineSpacing = gridSpacing
        layout.minimumInteritemSpacing = gridSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        return collectionView
    }()
    
    // MARK: - Initializers
    init(viewModel: StickersViewModel, factory: Factory) {
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
        setupCollectionView()
        
        view.addSubview(topNavigationBar)
        topNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stickersCollectionView)
        stickersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        viewModel.getStickers()
        
        bindUI()
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
    
    private func setupCollectionView() {
        stickersCollectionView.dataSource = self
        stickersCollectionView.delegate = self
        
        stickersCollectionView.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.identifier)
    }
    
    private func bindUI() {
        viewModel
            .$stickers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.stickersCollectionView.reloadData()
            }.store(in: &subscriptions)
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
                let chooseCroppedImagesVC = self.factory.makeChooseCroppedImagesViewController(with: faceImages)
                self.present(chooseCroppedImagesVC, animated: true, completion: nil)
            }
        }
    }
}

extension StickersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.stickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = stickersCollectionView.dequeueReusableCell(
            withReuseIdentifier: StickerCollectionViewCell.identifier,
            for: indexPath
        ) as? StickerCollectionViewCell
        
        guard let cell = collectionViewCell else { return UICollectionViewCell() }
        let stickersCollectionViewCellVM = factory.makeStickersCollectionViewCellVMFactory(for: viewModel.stickers[indexPath.row])
        cell.configureCell(viewModel: stickersCollectionViewCellVM)
        
        return cell
    }
}

extension StickersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 5
        let spacingBetweenCells = gridSpacing
        
        let totalSpacing = (2 * gridSpacing) + (numberOfItemsPerRow - 1) * spacingBetweenCells
        
        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
}
