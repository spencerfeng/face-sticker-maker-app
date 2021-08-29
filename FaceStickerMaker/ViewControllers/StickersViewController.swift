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

class StickersViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    private let viewModel: StickersViewModel
    
    private let chooseCroppedImagesViewControllerFactory: ([FaceImage]) -> ChooseCroppedImagesViewController
    private let stickersCollectionViewCellViewModelFactory: (FaceImage) -> StickersCollectionViewCellViewModel
    
    var subscriptions = Set<AnyCancellable>()
    
    private let gridSpacing: CGFloat = 20
    
    lazy private var addStickersBtn: UIButton = {
        let btnBgImg = UIImage(systemName: "plus")
        let btn = UIButton()
        btn.setImage(btnBgImg, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .regular)
        btn.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        btn.tintColor = .systemBlue
        btn.addTarget(self, action: #selector(handleAddStickersBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy private var deleteStickersBtn: UIButton = {
        let btnBgImg = UIImage(systemName: "trash")
        let btn = UIButton()
        btn.setImage(btnBgImg, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .regular)
        btn.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        btn.tintColor = .systemRed
        btn.addTarget(self, action: #selector(handleDeleteStickersBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy private var shareStickersBtn: UIButton = {
        let btnBgImg = UIImage(systemName: "square.and.arrow.up")
        let btn = UIButton()
        btn.setImage(btnBgImg, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .regular)
        btn.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        btn.tintColor = .systemBlue
        btn.addTarget(self, action: #selector(handleShareStickersBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy private var stickersSelectionActionBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        btn.addTarget(self, action: #selector(handleStickersSelectionActionBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private var blenderHUDOverlay: UIView = {
        let overlay = UIView(frame: .zero)
        overlay.isHidden = true
        overlay.backgroundColor = .systemBackground
        return overlay
    }()
    
    private var blenderHUD: AnimationView = {
        let animationView = AnimationView()
        animationView.isHidden = false
        animationView.animation = Animation.named("blender")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        return animationView
    }()
    
    lazy private var stickersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: gridSpacing, left: gridSpacing, bottom: gridSpacing, right: gridSpacing)
        layout.minimumLineSpacing = gridSpacing
        layout.minimumInteritemSpacing = gridSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray6
        return collectionView
    }()
    
    // MARK: - Initializers
    init(
        viewModel: StickersViewModel,
        chooseCroppedImagesViewControllerFactory: @escaping ([FaceImage]) -> ChooseCroppedImagesViewController,
        stickersCollectionViewCellViewModelFactory: @escaping (FaceImage) -> StickersCollectionViewCellViewModel
    ) {
        self.viewModel = viewModel
        self.chooseCroppedImagesViewControllerFactory = chooseCroppedImagesViewControllerFactory
        self.stickersCollectionViewCellViewModelFactory = stickersCollectionViewCellViewModelFactory
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupCollectionView()
        
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
            stickersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stickersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stickersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stickersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        title = "Stickers"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stickersSelectionActionBtn)
    }
    
    private func setupCollectionView() {
        stickersCollectionView.dataSource = self
        stickersCollectionView.delegate = self
        
        stickersCollectionView.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.identifier)
    }
    
    private func bindUI() {
        watchStickersChange()
        watchCurrentViewModeChange()
        watchSelectedStickersChange()
    }
    
    private func watchStickersChange() {
        viewModel
            .$stickers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.stickersCollectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    private func watchCurrentViewModeChange() {
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
                        self.viewModel.clearAllIndexPathOfSelectedStickers()
                        
                        // set the right top navigation button
                        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: self.addStickersBtn)]
                        
                    case .selecting:
                        self.blenderHUDOverlay.isHidden = true
                        
                        // set the title of the left top navigation button
                        self.stickersSelectionActionBtn.setTitle("Cancel", for: .normal)
                        
                        // set the right top navigation button
                        self.navigationItem.rightBarButtonItems = [
                            UIBarButtonItem(customView: self.deleteStickersBtn)
                            // Disable share as image feature
                            // TODO: plan to implement share sticker function
                            // so that the user is able share a sticker with
                            // another user who has this app installed
//                            UIBarButtonItem(customView: self.shareStickersBtn)
                        ]
                        
                        // disable share and delete buttons
                        self.deleteStickersBtn.isEnabled = false
                        self.shareStickersBtn.isEnabled = false
                        
                    case .blending:
                        self.blenderHUDOverlay.isHidden = false
                    }
                }
            }.store(in: &subscriptions)
    }
    
    private func watchSelectedStickersChange() {
        viewModel
            .$indexPathOfSelectedStickers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if let self = self {
                    if value.count > 0 {
                        self.deleteStickersBtn.isEnabled = true
                        self.shareStickersBtn.isEnabled = true
                    } else {
                        self.deleteStickersBtn.isEnabled = false
                        self.shareStickersBtn.isEnabled = false
                    }
                }
            }.store(in: &subscriptions)
    }
    
    @objc
    private func handleAddStickersBtnClick() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        
        self.present(imagePickerVC, animated: true, completion: nil)
    }
    
    @objc
    private func handleDeleteStickersBtnClick() {
        let alert = UIAlertController(
            title: "",
            message: "These selected stickers will be deleted from the main app as well as the iMessage app.",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Delete \(viewModel.indexPathOfSelectedStickers.count) Items", style: .destructive, handler: { _ in
            self.viewModel.removeSelectedStickers()
            self.viewModel.clearAllIndexPathOfSelectedStickers()
            self.viewModel.currentViewMode = .normal
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func handleShareStickersBtnClick() {
        let dataOfSelectedStickers = viewModel
            .getSelectedStickers()
            .compactMap { sticker in
                return sticker.image
            }
        let activityVC = UIActivityViewController(activityItems: dataOfSelectedStickers, applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (_, _, _, _) in
            self.viewModel.currentViewMode = .normal
        }
        present(activityVC, animated: true, completion: nil)
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

extension StickersViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        blenderHUDOverlay.isHidden = false
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let uncroppedCgImage = image.cgImage else {
            blenderHUDOverlay.isHidden = true
            return
        }
        
        let shouldShowStickerBackground = viewModel.shouldStickerHaveTransparentBackground()
        
        let group = DispatchGroup()
        var faceImages = [FaceImage]()
        
        group.enter()
        uncroppedCgImage.faceCrop { result in
            defer { group.leave() }
            
            switch result {
            case .success(let cgImages):
                for cgImage in cgImages {
                    group.enter()
                    DispatchQueue.global(qos: .userInitiated).async {
                        defer { group.leave() }
                        
                        var orientation = image.imageOrientation
                        
                        let uiImageRepresentation = Helper.resizeImage(
                            image: cgImage,
                            size: CGSize(width: cgImage.width, height: cgImage.height),
                            radius: 0,
                            orientation: orientation
                        )
                        
                        var cgImageToUse = cgImage
                        
                        if shouldShowStickerBackground {
                            if let imageWithoutBg = uiImageRepresentation.removeBackground(returnResult: .finalImage),
                               let cgImageRepresentation = imageWithoutBg.cgImage {
                                cgImageToUse = cgImageRepresentation
                                orientation = uiImageRepresentation.imageOrientation
                            }
                        }
                        
                        let processedImage = Helper.resizeImage(
                            image: cgImageToUse,
                            size: CGSize(width: 100, height: 100),
                            radius: Constants.STICKER_CORNER_RADIUS,
                            orientation: orientation,
                            maxSize: 500
                        )
                        
                        faceImages.append(FaceImage(id: UUID().uuidString, image: processedImage.pngData()))
                    }
                }
                return
            case .notFound, .failure:
                return
            }
        }
        
        group.notify(queue: .main) {
            if !faceImages.isEmpty {
                let chooseCroppedImagesVC = self.chooseCroppedImagesViewControllerFactory(faceImages)
                self.present(chooseCroppedImagesVC, animated: true, completion: nil)
            }
            
            self.blenderHUDOverlay.isHidden = true
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
        let stickersCollectionViewCellVM = stickersCollectionViewCellViewModelFactory(viewModel.stickers[indexPath.row])
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
                    viewModel.removeItemFromSelectedStickers(item: indexPath)
                } else {
                    viewModel.insertItemToSelectedStickers(item: indexPath)
                }
            }
        }
    }
}
