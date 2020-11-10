//
//  AboutAppViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift

class AboutAppViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var privacy: UIButton!
    @IBOutlet weak var update: UIButton!
    
    var viewModel: AboutAppViewModel? // di
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindInfo()
        setupPrivacyActions()
        setupUpdateActions()
        setupUpdateVisibility()
    }
    /** Set data to name, version */
    private func bindInfo() {
        name.text = viewModel?.name()
        version.text = viewModel?.version()
    }
    
    private func setupPrivacyActions() {
        privacy.rx.tap
            .asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .asObservable()
            .flatMapLatest { [weak self] in
                self?.aboutApp().take(1) ?? Observable.empty()
            }.map { $0.privacy }
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.open(link: $0)
            }).disposed(by: disposeBag)
    }
    
    private func setupUpdateActions() {
        update.rx.tap
            .asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .asObservable()
            .flatMapLatest { [weak self] in
                self?.aboutApp().take(1) ?? Observable.empty()
            }.map { $0.appStore }
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.open(link: $0)
            }).disposed(by: disposeBag)
    }
    
    private func setupUpdateVisibility() {
        aboutApp().map { [weak self] in
            $0.version == self?.viewModel?.version() ?? ""
        }
        .bind(to: update.rx.isHidden)
        .disposed(by: disposeBag)
    }
    
    private func aboutApp() -> Observable<AboutApp> {
        viewModel?.aboutApp()
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }.compactMap { $0.first } ?? Observable.empty()
    }

}
