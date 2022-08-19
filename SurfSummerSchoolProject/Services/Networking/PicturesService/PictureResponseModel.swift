//
//  PictureResponseModel.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 08.08.2022.
//

import Foundation

struct PictureResponseModel: Decodable {

     // MARK: - Internal Properties

     let id: String
     let title: String
     let content: String
     let photoUrl: String

     var date: Date {
         Date(timeIntervalSince1970: publicationDate / 1000)
     }

     // MARK: - Private Properties

     private let publicationDate: Double

 }
