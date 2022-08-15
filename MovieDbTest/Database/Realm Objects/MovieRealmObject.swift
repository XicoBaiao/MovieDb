//
//  MovieRealmObject.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 14/08/2022.
//

import Foundation
import RealmSwift

class MovieRealmObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title = ""
    @Persisted var backdropPath = ""
    @Persisted var posterPath = ""
    @Persisted var overview = ""
    @Persisted var voteAverage = 0.0
    @Persisted var voteCount = 0
    @Persisted var runtime = 0
    @Persisted var isFavorite = false
    @Persisted var isHidden = false
    
}
