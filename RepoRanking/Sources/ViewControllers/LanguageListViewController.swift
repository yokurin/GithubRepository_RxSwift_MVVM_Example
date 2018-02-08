//
//  LanguageListViewController.swift
//  RepoRanking
//
//  Created by 林　翼 on 2018/01/23.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit
import RxSwift

final class LanguageListViewController: UIViewController {

    let disposeBag = DisposeBag()
    var viewModel: LanguageListViewModel!
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Choose a language"

        tableView.rowHeight = 48.0
    }

    private func setupBindings() {

        viewModel.languages
            .subscribe(onNext: { languages in
                print(languages)
            })
            .disposed(by: disposeBag)

        viewModel.languages
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, language, cell) in
                cell.textLabel?.text = language
                cell.textLabel?.textColor = .black
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(String.self)
            .bind(to: viewModel.selectLanguage)
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .bind(to: viewModel.cancel)
            .disposed(by: disposeBag)
    }

}
