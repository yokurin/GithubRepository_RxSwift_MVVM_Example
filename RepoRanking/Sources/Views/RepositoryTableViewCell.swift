//
//  RepositoryTableViewCell.swift
//  RepoRanking
//
//  Created by 林　翼 on 2018/01/10.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit

final class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var startCountLabel: UILabel!

    func configure(repogitory: RepositoryViewModel) {
        nameLabel.text = repogitory.name
        descriptionLabel.text = repogitory.description
        startCountLabel.text = repogitory.starsCountText
    }
    
}
