//
//  BaseNetworkTask.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 08.08.2022.
//

import Foundation

struct BaseNetworkTask<AbstractInput: Encodable, AbstractOutput: Decodable>: NetworkTask {
    
    // MARK: - NetworkTask
    
    typealias Input = AbstractInput
    typealias Output = AbstractOutput
    
    var baseURL: URL? {
        URL(string: "https://pictures.chronicker.fun/api")
    }
    
    let path: String
    let method: NetworkMethod
    let session: URLSession = URLSession(configuration: .default)
    let isNeedInjectToken: Bool
    var urlCache: URLCache {
        URLCache.shared
    }
    
    var tokenStorage: TokenStorage {
        BaseTokenStorage()
    }
    var profileStorage: ProfileStorage {
        BaseProfileStorage()
    }
    
    
    // MARK: - Initializtion
    
    init(inNeedInjectToken: Bool, method: NetworkMethod, path: String) {
        self.isNeedInjectToken = inNeedInjectToken
        self.path = path
        self.method = method
    }
    
    // MARK: - NetworkTask
    
    func performRequest(
        input: AbstractInput,
        _ onResponseWasReceived: @escaping (_ result: Result<AbstractOutput, Error>) -> Void
    ) {
        do {
            let request = try getRequest(with: input)
            
            //Закомментировано для возможности протестировать экран с состояния ошибки загрузки данных из сети. Будет раскомментировано после проверки.
            //             if let cachedResponse = getCachedResponseFromCache(by: request) {
            //
            //                 let mappedModel = try JSONDecoder().decode(AbstractOutput.self, from: cachedResponse.data)
            //
            //                 onResponseWasReceived(.success(mappedModel))
            //                 //return
            //             } else {
            
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    if error.localizedDescription == "The Internet connection appears to be offline." {
                        onResponseWasReceived(.failure(PossibleErrors.noNetworkConnection))
                    } else {
                    onResponseWasReceived(.failure(PossibleErrors.unknownError))
                    }
                    
                } else if let data = data {
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200:
                            do {
                                let mappedModel = try JSONDecoder().decode(AbstractOutput.self, from: data)
                                saveResponseToCache(response, cachedData: data, by: request)
                                onResponseWasReceived(.success(mappedModel))
                            } catch {
                                onResponseWasReceived(.failure(PossibleErrors.unknownError))
                            }
                        case 400:
                            do {
                                if let badRequest = try JSONSerialization.jsonObject(with: data) as? [String:String] {
                                onResponseWasReceived(.failure(PossibleErrors.badRequest(badRequest)))
                                }
                            } catch {
                                onResponseWasReceived(.failure(PossibleErrors.unknownError))
                            }
                        default:
                            onResponseWasReceived(.failure(PossibleErrors.unknownServerError))
                        }
                    }
                    
                } else {
                    onResponseWasReceived(.failure(PossibleErrors.unknownError))
                }
            }
            .resume()
            //}
        } catch {
            onResponseWasReceived(.failure(PossibleErrors.unknownError))
        }
    }
    
}

// MARK: - EmptyModel

extension BaseNetworkTask where Input == EmptyModel {
    
    func performRequest(_ onResponseWasReceived: @escaping (_ result: Result<AbstractOutput, Error>) -> Void) {
        performRequest(input: EmptyModel(), onResponseWasReceived)
    }
    
}
// MARK: - Cache logic

private extension BaseNetworkTask {
    
    func getCachedResponseFromCache(by request: URLRequest) -> CachedURLResponse? {
        return urlCache.cachedResponse(for: request)
    }
    
    func saveResponseToCache(_ response: URLResponse?, cachedData: Data?, by request: URLRequest) {
        guard let response = response, let cachedData = cachedData else {
            return
        }
        
        let cachedUrlResponse = CachedURLResponse(response: response, data: cachedData)
        urlCache.storeCachedResponse(cachedUrlResponse, for: request)
    }
    
}

// MARK: - Private Methods

private extension BaseNetworkTask {
    
    func getRequest(with parameters: AbstractInput) throws -> URLRequest {
        guard let url = completedURL else {
            throw PossibleErrors.urlWasNotFound
        }
        
        var request: URLRequest
        switch method {
        case .get:
            let newUrl = try getUrlWithQueryParameters(for: url, parameters: parameters)
            request = URLRequest(url: newUrl)
        case .post:
            request = URLRequest(url: url)
            request.httpBody = try getParametersForBody(from: parameters)
        }
        request.httpMethod = method.method
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if isNeedInjectToken {
            request.addValue("Token \(try tokenStorage.getToken().token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    func getParametersForBody(from encodableParameters: AbstractInput) throws -> Data {
        return try JSONEncoder().encode(encodableParameters)
    }
    
    func getUrlWithQueryParameters(for url: URL, parameters: AbstractInput) throws -> URL {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw PossibleErrors.urlComponentWasNotCreated
        }
        
        let parametersInDataRepresentation = try JSONEncoder().encode(parameters)
        let parametersInDictionaryRepresentation = try JSONSerialization.jsonObject(with: parametersInDataRepresentation)
        
        guard let parametersInDictionaryRepresentation = parametersInDictionaryRepresentation as? [String: Any] else {
            throw PossibleErrors.parametersIsNotValidJsonObject
        }
        
        let queryItems = parametersInDictionaryRepresentation.map { key, value in
            return URLQueryItem(name: key, value: "\(value)")
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        guard let newUrlWithQuery = urlComponents.url else {
            throw PossibleErrors.urlWasNotFound
        }
        
        return newUrlWithQuery
    }
    
}

