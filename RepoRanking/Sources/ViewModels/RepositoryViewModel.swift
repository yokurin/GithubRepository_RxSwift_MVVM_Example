//
//  RepositoryViewModel.swift
//  RepoRanking
//
//  Created by 林　翼 on 2018/01/05.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

final class RepositoryViewModel {
    let name: String
    let description: String
    let starsCountText: String
    let url: URL

    init(repository: Repository) {
        name = repository.fullName
        description = repository.description
        starsCountText = "★ \(repository.stargazersCount)"
        url = URL(string: repository.url)!
    }
}
