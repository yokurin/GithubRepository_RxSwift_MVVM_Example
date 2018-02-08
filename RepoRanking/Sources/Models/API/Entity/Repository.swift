//
//  Repository.swift
//  RepoRanking
//
//  Created by 林　翼 on 2018/01/04.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

//struct Repository: Codable {
//    let id: Int
//    let full_name: String
//    let description: String
//    let stargazers_count: Int
//    let url: String
//}

struct Repository: Decodable {
    let id: Int
    let fullName: String
    let description: String
    let stargazersCount: Int
    let url: String

    private enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case description
        case stargazersCount = "stargazers_count"
        case url = "html_url"
    }
}

struct RepositoriesRankingResponse: Decodable {
    let items: [Repository]
}
