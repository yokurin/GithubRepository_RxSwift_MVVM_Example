//
//  DecodableDataParser.swift
//  RepoRanking
//
//  Created by 林　翼 on 2018/01/04.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
import APIKit

final class DecodableDataParser: DataParser {
    var contentType: String? {
        return "application/json"
    }

    func parse(data: Data) throws -> Any {
        return data
    }
}
