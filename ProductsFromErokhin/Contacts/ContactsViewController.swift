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
            .subscribeOn(SerialDispatchQueueScheduler.init(qos: .userInteractive))
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
                if let phone = self?.phone.text, !phone.isEmpty,
                   let url = URL(string: "telprompt://\(phone)"),
                   UIApplication.shared.canOpenURL(url)
                {
                    UIApplication.shared.open(url, options: [:])
                }
            }).disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
