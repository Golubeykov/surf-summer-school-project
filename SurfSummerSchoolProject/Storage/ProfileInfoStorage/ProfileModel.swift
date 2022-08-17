//
//  ProfileModel.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 17.08.2022.
//

import Foundation

struct ProfileModel: Decodable {
    let phone: String
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
    let city: String
    let about: String
}

struct ProfileInstance {
    static let shared = ProfileInstance()
    let profileModel: ProfileModel
    
    init() {
        let storage = BaseProfileStorage()
        do {
        let profile = try storage.getProfileInfo()
        self.profileModel = profile
        } catch {
        print(error)
        self.profileModel = ProfileModel(phone: "+7 (9**) *** ** **", email: "helloWorld@hello.com", firstName: "Иван", lastName: "Иваныч", avatar: "", city: "Санкт-Петербург", about: "Что-то пошло не так с загрузкой профиля, но хотя бы сейчас здесь корги :)")
        }
    }
}
