//
//  RepositoryListViewController.swift
//  RepoRanking
//
//  Created by 林　翼 on 2018/01/10.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices


final class RepositoryListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: RepositoryTableViewCell.className, bundle: nil), forCellReuseIdentifier: RepositoryTableViewCell.className)
        }
    }
    private let chooseLanguageButton = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
    private let refreshControl = UIRefreshControl()

    let viewModel = RepositoryListViewModel(initialLanguage: "Swift")
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        navigationItem.rightBarButtonItem = chooseLanguageButton
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.insertSubview(refreshControl, at: 0)
        refreshControl.sendActions(for: .valueChanged)
    }

    private func setupBindings() {
        viewModel.repositories
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() })
            .bind(to: tableView.rx
                        .items(cellIdentifier: RepositoryTableViewCell.className,cellType: RepositoryTableViewCell.self)){ (tableView, repo, cell) in
                            cell.configure(repogitory: repo)
                        }
            .disposed(by: disposeBag)

        viewModel.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.showRepository
            .subscribe(onNext: { [weak self] in self?.openRepository(by: $0) })
            .disposed(by: disposeBag)

        viewModel.showLanguageList
            .subscribe(onNext: { [weak self] in self?.openLanguageList() })
            .disposed(by: disposeBag)

        viewModel.alertMessage
            .subscribe(onNext:{ [weak self] in self?.presentAlert(message: $0 )})
            .disposed(by: disposeBag)


        // MARK: - View Controller UI actions to the View Model

        tableView.rx.modelSelected(RepositoryViewModel.self)
            .bind(to: viewModel.selectRepository)
            .disposed(by: disposeBag)

        chooseLanguageButton.rx.tap
            .bind(to: viewModel.chooseLanguage)
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
    }

    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }

    // MARK: - Navigation

    private func openRepository(by url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        navigationController?.pushViewController(safariViewController, animated: true)
    }

    private func openLanguageList() {
        let languageListViewController = LanguageListViewController.instantiate()
        let languageListViewModel = LanguageListViewModel()

        let dismiss = Observable.merge([
            languageListViewModel.didCancel,
            languageListViewModel.didSelectLanguage.map { _ in }
        ])

        dismiss
            .subscribe(onNext: {[weak self] in self?.dismiss(animated: true) })
            .disposed(by: disposeBag)

        languageListViewModel.didSelectLanguage
            .bind(to: viewModel.setCurrentLanguage)
            .disposed(by: disposeBag)

        languageListViewController.viewModel = languageListViewModel
        let nvc = UINavigationController(rootViewController: languageListViewController)
        self.present(nvc, animated: true)
    }

}

protocol StoryBoardInstantiatable {}
extension UIViewController: StoryBoardInstantiatable {}

extension StoryBoardInstantiatable where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: self.className, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }

    static func instantiate(withStoryboard storyboard: String) -> Self {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }
}


