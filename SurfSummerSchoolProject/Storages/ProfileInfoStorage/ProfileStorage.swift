//
//  ProfileStorage.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 17.08.2022.
//

import Foundation

protocol ProfileStorage {

     func getProfileInfo() throws -> ProfileModel
     func set(profile: ProfileModel) throws
     func removeProfile() throws

 }
