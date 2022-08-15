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

class MoviesApi: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var searchedMovies: [Movie] = []
    @Published var recommendedMovies: [Movie] = []
    
    @Published var serviceError: Bool = false
    @Published var isLoading: Bool = false
    
    func getApiKey() -> String {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        guard let key = apiKey, !key.isEmpty else {
            print("API key does not exist")
            return ""
        }
        return key
    }
    
    func getMovies(moviesSection: MoviesEndpoints) {
        self.isLoading = true
        self.serviceError = false
        
        guard let moviesAPIUrl = URL(string: "https://api.themoviedb.org/3/movie/\(moviesSection.rawValue)?api_key=\(getApiKey())") else {return}

        let request = URLRequest(url: moviesAPIUrl)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.serviceError = true
                }
                return
            }
            
            var result: MovieResponse?
            do {
                result = try JSONDecoder().decode(MovieResponse.self, from: data)
            } catch {
                self.serviceError = true
                print("Failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            DispatchQueue.main.async {
                self.movies = json.results
            }
            
        }).resume()
        self.isLoading = false
    }
    
    func searchMovies(query: String ) {
        self.isLoading = true
        self.serviceError = false
        
        guard let queryFormatted = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {return}
        guard let moviesAPIUrl = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(getApiKey())&query=\(queryFormatted)") else {return}

        let request = URLRequest(url: moviesAPIUrl)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.serviceError = true
                }
                return
            }
            
            var result: MovieResponse?
            do {
                result = try JSONDecoder().decode(MovieResponse.self, from: data)
            } catch {
                print("Failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            DispatchQueue.main.async {
                self.searchedMovies = json.results
            }
            
        }).resume()
        self.isLoading = false
    }
    
    func getRecommendedMovies(id: Int) {
        self.isLoading = true
        self.serviceError = false

        guard let moviesAPIUrl = URL(string: "https://api.themoviedb.org/3/movie/\(id)/recommendations?api_key=\(getApiKey())") else {return}

        let request = URLRequest(url: moviesAPIUrl)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.serviceError = true
                }
                return
            }
            
            var result: MovieResponse?
            do {
                result = try JSONDecoder().decode(MovieResponse.self, from: data)
            } catch {
                print("Failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            DispatchQueue.main.async {
                self.recommendedMovies = json.results
            }
            
        }).resume()
        self.isLoading = false
    }
}
