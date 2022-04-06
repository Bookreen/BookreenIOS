//
//  CommonApi.swift
//  Bookreen
//
//  Created by bullhead on 12/3/21.
//

import Foundation
import RxSwift
import Alamofire


//let baseUrl="http://192.168.1.20:9876/chat/"

func makeRequest<T : Decodable>(_ request:URLRequest,
                                      errorMessage:String?=nil,
                                      type:T.Type=T.self)->Single<T>{
    Single<T>.create { emitter in
        let task=AF.request(request).responseData{response in
            if response.response?.statusCode ?? 0 > 300{
                emitter(.failure(response.toError()))
            }else{
                switch response.result{
                case .success:
                    do {
                        let decoder=JSONDecoder()
                        try decoder.configureDateParse()
                        let t=try decoder.decode(T.self, from: response.value!)
                        emitter(.success(t))
                    } catch(let parseError) {
                        if type == JunkResponse.self{
                            return emitter(.success(JunkResponse() as! T))
                        }
                        print(parseError)
                        emitter(.failure(parseError))
                    }
                case .failure(let err):
                    if type == JunkResponse.self{
                        return emitter(.success(JunkResponse() as! T))
                    }
                    emitter(.failure(err))
                }
            }
        }
        
        return Disposables.create{
            task.cancel()
        }
    }
    
}

func makeMultiPartRequest<T:Codable>(_ data:MultipartFormData,
                                     _ auth:String,
                                     _ path:String,
                                     type:T.Type=T.self)->Single<T>{
    let headers : HTTPHeaders   = [
        "Authorization": auth,
        "Content-Type": "multipart/form-data",
    ]
    return Single.create { emitter in
        let request=AF.upload(multipartFormData:data, to:"\(baseUrl)\(path)",headers: headers).responseData{response in
            if response.response?.statusCode != 200{
                emitter(.failure(response.toError()))
            }else{
                switch response.result{
                case .success:
                    do {
                        let t=try JSONDecoder().decode(T.self, from: response.value!)
                        emitter(.success(t))
                    } catch(let parseError) {
                        print(parseError)
                        emitter(.failure(parseError))
                    }
                case .failure(let err):
                    emitter(.failure(err))
                }
            }
        }
        
        return Disposables.create {
            request.cancel()
        }
    }
}

extension AFDataResponse{
    func toError()->NSError{
        guard let status = self.response?.statusCode else {
            return NSError(domain: "unknown", code: -1, userInfo: [NSLocalizedDescriptionKey:"no status code"])
        }
        if let data=self.data, let message=String(data: data, encoding: .utf8){
            return NSError(domain: "server", code: status, userInfo: [NSLocalizedDescriptionKey:message])
        }
        return NSError(domain: "unknown", code: -1003, userInfo: [NSLocalizedDescriptionKey:"Unknown error \(status)"])
    }
}

extension URLRequest{
    init(for endPoint:String) {
        guard let url=URL(string: "\(baseUrl)\(endPoint)") else {
            fatalError("cannot make url for end point \(endPoint)")
        }
        self.init(url: url)
        if let langCode=Locale.current.languageCode{
            self.addValue(langCode, forHTTPHeaderField: "Accept-Language")
        }
    }
    
    init(withMobile endPoint:String) {
        guard let url=URL(string: "\(baseUrl)/mobile\(endPoint)") else {
            fatalError("cannot make url for end point \(endPoint)")
        }
        self.init(url: url)
        if let langCode=Locale.current.languageCode{
            self.addValue(langCode, forHTTPHeaderField: "Accept-Language")
        }
    }
    
    func authenticated(_ token:String)->Self{
        var copy=self
        copy.addValue(token, forHTTPHeaderField: "Authorization")
        return copy
    }
    
    
    func formEncoded(_ params:[String:Any], method:HTTPMethod = .post,withToken:Bool=true)->Self{
        var copy=self
        var p=params
        if withToken{
            p["Token"]=SessionManager.shared.token
        }
        copy.method = method
        copy.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        copy.httpBody=p.percentEncoded()
        return copy
    }
    
    func method(_ method:HTTPMethod)->Self{
        var copy=self
        copy.method=method
        return copy
    }
    
    func json<T:Encodable>(_ body:T, method:HTTPMethod = .post)->Self{
        var copy=self
        copy.method = method
        copy.setValue("application/json", forHTTPHeaderField: "Content-Type")
        copy.httpBody = try? JSONEncoder().encode(body)
        return copy
    }
    
    func perform<T:Decodable>(_ errorMessage:String? = nil) -> Single<T> {
        makeRequest(self,errorMessage: errorMessage)
    }
    
    func perform<T:Decodable>(type:T.Type, _ errorMessage:String? = nil) -> Single<T> {
        makeRequest(self,errorMessage: errorMessage)
    }
    
    func perform(_ errorMessage:String?=nil)->Completable{
        makeRequest(self,type: JunkResponse.self).asCompletable()
    }
}
func makeError(text key:String)->Error{
    return NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey : key])
}
struct JunkResponse : Codable{}
