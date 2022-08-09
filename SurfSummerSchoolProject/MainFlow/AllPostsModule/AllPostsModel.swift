//
//  AllPostsModel.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 05.08.2022.
//

import Foundation
import UIKit

final class AllPostsModel {
    static let shared = AllPostsModel.init()
    
    var didPostsUpdated: (()->Void)?
    var didPostsFetchErrorHappened: (()->Void)?
    
    let favoritesStorage = FavoritesStorage.shared
    let pictureService = PicturesService()
    var posts: [PostModel] = []
    var favoritePosts: [PostModel] {
        posts.filter { $0.isFavorite }
    }
    func createMockPosts() {
        posts = Array(repeating: PostModel.createDefault(), count: 100)
    }
    func loadPosts() {
        pictureService.loadPictures { [weak self] result in
            switch result {
            case .success(let pictures):
                self?.posts = pictures.map { pictureModel in
                    PostModel(
                        imageUrlInString: pictureModel.photoUrl,
                        title: pictureModel.title,
                        isFavorite: self?.favoritesStorage.isPostFavorite(post: pictureModel.title) ?? false,
                        content: pictureModel.content,
                        dateCreation: pictureModel.date
                    )
                }
                self?.didPostsUpdated?()
            case .failure(let error):
                self?.didPostsFetchErrorHappened?()
                print(error)
            }
        }
    }
    func favoritePost(for post: PostModel) {
        guard let index = posts.firstIndex(where: { $0 == post }) else { return }
        posts[index].isFavorite.toggle()
    }
}

struct PostModel: Equatable {
    let imageUrlInString: String
    let title: String
    var isFavorite: Bool
    let content: String
    let dateCreation: String
    
    internal init(imageUrlInString: String, title: String, isFavorite: Bool, content: String, dateCreation: Date) {
        self.imageUrlInString = imageUrlInString
        self.title = title
        self.isFavorite = isFavorite
        self.content = content
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.mm.yyyy"
        
        self.dateCreation = formatter.string(from: dateCreation)
    }
    
    static func createDefault() -> PostModel {
        .init(
            imageUrlInString: "",
            title: "Самый милый корги",
            isFavorite: false,
            content: "Для бариста и посетителей кофеен специальные кружки для кофе — это ещё один способ проконтролировать вкус напитка и приготовить его именно так, как нравится вам. \n \nТеперь, кроме регулировки экстракции, настройки помола, времени заваривания и многого что помогает выделять нужные характеристики кофе, вы сможете выбрать и кружку для кофе в зависимости от сорта.",
            dateCreation: Date()
        )
    }
}
