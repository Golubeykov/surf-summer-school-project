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
            if case .success(_) = result {
                do {
                    try dataTask.tokenStorage.removeTokenFromContainer()
                    try dataTask.profileStorage.removeProfile()
                } catch {
                    onResponseWasReceived(result)
                }
            }
            onResponseWasReceived(result)
        }
    }
    
}
