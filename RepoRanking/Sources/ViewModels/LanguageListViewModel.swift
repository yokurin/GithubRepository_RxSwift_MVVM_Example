//
//  LanguageListViewModel.swift
//  RepoRanking
//
//  Created by 林　翼 on 2018/01/23.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import RxSwift
import RxCocoa

final class LanguageListViewModel {

    // MARK: - Inputs

    let selectLanguage: AnyObserver<String>
    let cancel: AnyObserver<Void>


    // MARK: Outputs
    let languages: Observable<[String]>
    let didSelectLanguage: Observable<String>
    let didCancel: Observable<Void>

    init() {
        let _selectLanguage = PublishSubject<String>()
        let _cancel = PublishSubject<Void>()

        // Setup Inputs
        languages = GithubService.getLanguageList()
        didSelectLanguage = _selectLanguage.asObservable()
        didCancel = _cancel.asObservable()

        // Setup Outputs
        selectLanguage = _selectLanguage.asObserver()
        cancel = _cancel.asObserver()


    }
}
