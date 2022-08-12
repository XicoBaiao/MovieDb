//
//  MoviesAPI.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 12/08/2022.
//

import Foundation



enum MoviesEndpoints: String, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
    
    var description: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .topRated: return "Top Rated"
        case .popular: return "Popular"
        }
    }
}

class Api {
    func getNowPlayingMovies(_ completion: @escaping (([Movie]) -> Void)) {
        guard let moviesAPIUrl = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=dba40b2e25988d186f8c528a2eb8121d") else {return}

        let request = URLRequest(url: moviesAPIUrl)
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            let moviesResponse = try! JSONDecoder().decode(MovieResponse.self, from: data!)
            completion(moviesResponse.results)
        }
        .resume()
    }
}
