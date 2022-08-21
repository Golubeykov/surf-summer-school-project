//
//  ErrorTypes.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 19.08.2022.
//

import Foundation

//MARK: - Possible errors
enum PossibleErrors: Error {
    case unknownError
    case urlWasNotFound
    case urlComponentWasNotCreated
    case parametersIsNotValidJsonObject
    case badRequest([String:String])
    case noNetworkConnection
    case unknownServerError
    case nonAuthorizedAccess
}

struct LocalizedDescriptions {
    static let noNetworkSimulator = "The Internet connection appears to be offline."
    static let noNetworkDevice = "A data connection is not currently allowed."
}
