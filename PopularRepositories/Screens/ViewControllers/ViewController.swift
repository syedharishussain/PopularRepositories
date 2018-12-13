//
//  ViewController.swift
//  PopularRepositories
//
//  Created by Syed Haris Hussain on 12/12/2018.
//  Copyright © 2018 UMI Urban Mobility International GmbH. All rights reserved.
//

import UIKit
import RxSwiftExt
import RxSwift
import RxCocoa
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private let viewModel: ViewController.ViewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Popular Repositories"
        
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(fetchSearchResults), for: .valueChanged)
        
        self.fetchSearchResults()
        self.bindSearchResultItems()
        self.bindError()
        self.cellTapHandling()
    }
    
    @objc private func fetchSearchResults() {
        self.viewModel.getRepositories()
            .do(
                onCompleted: {self.refreshControl.endRefreshing()},
                onSubscribe: {self.refreshControl.beginRefreshing()}
            )
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindSearchResultItems() {
        
        self.viewModel.items
            .asObservable()
            .bind(to: self.tableView.rx.items(
                cellIdentifier: String(describing: SearchResultCell.self),
                cellType: SearchResultCell.self
            )) { _, item, cell in
                cell.viewModel = SearchResultCell.ViewModel(item: item)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindError() {
        self.viewModel.error
            .asObservable()
            .unwrap()
            .subscribe(onNext: { AlertView(
                presentingController: self,
                title: "Error",
                message: $0.localizedDescription
                ).show()}
            )
            .disposed(by: disposeBag)
    }
    
    private func cellTapHandling() {
        self.tableView.rx
            .modelSelected(SearchResult.Item.self)
            .subscribe(onNext: { item in
                
                guard let controller = UIStoryboard.init(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
                    else {return}
                
                controller.viewModel = DetailViewController.ViewModel(item: item)
                self.navigationController?.pushViewController(controller, animated: true)
                
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController {
    
    struct ViewModel {
        
        let items = Variable<[SearchResult.Item]>([])
        let error = Variable<Error?>(nil)
        
        private let disposeBag = DisposeBag()
        
        init() {
            _ = self.getRepositories().asObservable().subscribe().disposed(by: disposeBag)
        }
        
        func getRepositories() -> Observable<Empty> {
            
            return Observable.create { observer -> Disposable in
                AF.request(AppConstants.apiUrl)
                    .responseDecodable(
                        decoder: AppConstants.decoder,
                        completionHandler: { (response: DataResponse<SearchResult>) in
                            
                            switch response.result {
                            case .success(let value):
                                self.items.value = value.items
                            case .failure(let error):
                                self.error.value = error
                            }
                            
                            observer.onCompleted()
                    })
                return Disposables.create()
            }
        }
    }
}
