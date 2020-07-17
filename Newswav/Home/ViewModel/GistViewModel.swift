//
//  GistViewModel.swift
//  NewsWav Project
//
//  Created by Sudhanshu Sharma (HLB) on 13/07/2020.
//  Copyright © 2020 Sudhanshu Sharma (HLB). All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class GistViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let gists : PublishSubject<[Gist]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    
    public func requestData(){
        self.loading.onNext(true)
        APIManager.requestData(url: "https://api.github.com/users/sud77492/gists?access_token=\(Constants.APIKey)", method: .get, parameters: nil, completion: { (result) in
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson) :
                self.saveJSON(json: returnJson, key:"json")
                let gists = self.getJSON("json")?.arrayValue.compactMap {return Gist(data: try! $0.rawData())}
                self.gists.onNext(gists ?? [])

            case .failure(let failure):
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                    if self.isKeyPresentInUserDefaults(key: "json"){
                        let gists = self.getJSON("json")?.arrayValue.compactMap {return Gist(data: try! $0.rawData())}
                        self.gists.onNext(gists ?? [])
                    }
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        })
    }
    
    func saveJSON(json: JSON, key:String){
       if let jsonString = json.rawString() {
          UserDefaults.standard.setValue(jsonString, forKey: key)
       }
    }

    func getJSON(_ key: String)-> JSON? {
        var p = ""
        if let result = UserDefaults.standard.string(forKey: key) {
            p = result
        }
        if p != "" {
            if let json = p.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do {
                    return try JSON(data: json)
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}


