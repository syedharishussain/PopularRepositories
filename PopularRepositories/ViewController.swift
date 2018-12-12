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
import SVProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    let viewModel: ViewController.ViewModel = ViewModel()
    let disposeBag = DisposeBag()
    let searchResult = Variable<SearchResult?>(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Popular Repositories"
        
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(fetchSearchResults), for: .valueChanged)

        self.fetchSearchResults()
        self.bindSearchResultItems()
        self.cellTapHandling()
    }
    
    @objc func fetchSearchResults() {
        self.viewModel.getRepositories()
            .do(onSubscribe: {self.refreshControl.beginRefreshing()})
            .subscribe(
                onNext: {self.searchResult.value = $0},
                onError: {SVProgressHUD.showError(withStatus: $0.localizedDescription)},
                onCompleted: {self.refreshControl.endRefreshing()}
            ).disposed(by: disposeBag)
    }
    
    @objc private func bindSearchResultItems() {
        
        self.searchResult
            .asObservable()
            .unwrap()
            .map({$0.items})
            .bind(to: self.tableView.rx.items(
                cellIdentifier: String(describing: SearchResultCell.self),
                cellType: SearchResultCell.self
            )) { _, item, cell in
                cell.viewModel = SearchResultCell.ViewModel(item: item)
            }
            .disposed(by: self.disposeBag)
    }
    
    func cellTapHandling() {
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
        
        func getRepositories() -> Observable<SearchResult> {
            return Observable.create { observer -> Disposable in
                AF.request(AppConstants.apiUrl)
                    .responseDecodable(
                        decoder: AppConstants.decoder,
                        completionHandler: { (response: DataResponse<SearchResult>) in
                            
                            switch response.result {
                            case .success(let value): observer.onNext(value)
                            case .failure(let error): observer.onError(error)
                            }
                            
                            observer.onCompleted()
                    })
                return Disposables.create()
            }
            
        }
    }
}
