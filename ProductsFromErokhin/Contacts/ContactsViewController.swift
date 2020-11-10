//
//  ContactsViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift

class ContactsViewController: UIViewController {

    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var call: UIButton!
    
    var viewModel: ContactsViewModel? // di
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindContacts()
        setupCallAction()
    }
    
    private func bindContacts() {
        viewModel?.contacts()
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }
            .compactMap { $0.first }
            .subscribe(onNext: { [weak self] in
                self?.phone.text = $0.phone
                self?.address.text = $0.address
            }).disposed(by: disposeBag)
    }
    
    private func setupCallAction() {
        call.rx.tap
            .asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .drive(onNext: { [weak self] in
                self?.viewModel?.open(link: "telprompt://\(self?.phone.text ?? "")")
            }).disposed(by: disposeBag)
    }

}
