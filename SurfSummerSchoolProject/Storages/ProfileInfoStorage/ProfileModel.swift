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

func getProfileInstance() -> ProfileModel {
        let storage = BaseProfileStorage()
        do {
        let profile = try storage.getProfileInfo()
        return profile
        } catch {
        print(error)
        let profile = ProfileModel(phone: "+7 (9**) *** ** **", email: "helloWorld@hello.com", firstName: "Иван", lastName: "Иваныч", avatar: "", city: "Санкт-Петербург", about: "Что-то пошло не так с загрузкой профиля, но любые проблемы решаемы, в том числе и эта :)")
        return profile
        }
}

