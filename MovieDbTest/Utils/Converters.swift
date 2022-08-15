//
//  Converters.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 15/08/2022.
//

import Foundation

class Converters {
    func convertMovieRating(rating: Double) -> String {
        if rating < 0 || rating > 10 {
            return "Invalid Rating"
        }
        
        let doubleStr = String(format: "%.1f", rating/2)
        return doubleStr
    }
}
