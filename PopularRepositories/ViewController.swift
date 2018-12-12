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
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: SearchResultTableView!
    
    let viewModel: ViewController.ViewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getRepositories()
            .subscribe(onNext: { [weak self] (searchResult) in
            self?.tableView.items.value = searchResult.items
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            
        }).disposed(by: disposeBag)
        
        tableView.bindDataSource()
    }
}

extension ViewController {
    
    struct ViewModel {
        
        func getRepositories() -> Observable<SearchResult> {
            
            return Observable.create { observer -> Disposable in
                AF.request(AppConstants.apiUrl)
                    .validate()
                    .responseDecodable(
                        decoder: AppConstants.decoder,
                        completionHandler: { (response: DataResponse<SearchResult>) in
                            
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
