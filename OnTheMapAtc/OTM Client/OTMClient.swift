//
//  OTMClient.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/24/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

class OTMClient {
    
    enum EndPoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let udacitySignUpUrl = "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
        static let studentLocationsBaseUrl = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        case login
        case signUp
        case getLocations(Int, Int)
        
        var stringValue: String {
            switch self {
                case .login:
                    return EndPoints.base + "/session"
                case .signUp:
                    return EndPoints.udacitySignUpUrl
                case .getLocations(let limit, let skip):
                    return EndPoints.studentLocationsBaseUrl + "?limit=\(limit)&skip=\(skip)&order=-updatedAt"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let loginInfo = Udacity(username: username, password: password)
        let loginBody = LoginRequest(loginInfo: loginInfo)
        
        taskForPOSTRequest(url: EndPoints.login.url, responseType: PostSession.self, body: loginBody) { (response, error) in
            if let response = response {
                //Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(limit: Int, skip: Int, completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        let getLocationsUrl = EndPoints.getLocations(limit, skip).url
        taskForGETRequest(url: getLocationsUrl, response: StudentLocations.self) { (response, error) in
                if let response = response {
                    completion(response.results, nil)
                } else {
                    completion([], error)
                }
        }
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping(ResponseType?, Error?) -> Void)  -> URLSessionTask{
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
            
        }
            task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping(ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}

