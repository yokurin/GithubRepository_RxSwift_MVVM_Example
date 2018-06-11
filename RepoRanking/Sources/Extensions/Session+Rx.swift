//
//  Session+Rx.swift
//  RepoRanking
//
//  Created by 林　翼 on 2018/01/04.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
import RxSwift
import APIKit

extension Session : RxSwift.ReactiveCompatible {}

extension RxSwift.Reactive where Base: Session {

    public func send<T: Request>(request: T) -> Observable<T.Response> {
        return Observable.create { [base = self.base] observer in
            let task = base.send(request) { result in
                switch result {
                case .success(let response):
                    observer.on(.next(response))
                    observer.on(.completed)
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                task?.cancel()
            }
        }
    }
}

