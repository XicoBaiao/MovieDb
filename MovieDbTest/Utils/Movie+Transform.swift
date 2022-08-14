//
//  Movie+Transform.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 14/08/2022.
//

import Foundation

extension MovieRealmObject {
    
    func asMovie() throws -> Movie {

        return Movie(id: id,
                     title: title,
                     backdropPath:backdropPath,
                     posterPath:posterPath,
                     overview:overview,
                     voteAverage:voteAverage,
                     voteCount:voteCount,
                     runtime:runtime)
    }
}

internal extension Sequence where Element == MovieRealmObject {
    
    func asMoviesArray() throws -> [Movie] {
        return try self.map { try $0.asMovie() }
    }
    
}

