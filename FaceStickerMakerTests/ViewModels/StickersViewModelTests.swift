//
//  StickersViewModelTests.swift
//  FaceStickerMakerTests
//
//  Created by Spencer Feng on 19/4/21.
//

import XCTest
@testable import FaceStickerMaker

class StickersViewModelTests: XCTestCase {
    
    var sut: StickersViewModel!
    var mockStickerService: MockStickerService!
    
    override func setUp() {
        super.setUp()
        mockStickerService = MockStickerService()
        sut = StickersViewModel(stickerService: mockStickerService)
    }
    
    override func tearDown() {
        sut = nil
        mockStickerService = nil
        super.tearDown()
    }
    
    func test_get_all_stickers() {
        // When
        sut.getStickers()
        
        // Assert
        XCTAssertEqual(sut.stickers.count, 5)
        XCTAssertEqual(sut.stickers[0].id, "stickerImg1")
        XCTAssertEqual(sut.stickers[1].id, "stickerImg2")
        XCTAssertEqual(sut.stickers[2].id, "stickerImg3")
        XCTAssertEqual(sut.stickers[3].id, "stickerImg4")
        XCTAssertEqual(sut.stickers[4].id, "stickerImg5")
    }
    
    func test_remove_selected_stickers() {
        // When
        sut.getStickers()
        
        // Given
        sut.insertItemToSelectedStickers(item: IndexPath(row: 0, section: 0))
        sut.insertItemToSelectedStickers(item: IndexPath(row: 2, section: 0))
        
        // When
        sut.removeSelectedStickers()
        
        // Assert
        XCTAssertEqual(sut.stickers.count, 3)
        XCTAssertEqual(sut.stickers[0].id, "stickerImg2")
        XCTAssertEqual(sut.stickers[1].id, "stickerImg4")
        XCTAssertEqual(sut.stickers[2].id, "stickerImg5")
    }
    
    func test_handle_added_stickers() {
        // Given
        sut.getStickers()
        let newStickers = [FaceImage(id: "stickerImg6")]
        
        // When
        sut.handleAddedStickers(newStickers: newStickers)
        
        // Assert
        XCTAssertEqual(sut.stickers.count, 6)
        XCTAssertEqual(sut.stickers[0].id, "stickerImg6")
    }
    
}
