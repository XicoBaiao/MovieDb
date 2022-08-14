////
////  FavoriteMoviesViewModel.swift
////  MovieDbTest
////
////  Created by Baiao, Francisco Fonseca on 14/08/2022.
////
//
//import Foundation
//import SwiftUI
//
//
//class FavoriteMoviesViewModel: ObservableObject {
//    @Published var movies = [Movie]()
//    @Published var showFavorites = false
//    @Published var savedMovies: Set<Int> = []
//    
//    @StateObject var moviesApi = MoviesApi()
//    
//    var favoriteMovies: [Movie] {
//        return movies.filter { savedMovies.contains($0.id) }
//    }
//    
//    private var db = Database()
//    
//    init() {
//        self.savedMovies = db.loadFavorites()
//        self.movies = moviesApi.movies
//    }
//    
//    func sortFavorites() {
//        withAnimation {
//            showFavorites.toggle()
//        }
//    }
//    
//    func contains(_ movie: Movie) -> Bool {
//        savedMovies.contains(movie.id)
//    }
//    
//    func toggleFavorite(movie: Movie) {
//        if contains(movie) {
//            savedMovies.remove(movie.id)
//        } else {
//            savedMovies.insert(movie.id)
//        }
//        db.saveFavorites(items: savedMovies)
//    }
//}
//
