//
//  AllPostsModel.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 05.08.2022.
//

import Foundation
import UIKit

final class AllPostsModel {
    var didPostsUpdated: (()->Void)?
    var posts: [PostModel] = [] {
        didSet {
            didPostsUpdated?()
        }
    }
    func getPosts() {
        posts = Array(repeating: PostModel.createDefault(), count: 100)
    }
}

struct PostModel {
    let image: UIImage?
    let title: String
    var isFavorite: Bool
    let date: String
    let contentText: String
    
    static func createDefault() -> PostModel {
        .init(image: UIImage(named: "korgi"), title: "Самый милый корги", isFavorite: false, date: "12.05.2022", contentText: "Для бариста и посетителей кофеен специальные кружки для кофе — это ещё один способ проконтролировать вкус напитка и приготовить его именно так, как нравится вам.\n Теперь, кроме регулировки экстракции, настройки помола, времени заваривания и многого что помогает выделять нужные характеристики кофе, вы сможете выбрать и кружку для кофе в зависимости от сорта.")
    }
}
