//
//  TabBarModel.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 04.08.2022.
//

import UIKit

private enum TabBarImages {
    static let allPostsTab: UIImage? = ImagesStorage.allPostsTab
    static let favoritePosts: UIImage? = ImagesStorage.favoritePostsTab
    static let profileTab: UIImage? = ImagesStorage.profileTab
}

enum TabBarModel {
    case allPosts
    case favoritePosts
    case profile
    
    var title: String {
        switch self {
        case .allPosts:
            return "Главная"
        case .favoritePosts:
            return "Избранное"
        case .profile:
            return "Профиль"
        }
    }
    var image: UIImage? {
        switch self {
        case .allPosts:
            return TabBarImages.allPostsTab
        case .favoritePosts:
            return TabBarImages.favoritePosts
        case .profile:
            return TabBarImages.profileTab
        }
    }
    
    var selectedImage: UIImage? {
        return image
    }
}
