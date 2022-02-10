//
//  NetworkManager.swift
//  MetaWeatherFeed
//
//  Created by mustafa salah eldin on 2/5/22.
//

import Foundation


class NetworkManager {
    let baseUrl = "https://www.metaweather.com/api/" // any valid api to make sure that netowrk request remote data correctly
     var httpClient:HTTPClient!
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient;
    }
    
    init() {
        defaultInitialization()
    }
    
    func defaultInitialization(){
    }
    
    func get<T: Decodable>(url: String, httpMethod: NetworkHttpMethod, parameters: [String: Any]?, success:@escaping (T)-> (), failure:@escaping (NetworkError)->()) {
        guard let requestURL = URL(string:  baseUrl+url ), !(url.isEmpty) else {
            failure(RequesetDataError.urlInputError)
            return
        }
        self.httpClient.get(from: requestURL) { (resultValue:HTTPClient.Result) in
            switch resultValue {
            case .failure(let error):
                failure(ResponseError(error: error))
                break
            case .success((let data, let response)):
                
                if (response.statusCode >  299) {
                    failure(ResponseError.noDataFound)
                    return
                }
                debugPrint("response is \(response)")
                let decodedValue: T? = self.decode(responseData: data)
                if let decodedValue = decodedValue {
                    success(decodedValue)
                }else {
                    failure(ResponseError.responseMapFailure)
                }
                break
            }
        }
    }
    
    func decode<T: Decodable>(responseData: Data) -> T? {
        do {
            let responseModel = try JSONDecoder().decode(T.self, from: responseData)
            return responseModel
        } catch {
            return nil
        }
    }
    
    enum NetworkHttpMethod: String {
        case get = "GET"
        case post = "POST"
    }

}
