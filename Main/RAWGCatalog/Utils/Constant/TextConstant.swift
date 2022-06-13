//
//  TextConstant.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 04/06/22.
//

import Foundation

public struct TextConstant {
    
    // MARK: Common
    public static let unknown = "Unknown"
    public static let cancel = "Cancel"
    public static let noInternetErrorMessage = "There is no internet connection.\nPlease check your device"
    
    // MARK: Home
    public static let featuredGamesRequest = "getFeaturedGames"
    public static let genresRequest = "getGenres"
    public static let gamesRequest = "getGames"
    public static let storesRequest = "getStores"
    
    public static let emptyFeaturedGames = "Featured Games is empty"
    public static let emptyGenres = "Genre data is empty"
    public static let emptyStores = "Store data is empty"
    
    // MARK: Games
    public static let gameHeaderTitle = "Games"
    public static let emptyGames = "Game data is empty"
    
    // MARK: Favorite Games
    public static let emptyFavoriteGames = "No games here. Start by marking the games you have beaten in the past or dropped abandoned and select the ones that you will play in the future."
    
    // MARK: Edit Profile
    public static let successSaveProfile = "Data profil berhasil disimpan!"
    
    public static let aboutStudentTextFieldTitle = "Tentang Peserta"
    
    public static let fullnameErrorMessage = "Nama minimal 6 karakter dan hanya boleh berisi huruf."
    public static let usernameErrorMessage = "Username minimal 6 karakter."
    public static let emailErrorMessage = "Format email harus sesuai."
    public static let aboutStudentErrorMessage = "Deskripsi tentang peserta minimal 50 karakter."
    
    public static let imagePickerGallery = "Gallery"
    public static let imagePickerCamera = "Camera"
    
    // MARK: Store
    public static let storeFilteredHeaderTitle = "Games available at"
}
