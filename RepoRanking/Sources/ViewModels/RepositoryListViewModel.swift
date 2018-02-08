//
//  RepositoryListViewModel.swift
//  RepoRanking
//
//  Created by 林　翼 on 2018/01/05.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
import RxSwift

final class RepositoryListViewModel {

    // MARK: - Inputs

    /// Call to update current language. Causes reload of the repositories.
    /// 言語選択から戻る時に発火
    let setCurrentLanguage: AnyObserver<String>

    /// Call to show language list screen.
    /// 言語選択をタップされた情報
    let chooseLanguage: AnyObserver<Void>

    /// Call to open repository page.
    /// 選択された(タップされた)レポジトリ
    let selectRepository: AnyObserver<RepositoryViewModel>

    /// Call to reload repositories. (refresh control)
    /// reload フラグ (リフレッシュコントロールで使う)
    let reload: AnyObserver<Void>


    // MARK: - Outputs
    // 外からアクセスされるもの
    
    /// Emits an array of fetched repositories.
    /// フェッチしてきたレポジトリのリスト
    let repositories: Observable<[RepositoryViewModel]>

    /// Emits a formatted title for a navigation item.
    /// ナビゲーションバーのタイトル (なぜoutputなのか?)
    let title: Observable<String>

    /// Emits an error messages to be shown.
    /// エラーメッセージなど
    let alertMessage: Observable<String>

    /// Emits an url of repository page to be shown.
    /// レポジトリが選択された時にURLをバインドする用
    let showRepository: Observable<URL>

    /// Emits when we should show language list.
    /// 言語一覧に遷移するときに発火させる用
    let showLanguageList: Observable<Void>

    init(initialLanguage: String, githubService: GithubService = GithubService()) {

        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()

        let _currentLanguage = BehaviorSubject<String>(value: initialLanguage)
        self.setCurrentLanguage = _currentLanguage.asObserver()

        self.title = _currentLanguage.asObservable()
            .map { "\($0)" }

        let _alertMessage = PublishSubject<String>()
        self.alertMessage = _alertMessage.asObservable()

        self.repositories = Observable
            .combineLatest( _reload, _currentLanguage) { _, language in
                print(language)
                return language
            }
            .flatMapLatest { language in
                GithubService.mostPopularRepositories(byLanguage: language)
                    .catchError { error in
                        _alertMessage.onNext(error.localizedDescription)
                        return Observable.empty()
                }
            }
            .map { repositories in repositories.map(RepositoryViewModel.init) }

        let _selectRepository = PublishSubject<RepositoryViewModel>()
        self.selectRepository = _selectRepository.asObserver()
        self.showRepository = _selectRepository.asObservable()
            .map { $0.url }

        let _chooseLanguage = PublishSubject<Void>()
        self.chooseLanguage = _chooseLanguage.asObserver()
        self.showLanguageList = _chooseLanguage.asObservable()
    }
}
