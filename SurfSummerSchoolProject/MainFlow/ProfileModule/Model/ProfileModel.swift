//
//  ProfileModel.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 17.08.2022.
//

import Foundation

struct ProfileInfoModel: Decodable {
    let phone: String
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
    let city: String
    let about: String
    
    init(phone: String, email: String, firstName: String, lastName: String, avatar:String, city: String, about: String) {
        self.phone = phone
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.avatar = avatar
        self.city = city
        self.about = about
    }
}
