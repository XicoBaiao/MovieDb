//
//  ContentView.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 12/08/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var moviesApi = MoviesApi()
    
    @StateObject private var favoritesVM = FavoriteMoviesViewModel()
    @StateObject var realmManager = RealmManager()
    
    @State private var moviesSection: MoviesEndpoints = .nowPlaying
    
    @StateObject var monitor = NetworkMonitor()
    
    @State var showAlert = false
    
    fileprivate func movieSectionPicker() -> some View {
        return Picker("Select", selection: $moviesSection) {
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
                    
                    MovieListView(movies: moviesApi.movies)
                        .environmentObject(realmManager)
                        .onAppear {
                            moviesApi.getMovies(moviesSection: moviesSection)
                        }
                }
                .navigationBarTitle("iFlix", displayMode: .inline)
                if moviesApi.isLoading {
                    ZStack {
                        Color(.white)
                            .opacity(0.3)
                            .ignoresSafeArea()
                        
                        ProgressView("Fetching Movies")
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemBackground)))
                            .shadow(radius: 10)
                    }
                }
            }
            .alert(isPresented: $monitor.showSaveAlert) {
                Alert(title: Text("No Wi-fi"), message: Text("Check your Internet Connection"), dismissButton: .cancel(Text("Ok")))
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    fileprivate func FavoriteMoviesView() -> some View {
        return NavigationView {
            ZStack {
                VStack {
                    MovieListView(movies: realmManager.favoriteMovies).environmentObject(realmManager)
                }
                .navigationBarTitle("My Favorites", displayMode: .inline)
            }
            .alert(isPresented: $monitor.showSaveAlert) {
                Alert(title: Text("No Wi-fi"), message: Text("Check your Internet Connection"), dismissButton: .cancel(Text("Ok")))
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    var body: some View {
        
        TabView {
            MoviesView()
                .tabItem {
                    Image(systemName: "square.grid.3x3")
                    Text("Library")
                }
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            FavoriteMoviesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
        }.ignoresSafeArea(.all, edges: .bottom)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


