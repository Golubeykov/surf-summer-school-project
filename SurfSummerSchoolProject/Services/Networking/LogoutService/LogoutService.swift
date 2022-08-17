//
//  LogoutService.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 17.08.2022.
//

import Foundation

struct LogoutService {

     let dataTask = BaseNetworkTask<LogoutRequestModel, LogoutResponseModel>(
         inNeedInjectToken: false,
         method: .post,
         path: "auth/logout"
     )

     func performLogoutRequestAndRemoveToken(_ onResponseWasReceived: @escaping (_ result: Result<LogoutResponseModel, Error>) -> Void
     ) {
         dataTask.performRequest(input: LogoutRequestModel()) { result in
                     if case let .success(responseModel) = result {
                         do {
                             try dataTask.tokenStorage.removeTokenFromContainer()
                         } catch {
                            
                             // TODO: - Handle error if token not was received from server
                         }
                     }

                     onResponseWasReceived(result)
                 }
     }

 }
