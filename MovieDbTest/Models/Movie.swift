//
//  Movie.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 12/08/2022.
//

import SwiftUI
import RealmSwift

struct MovieResponse: Decodable {
    let results: [Movie]
//    let dates: DateValue
    let page: Int
    let total_pages: Int
    let total_results: Int
    
    enum CodingKeys: String, CodingKey {
//        case dates
        case page
        case results
        case total_pages
        case total_results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.dates = try container.decode(DateValue.self, forKey: .dates)
        self.results = try container.decode([Movie].self, forKey: .results)
        self.total_pages = try container.decode(Int.self, forKey: .total_pages)
        self.total_results = try container.decode(Int.self, forKey: .total_results)
        self.page = try container.decode(Int.self, forKey: .page)
    }
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    var isFavorite: Bool = false
    var isHidden: Bool = false
    
    enum CodingKeys: String, CodingKey {
            case id = "id"
            case title = "title"
            case backdropPath = "backdrop_path"
            case posterPath = "poster_path"
            case overview = "overview"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case runtime = "runtime"
        }
    
    var backdropURL: URL {
            return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
}



