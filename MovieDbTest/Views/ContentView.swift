//
//  ContentView.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 12/08/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var moviesApi = MoviesApi()
    @StateObject var realmManager = RealmManager()
    @StateObject var monitor = NetworkMonitor()
    
    @State private var moviesSection: MoviesEndpoints = .nowPlaying
    @State var showAlert = false
    @State private var searchText : String = ""
    
    
    fileprivate func movieSectionPicker() -> some View {
        return Picker(StringKey.select.rawValue, selection: $moviesSection) {
            Text(MoviesEndpoints.nowPlaying.description).tag(MoviesEndpoints.nowPlaying)
            Text(MoviesEndpoints.popular.description).tag(MoviesEndpoints.popular)
            Text(MoviesEndpoints.topRated.description).tag(MoviesEndpoints.topRated)
            Text(MoviesEndpoints.upcoming.description).tag(MoviesEndpoints.upcoming)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    fileprivate func MoviesView() -> some View {
        return NavigationView {
            ZStack {
                VStack {
                    movieSectionPicker().onChange(of: moviesSection) { _ in
                        moviesApi.getMovies(moviesSection: moviesSection)
                    }
                    
                    MovieListView(movies: moviesApi.movies, showHiddenMovies: true)
                        .environmentObject(realmManager)
                        .onAppear {
                            moviesApi.getMovies(moviesSection: moviesSection)
                        }
                }
                .navigationBarTitle(StringKey.app_title.rawValue, displayMode: .inline)
                if moviesApi.isLoading {
                    ZStack {
                        Color(.white)
                            .opacity(0.3)
                            .ignoresSafeArea()
                        
                        ProgressView(StringKey.loading_movies_progress_title.rawValue)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemBackground)))
                            .shadow(radius: 10)
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    fileprivate func EmptyFavoritesView() -> some View {
        return VStack(spacing: 15) {
            Image(systemName: "heart.fill")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(StringKey.favorite_movies_empty_view_title.rawValue)
                .foregroundColor(.black)
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top, 20)
            Text(StringKey.favorite_movies_empty_view_subtitle.rawValue)
                .foregroundColor(.black)
                .font(.headline)
                .fontWeight(.regular)
                .padding(.vertical, 5)
        }
    }
    
    fileprivate func FavoriteMoviesView() -> some View {
        return NavigationView {
            ZStack {
                VStack {
                    if realmManager.favoriteMovies.isEmpty {
                        EmptyFavoritesView()
                    } else {
                        MovieListView(movies: realmManager.favoriteMovies, showHiddenMovies: true).environmentObject(realmManager)
                    }
                }
                .navigationBarTitle(StringKey.my_favorites_title.rawValue, displayMode: .inline)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    fileprivate func EmptySearchView() -> some View {
        return VStack(spacing: 15) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(StringKey.no_results_title.rawValue)
                .foregroundColor(.black)
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top, 20)
            Text(StringKey.no_search_results_subtitle.rawValue)
                .foregroundColor(.black)
                .font(.headline)
                .fontWeight(.regular)
                .padding(.vertical, 5)
        }
    }
    
    fileprivate func searchMoviesTask(_ value: String) -> (Task<(), Never>) {
        return Task.init {
            if !value.isEmpty && value.count > 3 {
                moviesApi.searchMovies(query: value)
            } else {
                moviesApi.searchedMovies.removeAll()
            }
        }
    }
    
    fileprivate func SearchMoviesView() -> some View {
        return NavigationView {
            ZStack {
                VStack {
                    if searchText.isEmpty || moviesApi.searchedMovies.isEmpty {
                        EmptySearchView()
                        
                    } else {
                        MovieListView(movies: moviesApi.searchedMovies, isSearchView: true, showHiddenMovies: false)
                            .environmentObject(realmManager)
                            
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .onChange(of: searchText) { value in
                    searchMoviesTask(value)
                }
                .navigationBarTitle(StringKey.movies_database_title.rawValue, displayMode: .inline)
            }
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    var body: some View {
        
        TabView {
            MoviesView()
                .tabItem {
                    Image(systemName: "square.grid.3x3")
                    Text(StringKey.library_tab_item_title.rawValue)
                }
            SearchMoviesView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(StringKey.search_tab_item_title.rawValue)
                }
            FavoriteMoviesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text(StringKey.favorites_tab_item_title.rawValue)
                }
        }.ignoresSafeArea(.all, edges: .bottom)
            .alert(isPresented: $monitor.showNoConnectionAlert) {
                Alert(title: Text(StringKey.no_wifi.rawValue), message: Text(StringKey.check_internet_connection.rawValue), dismissButton: .cancel(Text(StringKey.ok.rawValue)))
            }
            .alert(isPresented: $moviesApi.serviceError) {
                Alert(title: Text(StringKey.error.rawValue), message: Text(StringKey.service_api_call_error_message.rawValue), dismissButton: .cancel(Text(StringKey.ok.rawValue)))
            }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


