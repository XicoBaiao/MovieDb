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
                    
                    MovieListView(movies: moviesApi.movies, showHiddenMovies: true)
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
                    if realmManager.favoriteMovies.isEmpty {
                        VStack(spacing: 15) {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                            Text("No Favorite Movies yet")
                                .foregroundColor(.black)
                                .font(.headline)
                                .fontWeight(.medium)
                                .padding(.top, 20)
                            Text("Try adding some movie as your Favorite")
                                .foregroundColor(.black)
                                .font(.headline)
                                .fontWeight(.regular)
                                .padding(.vertical, 5)
                        }
                    } else {
                        MovieListView(movies: realmManager.favoriteMovies, showHiddenMovies: true).environmentObject(realmManager)
                    }
                }
                .navigationBarTitle("My Favorites", displayMode: .inline)
            }
            .alert(isPresented: $monitor.showSaveAlert) {
                Alert(title: Text("No Wi-fi"), message: Text("Check your Internet Connection"), dismissButton: .cancel(Text("Ok")))
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    fileprivate func SearchMoviesView() -> some View {
        return NavigationView {
            ZStack {
                VStack {
                    if searchText.isEmpty || moviesApi.searchedMovies.isEmpty {
                        VStack(spacing: 15) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                            Text("No Results to show")
                                .foregroundColor(.black)
                                .font(.headline)
                                .fontWeight(.medium)
                                .padding(.top, 20)
                            Text("Insert or change your text to search for movies")
                                .foregroundColor(.black)
                                .font(.headline)
                                .fontWeight(.regular)
                                .padding(.vertical, 5)
                        }
                        
                    } else {
                        MovieListView(movies: moviesApi.searchedMovies, isSearchView: true, showHiddenMovies: false)
                            .environmentObject(realmManager)
                            
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .onChange(of: searchText) { value in
                    Task.init {
                        if !value.isEmpty && value.count > 3 {
                            moviesApi.searchMovies(query: value)
                        } else {
                            moviesApi.searchedMovies.removeAll()
                        }
                    }
                }
                .navigationBarTitle("Movies Database", displayMode: .inline)
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
            SearchMoviesView()
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


