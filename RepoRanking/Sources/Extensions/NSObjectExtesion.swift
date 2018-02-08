//
//  NSObjectExtesion.swift
//  RepoRanking
//
//  Created by 林　翼 on 2018/01/15.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
