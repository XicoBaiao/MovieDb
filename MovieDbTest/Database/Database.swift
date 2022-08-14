////
////  Database.swift
////  MovieDbTest
////
////  Created by Baiao, Francisco Fonseca on 14/08/2022.
////
//
//import Foundation
//
//final class Database {
//    private var FAVORITE_KEY = "favorite_key"
//    
//    func saveFavorites(items: Set<Int>) {
//        let array = Array(items)
//        UserDefaults.standard.set(array, forKey: FAVORITE_KEY)
//    }
//    
//    func loadFavorites() -> Set<Int> {
//        let array = UserDefaults.standard.array(forKey: FAVORITE_KEY) as? [Int] ?? [Int]()
//        return Set(array)
//    }
//}
