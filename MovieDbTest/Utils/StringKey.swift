//
//  StringKey.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 14/08/2022.
//

import Foundation

public enum StringKey: String {
    case app_title = "iFlix"
    case loading_movies_progress_title = "Fetching Movies"
    case no_wifi = "No Wi-Fi"
    case check_internet_connection = "Check your Internet Connection"
    case ok = "Ok"
    case favorite_movies_empty_view_title = "No Favorite Movies yet"
    case favorite_movies_empty_view_subtitle = "Try adding some movie as your Favorite"
    case my_favorites_title = "My Favorites"
    case no_results_title = "No Results to show"
    case no_search_results_subtitle = "Insert or change your text to search for movies"
    case movies_database_title = "Movies Database"
    case library_tab_item_title = "Library"
    case search_tab_item_title = "Search"
    case favorites_tab_item_title = "Favorites"
    case service_api_call_error_message = "There was an error with the request, try again later."
    case error = "Error"
    case movie_detail_recommendations_title = "If you liked %@, we've got some recommendations for you"
    case movie_detail_votes_text = "%@ votes"
    case select = "Select"
}
