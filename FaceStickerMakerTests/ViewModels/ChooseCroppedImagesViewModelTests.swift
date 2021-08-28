//
//  ChooseCroppedImagesViewModelTests.swift
//  FaceStickerMakerTests
//
//  Created by Spencer Feng on 19/4/21.
//

import XCTest
@testable import FaceStickerMaker

class ChooseCroppedImagesViewModelTests: XCTestCase {
    
    var sut: ChooseCroppedImagesViewModel!
    var mockStickerService: MockStickerService!
    var mockAddStickersResponder: MockAddStickersResponder!
    
    override func setUp() {
        super.setUp()
        mockStickerService = MockStickerService()
        mockAddStickersResponder = MockAddStickersResponder()
        
        sut = ChooseCroppedImagesViewModel(
            croppedImages: mockStickerService.allStickers,
            stickerService: mockStickerService,
            addStickersResponder: mockAddStickersResponder
        )
    }
    
    override func tearDown() {
        sut = nil
        mockStickerService = nil
        mockAddStickersResponder = nil
        super.tearDown()
    }
    
    func test_user_keep_a_face_image() {
        // Given
        let faceImageToKeep = FaceImage(id: "stickerImg6")
        sut.selectedFaceImages = [FaceImage]()
        
        // When
        sut.toggleFaceImageSelection(faceImage: faceImageToKeep, selected: true)
        
        // Assert
        XCTAssertEqual(sut.selectedFaceImages.count, 1)
        XCTAssertEqual(sut.selectedFaceImages[0].id, "stickerImg6")
    }
    
    func test_user_discard_a_face_image() {
        // Given
        let faceImageToDiscard = FaceImage(id: "stickerImg6")
        sut.selectedFaceImages = [faceImageToDiscard]
        
        // When
        sut.toggleFaceImageSelection(faceImage: faceImageToDiscard, selected: false)
        
        // Assert
        XCTAssertEqual(sut.selectedFaceImages.count, 0)
    }
    
    func test_save_stickers() {
        // when
        sut.saveStickers()
        
        // Assert
        XCTAssert(mockAddStickersResponder!.isHandleAddedStickersCalled)
    }
    
}
