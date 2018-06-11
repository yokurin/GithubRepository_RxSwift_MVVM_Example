//
//  GitHubAPI.swift
//  RepoRanking
//
//  Created by 林　翼 on 2018/01/04.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
import APIKit
import RxSwift

final class GitHubAPI {
    private init(){}

    struct RepositoriesRanking: GitHubRequest {
        typealias Response = RepositoriesRankingResponse

        let method: HTTPMethod = .get
        let path: String = "/search/repositories"
        var parameters: Any? {
            return [
                "q": language,
                "sort": "stars"
            ]
        }
        let language: String
    }
}

final class GithubService {

    /// - Returns: a list of languages from GitHub.
    static func getLanguageList() -> Observable<[String]> {
        return Observable.just([
            "Swift",
            "Objective-C",
            "Java",
            "C",
            "C++",
            "Python",
            "C#",
            "Ruby"
            ])
    }

    /// - Parameter language: Language to filter by
    /// - Returns: A list of most popular repositories filtered by langugage
    static func mostPopularRepositories(byLanguage language: String) -> Observable<[Repository]> {
        return Session.shared.rx
            .send(request: GitHubAPI.RepositoriesRanking(language: language))
            .map({ (response) -> [Repository] in
                response.items
            })
    }
}
