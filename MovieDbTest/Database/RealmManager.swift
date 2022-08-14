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
    
    init() {
        openRealm()
        getFavoriteMovies()
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
    
    func addFavoriteMovie(movie: Movie) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let newMovie = MovieRealmObject(value: ["id": movie.id,
                                                            "title" : movie.title,
                                                            "backdropPath" : movie.backdropPath ?? "",
                                                            "posterPath" : movie.posterPath ?? "",
                                                            "overview" : movie.overview,
                                                            "voteAverage" : movie.voteAverage,
                                                            "voteCount" : movie.voteCount,
                                                            "runtime" : movie.runtime ?? 0])
                    localRealm.add(newMovie)
                    getFavoriteMovies()
                    print("Added new movie to Realm: \(newMovie.title)")
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
                                                                "runtime" : movie.runtime ?? 0])
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
            let allFavoriteMovies = localRealm.objects(MovieRealmObject.self).sorted(byKeyPath: "isFavorite")
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
    
    func updateFavoriteMovies(id: Int, isFavorite: Bool) {
        if let localRealm = localRealm {
            do {
                let movieToUpdate = localRealm.objects(MovieRealmObject.self).filter(NSPredicate(format: "id == %@", id))
                guard !movieToUpdate.isEmpty else {return}
                
                try localRealm.write {
                    movieToUpdate[0].isFavorite = isFavorite
                    getFavoriteMovies()
                    print("Updated movie with id \(id)! Favorite status: \(isFavorite)")
                }
            } catch {
                print("Error updating task \(id) to Realm: \(error)")
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
    
}
