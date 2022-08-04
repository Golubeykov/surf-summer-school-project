//
//  TabBarModel.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 04.08.2022.
//

import Foundation
import UIKit

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
            return UIImage(named: "allPostsTab")
        case .favoritePosts:
            return UIImage(named: "favoritePostsTab")
        case .profile:
            return UIImage(named: "profileTab")
        }
    }
    
    var selectedImage: UIImage? {
        return image
    }
}
