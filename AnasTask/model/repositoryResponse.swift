//
//  repositoryResponse.swift
//  AnasTask
//
//  Created by mac on 16/06/2023.
//

import Foundation

struct RepositoryResponse:Codable {
    let id:Int
    let name:String
    let full_name:String
    let html_url:String
    let description:String?
    let watchers:Int
    let size:Int
    let created_at:String
    let updated_at:String
    let visibility:String
}
