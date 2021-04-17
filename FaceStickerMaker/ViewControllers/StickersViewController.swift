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
import Lottie

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
    
    var customNavigationItem: UINavigationItem = {
        return UINavigationItem()
    }()
    
    var addStickersBtn: UIButton = {
        let btnBgImg = UIImage(systemName: "plus")
        let btn = UIButton()
        btn.setImage(btnBgImg, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .regular)
        btn.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return btn
    }()
    
    var deleteStickersBtn: UIButton = {
        let btnBgImg = UIImage(systemName: "trash")
        let btn = UIButton()
        btn.setImage(btnBgImg, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .regular)
        btn.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return btn
    }()
    
    var stickersSelectionActionBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.blue, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        return btn
    }()
    
    var blenderHUDOverlay: UIView = {
        let overlay = UIView(frame: .zero)
        overlay.isHidden = true
        overlay.backgroundColor = .blue
        return overlay
    }()
    
    var blenderHUD: AnimationView = {
        let animationView = AnimationView()
        animationView.isHidden = false
        animationView.animation = Animation.named("blender")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        return animationView
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
        
        view.addSubview(blenderHUDOverlay)
        blenderHUDOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        blenderHUDOverlay.addSubview(blenderHUD)
        blenderHUD.translatesAutoresizingMaskIntoConstraints = false
        
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
            stickersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blenderHUDOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blenderHUDOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blenderHUDOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            blenderHUDOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blenderHUD.widthAnchor.constraint(equalToConstant: 250),
            blenderHUD.heightAnchor.constraint(equalToConstant: 250),
            blenderHUD.centerXAnchor.constraint(equalTo: blenderHUDOverlay.centerXAnchor),
            blenderHUD.centerYAnchor.constraint(equalTo: blenderHUDOverlay.centerYAnchor)
        ])
    }
    
    // MARK: - Other Methods
    private func setupNavigationBarItems() {
        addStickersBtn.addTarget(self, action: #selector(handleAddStickersBtnClick), for: .touchUpInside)
        deleteStickersBtn.addTarget(self, action: #selector(handleDeleteStickersBtnClick), for: .touchUpInside)
        stickersSelectionActionBtn.addTarget(self, action: #selector(handleStickersSelectionActionBtnClick), for: .touchUpInside)
        
        customNavigationItem.leftBarButtonItem = UIBarButtonItem(customView: stickersSelectionActionBtn)
        customNavigationItem.title = "Stickers"
        
        topNavigationBar.items = [customNavigationItem]
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
        
        viewModel
            .$currentViewMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if let self = self {
                    switch value {
                    case .normal:
                        self.blenderHUDOverlay.isHidden = true
                        
                        // set the title of the left top navigation button
                        self.stickersSelectionActionBtn.setTitle("Select", for: .normal)
                        
                        // clear selected stickers
                        self.viewModel.indexPathOfSelectedStickers.forEach { indexPath in
                            let cell = self.stickersCollectionView.cellForItem(at: indexPath) as? StickerCollectionViewCell
                            if let cell = cell {
                                cell.viewModel?.toggleSelectedState()
                            }
                        }
                        self.viewModel.indexPathOfSelectedStickers.removeAll()
                        
                        // set the right top navigation button
                        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.addStickersBtn)
                        
                    case .selecting:
                        self.blenderHUDOverlay.isHidden = true
                        
                        // set the title of the left top navigation button
                        self.stickersSelectionActionBtn.setTitle("Cancel", for: .normal)
                        
                        // set the right top navigation button
                        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.deleteStickersBtn)
                        
                        // disable delete stickers button
                        self.viewModel.canDeleteStickers = false
                    
                    case .blending:
                        self.blenderHUDOverlay.isHidden = false
                    }
                }
            }.store(in: &subscriptions)
        
        viewModel
            .$canDeleteStickers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if let self = self {
                    if value {
                        self.deleteStickersBtn.isEnabled = true
                    } else {
                        self.deleteStickersBtn.isEnabled = false
                    }
                }
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
    
    @objc
    private func handleDeleteStickersBtnClick() {
        viewModel.removeSelectedStickers()
        viewModel.indexPathOfSelectedStickers.removeAll()
        viewModel.currentViewMode = .normal
    }
    
    @objc
    private func handleStickersSelectionActionBtnClick() {
        if viewModel.currentViewMode == .normal {
            viewModel.currentViewMode = .selecting
        } else if viewModel.currentViewMode == .selecting {
            viewModel.currentViewMode = .normal
        }
        
    }
}

extension StickersViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        blenderHUDOverlay.isHidden = false
        
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
                                let uiImage = Helper.resizeImage(
                                    image: cgImage,
                                    size: CGSize(width: 100, height: 100),
                                    radius: 5,
                                    orientation: image.imageOrientation,
                                    maxSize: 500
                                )
                                
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
            self.blenderHUDOverlay.isHidden = true
            
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

extension StickersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.currentViewMode == .selecting {
            if let cell = collectionView.cellForItem(at: indexPath) as? StickerCollectionViewCell {
                cell.viewModel?.toggleSelectedState()
                
                if viewModel.indexPathOfSelectedStickers.contains(indexPath) {
                    viewModel.indexPathOfSelectedStickers.remove(indexPath)
                } else {
                    viewModel.indexPathOfSelectedStickers.insert(indexPath)
                }
                
                if viewModel.indexPathOfSelectedStickers.count > 0 {
                    viewModel.canDeleteStickers = true
                } else {
                    viewModel.canDeleteStickers = false
                }
            }
        }
    }
}
