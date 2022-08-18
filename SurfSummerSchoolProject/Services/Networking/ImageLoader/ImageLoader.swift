//
//  ImageLoader.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 08.08.2022.
//

import UIKit
import Foundation

 struct ImageLoader {

     let queueForLoad = DispatchQueue.global(qos: .utility)
     let session = URLSession(configuration: .default)

     func loadImage(from url: URL, _ onLoadWasCompleted: @escaping (_ result: Result<UIImage, Error>) -> Void) {
         let imageCache = NSCache<AnyObject, AnyObject>()
         
         if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
             onLoadWasCompleted(.success(imageFromCache))
         } else {
         session.dataTask(with: url) { data, _, error in
             if let error = error {
                 onLoadWasCompleted(.failure(error))
             }
             if let data = data, let image = UIImage(data: data) {
                 imageCache.setObject(image, forKey: url as AnyObject)
                 onLoadWasCompleted(.success(image))
             }
         }
         .resume()
     }
     }
 }
