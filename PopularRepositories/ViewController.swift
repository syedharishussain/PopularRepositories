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
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel: ViewController.ViewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Popular Repositories"
        
        self.bindDataSource()
        self.cellTapHandling()
    }
    
    private func bindDataSource() {
        self.viewModel.getRepositories()
            .subscribe(onNext: { (searchResult) in
                Observable.of(searchResult.items)
                    .bind(to: self.tableView.rx.items(
                        cellIdentifier: String(describing: SearchResultCell.self),
                        cellType: SearchResultCell.self
                    )) { _, item, cell in
                        cell.viewModel = SearchResultCell.ViewModel(item: item)
                    }
                    .disposed(by: self.disposeBag)
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            })
            .disposed(by: disposeBag)
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
                
                SVProgressHUD.showInfo(withStatus: "Loading..")
                
                AF.request(AppConstants.apiUrl)
                    .responseDecodable(
                        decoder: AppConstants.decoder,
                        completionHandler: { (response: DataResponse<SearchResult>) in
                            
                            SVProgressHUD.dismiss()
                            
                            switch response.result {
                            case .success(let value):
                                observer.onNext(value)
                                
                            case .failure(let error):
                                observer.onError(error)
                            }
                    })
                
                return Disposables.create()
            }
            
        }
    }
}
