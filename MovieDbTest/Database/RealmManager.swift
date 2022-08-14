//
//  RealmManager.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 14/08/2022.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    
    @Published private(set) var favoriteMovies: [Movie] = []
    @Published private(set) var hiddenMovies: [Movie] = []
    
    init() {
        openRealm()
        getFavoriteMovies()
        getHiddenMovies()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
            
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func objectExist (id: Int) -> Bool {
        if let localRealm = localRealm {
            return localRealm.object(ofType: MovieRealmObject.self, forPrimaryKey: id) != nil
        }
        return false
    }
    
    func addFavoriteMovie(movie: Movie) {
        if let localRealm = localRealm {
            do {
                if !objectExist(id: movie.id) {
                    try localRealm.write {
                        let newMovie = MovieRealmObject(value: ["id": movie.id,
                                                                "title" : movie.title,
                                                                "backdropPath" : movie.backdropPath ?? "",
                                                                "posterPath" : movie.posterPath ?? "",
                                                                "overview" : movie.overview,
                                                                "voteAverage" : movie.voteAverage,
                                                                "voteCount" : movie.voteCount,
                                                                "runtime" : movie.runtime ?? 0,
                                                                "isFavorite": true,
                                                                "isHidden": movie.isHidden])
                        localRealm.add(newMovie)
                        getFavoriteMovies()
                        print("Added new movie to Realm: \(newMovie.title)")
                    }
                } else {
                    updateIsFavoriteMovie(id: movie.id, isFavorite: true)
                }
                
            } catch {
                print("Error adding movie to Realm: \(error)")
            }
        }
    }
    
    func addMovies(movies: [Movie]) {
        if let localRealm = localRealm {
            do {
                for movie in movies {
                    try localRealm.write {
                        let newMovie = MovieRealmObject(value: ["id": movie.id,
                                                                "title" : movie.title,
                                                                "backdropPath" : movie.backdropPath ?? "",
                                                                "posterPath" : movie.posterPath ?? "",
                                                                "overview" : movie.overview,
                                                                "voteAverage" : movie.voteAverage,
                                                                "voteCount" : movie.voteCount,
                                                                "runtime" : movie.runtime ?? 0,
                                                                "isFavorite": movie.isFavorite,
                                                                "isHidden": movie.isHidden])
                        localRealm.add(newMovie)
                        getFavoriteMovies()
                        print("Added new movie to Realm: \(newMovie.title)")
                    }
                }
            } catch {
                print("Error adding movie to Realm: \(error)")
            }
        }
    }
    
    func getFavoriteMovies() {
        if let localRealm = localRealm {
            let allFavoriteMovies = localRealm.objects(MovieRealmObject.self).filter("isFavorite == 1")
            favoriteMovies = []
            do {
                let movies = try allFavoriteMovies.asMoviesArray()
                favoriteMovies.append(contentsOf: movies)
                return
            } catch {
                print("Error converting movies realm objects to movies")
            }
        }
    }
    
    func getMovies() {
        if let localRealm = localRealm {
            let allMovies = localRealm.objects(MovieRealmObject.self)
            favoriteMovies = []
            do {
                let movies = try allMovies.asMoviesArray()
                favoriteMovies.append(contentsOf: movies)
                return
            } catch {
                print("Error converting movies realm objects to movies")
            }
        }
    }
    
    func updateIsFavoriteMovie(id: Int, isFavorite: Bool) {
        if let localRealm = localRealm {
            do {
                let movieToUpdate = localRealm.objects(MovieRealmObject.self).filter(NSPredicate(format: "id == %@", id as NSNumber))
                guard !movieToUpdate.isEmpty else {return}
                
                try localRealm.write {
                    movieToUpdate[0].isFavorite = isFavorite
                    getFavoriteMovies()
                    print("Updated movie with id \(id)! Favorite status: \(isFavorite)")
                }
            } catch {
                print("Error updating movie \(id) to Realm: \(error)")
            }
        }
    }
    
    func updateIsHiddenMovie(id: Int, isHidden: Bool) {
        if let localRealm = localRealm {
            do {
                let movieToUpdate = localRealm.objects(MovieRealmObject.self).filter(NSPredicate(format: "id == %@", id as NSNumber))
                guard !movieToUpdate.isEmpty else {return}
                
                try localRealm.write {
                    movieToUpdate[0].isHidden = isHidden
                    getHiddenMovies()
                    print("Updated movie with id \(id)! Hidden status: \(isHidden)")
                }
            } catch {
                print("Error updating movie \(id) to Realm: \(error)")
            }
        }
    }
    
    func deleteFavoriteMovie(id:Int) {
        if let localRealm = localRealm {
            do {
                let movieToDelete = localRealm.objects(MovieRealmObject.self).filter(NSPredicate(format: "id == %@", id as NSNumber))
                guard !movieToDelete.isEmpty else {return}
                
                try localRealm.write {
                    localRealm.delete(movieToDelete)
                    getFavoriteMovies()
                    print("Deleted movie with id \(id)")
                }
            } catch {
                print("Error deleting movie \(id) from Realm: \(error)")
            }
        }
    }
    
    func hideMovieFromSearchResults(movie:Movie) {
        if let localRealm = localRealm {
            do {
                if !objectExist(id: movie.id) {
                    try localRealm.write {
                        let newMovie = MovieRealmObject(value: ["id": movie.id,
                                                                "title" : movie.title,
                                                                "backdropPath" : movie.backdropPath ?? "",
                                                                "posterPath" : movie.posterPath ?? "",
                                                                "overview" : movie.overview,
                                                                "voteAverage" : movie.voteAverage,
                                                                "voteCount" : movie.voteCount,
                                                                "runtime" : movie.runtime ?? 0,
                                                                "isFavorite": movie.isFavorite,
                                                                "isHidden": true])
                        localRealm.add(newMovie)
                        getHiddenMovies()
                        print("Added new movie to Realm: \(newMovie.id)")
                    }
                } else {
                    updateIsHiddenMovie(id: movie.id, isHidden: true)
                }
                
            } catch {
                print("Error adding movie to Realm: \(error)")
            }
        }
    }
    
    func showHiddenMovieFromSearchResults(movie: Movie) {
        if let localRealm = localRealm {
            do {
                let movieToShow = localRealm.objects(MovieRealmObject.self).filter(NSPredicate(format: "id == %@", movie.id as NSNumber))
                guard !movieToShow.isEmpty else {return}
                
                try localRealm.write {
                    movieToShow[0].isHidden = false
                    getHiddenMovies()
                    print("Show again movie with id \(movie.id)")
                }
            } catch {
                print("Error showing hidden movie \(movie.id) from Realm: \(error)")
            }
        }
    }
    
    func getHiddenMovies() {
        if let localRealm = localRealm {
            let allHiddenMovies = localRealm.objects(MovieRealmObject.self).filter("isHidden == 1")
            hiddenMovies = []
            do {
                let movies = try allHiddenMovies.asMoviesArray()
                hiddenMovies.append(contentsOf: movies)
                return
            } catch {
                print("Error converting movies realm objects to movies")
            }
        }
    }
    
}
