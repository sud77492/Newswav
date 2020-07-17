//
//  HomeVC.swift
//  NewsWav Project
//
//  Created by Sudhanshu Sharma (HLB) on 13/07/2020.
//  Copyright © 2020 Sudhanshu Sharma (HLB). All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reachability

class HomeVC: UITableViewController {
    
    @IBOutlet private weak var gistTableView : UITableView!
    
    var gistViewModel = GistViewModel()
    
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gistTableView.dataSource = nil
        gistTableView.delegate = nil
        setupBinding()
    }
    
    
    private func setupBinding(){
        gistViewModel.loading
        .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        gistViewModel
        .error
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { (error) in
            switch error {
            case .internetError(let message):
                MessageView.sharedInstance.showOnView(message: message, theme: .error)
            case .serverMessage(let message):
                MessageView.sharedInstance.showOnView(message: message, theme: .warning)
            }
        })
        .disposed(by: disposeBag)
        
        gistTableView
        .rx.setDelegate(self)
        .disposed(by: disposeBag)
        
        gistTableView.register(UINib(nibName: "GistItemCell", bundle: nil), forCellReuseIdentifier: String(describing: GistItemTableViewCell.self))
        
        gistViewModel.gists.bind(to: gistTableView.rx.items(cellIdentifier: "GistItemTableViewCell", cellType: GistItemTableViewCell.self)) { (row,item,cell) in
            cell.gist = item
        }.disposed(by: disposeBag)

        gistViewModel.requestData()
        
        gistTableView
        .rx
        .modelSelected(Gist.self)
        .subscribe(onNext: { (model) in

            self.performSegue(withIdentifier: "detail", sender: model)
        }).disposed(by: disposeBag)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detail"){
            let detailVC = segue.destination as! DetailVC
            detailVC.gist = sender as? Gist
        }
    }
}
