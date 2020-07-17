//
//  Gist.swift
//  NewsWav Project
//
//  Created by Sudhanshu Sharma (HLB) on 13/07/2020.
//  Copyright © 2020 Sudhanshu Sharma (HLB). All rights reserved.
//

import Foundation

struct Gist : Codable {
    let id : String
    let description : String
    let owner: Owner?
    let files: [String: GistFile]
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case owner
        case files
    }
    
    func getFirstFileName() -> String {
        return Array(files)[0].key
    }
    
    
}

struct Owner : Codable {
    let avatar_url : String
    
    enum CodingKeys: String, CodingKey {
        case avatar_url
    }
}

extension Gist {
    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(Gist.self, from: data)
            self = me
        }
        catch {
            print(error)
            return nil
        }
    }
}


