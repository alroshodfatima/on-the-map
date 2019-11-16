//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Fatimah on 09/03/1441 AH.
//  Copyright © 1441 Fatimah. All rights reserved.
//

import Foundation

class UdacityClient {

struct Auth {
    static var sessionId = ""
    static var userId = "" // Account Key == uniqueKey
}

enum Endpoints {
    static let base = "https://onthemap-api.udacity.com/v1/"
    
    case login
    case logout
    case publicUser
    case studentLocation
    
    var stringValue: String {
        switch self {
        case .login: return Endpoints.base + "session"
        case .logout: return Endpoints.base + "session"
        case .publicUser: return Endpoints.base + "users/" + Auth.userId
        case .studentLocation: return Endpoints.base + "StudentLocation?order=-updatedAt"
        
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
    
    enum ApiType: String {
        case udacity
        case parse
    }
    
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        let credintials = Credintials(username: username, password: password)
        let body = Login(udacity: credintials)
        taskForPOSTRequest(apiType: ApiType.udacity,url: Endpoints.login.url, responseType: SessionResponse.self, body: body) { (response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
                return
            }
            if let response = response {
                Auth.userId = response.account.key
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
            }
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(apiType: ApiType, url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       request.httpBody = try! JSONEncoder().encode(body)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
          guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
        var newData: Data
        if apiType == ApiType.udacity{
            newData = data.subdata(in: 5..<data.count) /* subset response data! */
        } else {
            newData = data
        }
            
        let decoder = JSONDecoder()
        do {
            let json = try decoder.decode(ResponseType.self, from: newData)
           DispatchQueue.main.async {
               completion(json, nil)
           }
            
        } catch {
           do {
               let errorResponse = try decoder.decode(SessionError.self, from: newData)
               DispatchQueue.main.async {
                   completion(nil, errorResponse)
               }
           }catch {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            }
           }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping () -> Void) {

        var request = URLRequest(url: Endpoints.logout.url)
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
          if error != nil { // Handle error…
            completion()
              return
          }
            
         Auth.sessionId = ""
         completion()
        }
        task.resume()
    }
    
    class func getPublicUserData(completion: @escaping (User?, Error?) -> Void){
        taskForGETRequest(apiType: ApiType.udacity, url: Endpoints.publicUser.url, responseType: User.self) { (response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if let response = response {
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    
     class func taskForGETRequest<ResponseType: Decodable>(apiType: ApiType, url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
            DispatchQueue.main.async {
                completion(nil, error)
            }
              return
          }
            var newData: Data?
            if apiType == ApiType.udacity{
                newData = data?.subdata(in: 5..<data!.count) /* subset response data! */
            } else {
                newData = data
            }
          
           let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData!)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func getStudentLocations(completion: @escaping (StudentLocationResponse?, Error?) -> Void){
        taskForGETRequest(apiType: ApiType.parse, url: Endpoints.studentLocation.url, responseType: StudentLocationResponse.self) { (response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            guard let response = response else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(response, nil)
            }
        }
    }
    
    class func addingStudentLocation(longitude: Double, latitude: Double, location: String, mediaURL: String, completion: @escaping (StudentLocation?, Error?) -> Void){
        var request = URLRequest(url: Endpoints.studentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // GETTING THE PUBLIC USER DATA
        getPublicUserData { (user, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            guard let user = user else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
              return
            }
            
            var studentLocation = StudentLocation(objectId: "", uniqueKey: Auth.userId, firstName: user.firstName, lastName: user.lastName, mapString: location, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
            
            request.httpBody = try! JSONEncoder().encode(studentLocation)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                do {
                    // decode it and get the objectId and set it to studentLocation
                    let json = try JSONDecoder().decode(PostStudentLocationResponse.self, from: data)
                    studentLocation.objectId = json.objectId
                    DispatchQueue.main.async {
                        completion(studentLocation, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        } 
    }
}
