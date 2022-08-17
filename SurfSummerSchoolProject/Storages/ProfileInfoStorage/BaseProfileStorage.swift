//
//  BaseProfileStorage.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 17.08.2022.
//

import Foundation

struct BaseProfileStorage: ProfileStorage {

    // MARK: - Properties
    var unprotectedStorage: UserDefaults {
        UserDefaults.standard
    }
    // MARK: - StorageKeys
    let phoneKey: String = "phone"
    let emailKey: String = "email"
    let firstNameKey: String = "firstName"
    let lastNameKey: String = "lastName"
    let avatarKey: String = "avatar"
    let cityKey: String = "city"
    let aboutKey: String = "about"
    

    // MARK: - TokenStorage
    func getProfileInfo() throws -> ProfileModel {
        let profile = try getProfileFromStorage()
        return profile
    }
    func set(profile: ProfileModel) throws {
        removeProfileFromStorage()
        saveProfileInStorage(profile: profile)
    }
    func removeProfile() throws {
        removeProfileFromStorage()
    }

}

private extension BaseProfileStorage {

    enum Error: Swift.Error {
        case profileWasNotFound
    }
    func getProfileFromStorage() throws -> ProfileModel {
        guard let profilePhone = unprotectedStorage.value(forKey: phoneKey) as? String,
              let profileEmail = unprotectedStorage.value(forKey: emailKey) as? String,
              let profileFirstName = unprotectedStorage.value(forKey: firstNameKey) as? String,
              let profileLastName = unprotectedStorage.value(forKey: lastNameKey) as? String,
              let profileAvatar = unprotectedStorage.value(forKey: avatarKey) as? String,
              let profileCity = unprotectedStorage.value(forKey: cityKey) as? String,
              let profileAbout = unprotectedStorage.value(forKey: aboutKey) as? String
        else {
            throw Error.profileWasNotFound
        }
        let profile = ProfileModel(phone: profilePhone, email: profileEmail, firstName: profileFirstName, lastName: profileLastName, avatar: profileAvatar, city: profileCity, about: profileAbout)
        return profile
    }
    
    func saveProfileInStorage(profile: ProfileModel) {
        unprotectedStorage.set(profile.phone, forKey: phoneKey)
        unprotectedStorage.set(profile.email, forKey: emailKey)
        unprotectedStorage.set(profile.firstName, forKey: firstNameKey)
        unprotectedStorage.set(profile.lastName, forKey: lastNameKey)
        unprotectedStorage.set(profile.avatar, forKey: avatarKey)
        unprotectedStorage.set(profile.city, forKey: cityKey)
        unprotectedStorage.set(profile.about, forKey: aboutKey)
    }
    func removeProfileFromStorage() {
        unprotectedStorage.set(nil, forKey: phoneKey)
        unprotectedStorage.set(nil, forKey: emailKey)
        unprotectedStorage.set(nil, forKey: firstNameKey)
        unprotectedStorage.set(nil, forKey: lastNameKey)
        unprotectedStorage.set(nil, forKey: avatarKey)
        unprotectedStorage.set(nil, forKey: cityKey)
        unprotectedStorage.set(nil, forKey: aboutKey)
    }
}
