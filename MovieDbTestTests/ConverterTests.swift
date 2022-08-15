//
//  Converter.swift
//  MovieDbTestTests
//
//  Created by Baiao, Francisco Fonseca on 15/08/2022.
//

import XCTest

class ConverterTests: XCTestCase {

    private var converter: Converters!
    
    override func setUpWithError() throws {
        converter = Converters()
    }
    
    override func tearDownWithError() throws {
        converter = nil
    }
    
    func test_correct_convert_rating() {
        let actual = converter.convertMovieRating(rating: 8.7564757)
        let expected = "4.4"
        
        XCTAssertEqual(actual, expected)
    }
    
    func test_convert_rating_too_low() {
        let actual = converter.convertMovieRating(rating: -5.5454)
        let expected = "Invalid Rating"
        
        XCTAssertEqual(actual, expected)
    }
    
    func test_convert_rating_too_high() {
        let actual = converter.convertMovieRating(rating: 12.535353535)
        let expected = "Invalid Rating"
        
        XCTAssertEqual(actual, expected)
    }
    
    func test_convert_rating_too_many_decimal_places() {
        let actual = converter.convertMovieRating(rating: 8.7564757)
        let expected = "4.40"
        
        XCTAssertNotEqual(actual, expected)
    }
    
    func test_sampleTest() {
        let actual = true
        
        XCTAssertTrue(actual)
    }

}
