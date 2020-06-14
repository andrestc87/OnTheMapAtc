//
//  OTMClient.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/24/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

class OTMClient {
    
    struct Auth {
        static var accountKey = ""
        static var objectid = ""
        static var uniqueKey = ""
        static var firstName = ""
        static var lastName = ""
        static var mapString = ""
        static var mediaUrl = ""
        static var latitude : Double = 0.0
        static var longitude : Double = 0.0
    }
    
    enum EndPoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let udacitySignUpUrl = "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
        static let studentLocationsBaseUrl = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let userDataURL = "https://onthemap-api.udacity.com/v1/users"
        
        case login
        case logout
        case signUp
        case getLocations(Int, Int)
        case getStudentData(String)
        case updateStudentLocation(String)
        case saveStudentLocation
        
        var stringValue: String {
            switch self {
                case .login:
                    return EndPoints.base + "/session"
                case .logout:
                    return EndPoints.base + "/session"
                case .signUp:
                    return EndPoints.udacitySignUpUrl
                case .getLocations(let limit, let skip):
                    return EndPoints.studentLocationsBaseUrl + "?limit=\(limit)&skip=\(skip)&order=-updatedAt"
                case .getStudentData(let userId):
                    return EndPoints.userDataURL + "/\(userId)"
                case .updateStudentLocation(let objectId):
                    return EndPoints.studentLocationsBaseUrl + "/\(objectId)"
                case .saveStudentLocation:
                return EndPoints.studentLocationsBaseUrl
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let loginInfo = Udacity(username: username, password: password)
        let loginBody = LoginRequest(loginInfo: loginInfo)
        
        taskForPOSTRequest(shouldSubSetData:true, url: EndPoints.login.url, responseType: PostSession.self, body: loginBody) { (response, error) in
            if let response = response {
                Auth.accountKey = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: EndPoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            completion(false, error)
            return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
            completion(true, nil)
        }
        task.resume()
    }
    
    class func getStudentLocations(limit: Int, skip: Int, completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        let getLocationsUrl = EndPoints.getLocations(limit, skip).url
        taskForGETRequest(shouldSubSetData: false, url: getLocationsUrl, response: StudentLocations.self) { (response, error) in
                if let response = response {
                    completion(response.results, nil)
                } else {
                    completion([], error)
                }
        }
    }
    
    class func getStudentData(completion: @escaping (Bool, Error?) -> Void) {
        let getStudentDataUrl = EndPoints.getStudentData(Auth.accountKey).url
        taskForGETRequest(shouldSubSetData:true, url: getStudentDataUrl, response: StudentDataResponse.self) { (response, error) in
                if let response = response {
                    Auth.firstName = response.firstName ?? "No First Name"
                    Auth.lastName = response.lastName ?? "No Last Name"
                    Auth.uniqueKey = response.uniqueKey ?? ""
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
        }
    }
    
    class func saveStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        let saveStudentBody = StudentLocationRequest(uniqueKey: String(describing: Auth.uniqueKey) , firstName: String(describing: Auth.firstName), lastName: String(describing: Auth.lastName), mapString: String(describing: Auth.mapString), mediaURL: String(describing: Auth.mediaUrl), latitude: Auth.latitude, longitude: Auth.longitude)
        
        taskForPOSTRequest(shouldSubSetData:false, url: EndPoints.saveStudentLocation.url, responseType: PostStudentLocationResponse.self, body: saveStudentBody) { (response, error) in
            if let response = response {
                print("POST SUCCESSFUL")
                Auth.objectid = response.objectId
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func updateStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        let updateStudentLocationUrl = EndPoints.updateStudentLocation(Auth.objectid).url
        let saveStudentBody = StudentLocationRequest(uniqueKey: String(describing: Auth.uniqueKey) , firstName: String(describing: Auth.firstName), lastName: String(describing: Auth.lastName), mapString: String(describing: Auth.mapString), mediaURL: String(describing: Auth.mediaUrl), latitude: Auth.latitude, longitude: Auth.longitude)
        
        taskForPUTRequest(url: updateStudentLocationUrl, responseType: PutStudentLocationResponse.self, body: saveStudentBody) { (response, error) in
            if let response = response {
                print("PUT SUCCESSFUL")
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(shouldSubSetData: Bool, url: URL, response: ResponseType.Type, completion: @escaping(ResponseType?, Error?) -> Void)  -> URLSessionTask{
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if shouldSubSetData {
                let range = (5..<data.count)
                data = data.subdata(in: range) /* subset response data! */
                print(String(data: data, encoding: .utf8)!)
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
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(shouldSubSetData: Bool, url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping(ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if shouldSubSetData {
                let range = (5..<data.count)
                data = data.subdata(in: range) /* subset response data! */
                print(String(data: data, encoding: .utf8)!)
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: data) as Error
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
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping(ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
                print(error)
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: data) as Error
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


