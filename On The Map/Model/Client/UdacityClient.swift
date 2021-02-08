//
//  UdacityClient.swift
//  On The Map
//
//  Created by Asma  on 1/12/21.
//

import Foundation

class UdacityClient{
    
    static var sessionID = ""
    static var userId = ""
    
    enum Endpoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case webAuth
        case getStudentLocations(limit:Int?,skip:Int?,order:String?,uniqueKey :String?)
        case getuserData(String)
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            case .session:return Endpoints.base + "/session"
            case .webAuth:return("https://auth.udacity.com/sign-up")
            case let .getStudentLocations( limit, skip, order, uniqueKey):
                var composedUrl=Endpoints.base + "/StudentLocation"
                if let limit=limit{
                    composedUrl+="?limit=\(limit)"
                    if let skip=skip{
                        composedUrl+="&skip=\(skip)"
                    }
                }
                if let order=order{
                    composedUrl+="&order=\(order)"
                }
                if let uniqueKey=uniqueKey{
                    composedUrl+="?uniqueKey=\(uniqueKey)"
                }
                return composedUrl
            case let .getuserData( userID):
                return Endpoints.base+"/users/\(userID)"
            case .postStudentLocation:
                return Endpoints.base+"/StudentLocation"
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type,trimResponse:Bool, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard var data = data else {
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if(trimResponse){
                let range = (5..<data.count)
                  let newData = data.subdata(in: range) /* subset response data! */
                data=newData
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    print(String(data: data, encoding: .utf8)!)
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: data) as Error
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
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, trimResponse:Bool, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if(trimResponse){
                let range = (5..<data.count)
                  let newData = data.subdata(in: range) /* subset response data! */
                  
                data=newData
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    print(String(data: data, encoding: .utf8)!)
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: data) as Error
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
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = AuthenticationRequest(username: username, password: password)
        taskForPOSTRequest(url: Endpoints.session.url, responseType: AuthenticationResponse.self,trimResponse:true, body: body) { response, error in
            if let response = response {
                self.sessionID = response.session.id
                self.userId=response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func postStudentLocation(post:PostStudentLocationRequest, completion: @escaping (Bool, Error?) -> Void) {
        let body = post
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostStudentLocationResponse.self,trimResponse:false, body: body) { response, error in
            if response != nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(limit:Int?, skip:Int?, order:String?, uniqueKey:String?, completion: @escaping ([StudentInformation], Error?) -> Void)->URLSessionDataTask {
        
        return taskForGETRequest(url: Endpoints.getStudentLocations(limit:limit,skip:skip,order:order,uniqueKey:uniqueKey).url, responseType: StudentLocationsResponse.self, trimResponse: false) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getUserData(userId:String, completion: @escaping (UserDataResponse?, Error?) -> Void) {
        
        taskForGETRequest(url: Endpoints.getuserData(userId).url, responseType: UserDataResponse.self, trimResponse: true) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            UdacityClient.sessionID = ""
            UdacityClient.userId=""
            completion()
            
        }
        task.resume()
    }
}
