//
//  ProfileViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 08.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var save: UIButton!
    
    var viewModel: ProfileViewModel? // di
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindProfile()
        setupSaveAction()
    }
    
    private func bindProfile() {
        viewModel?.profile().subscribe(onNext: { [weak self] in
            self?.name.text = $0.name
            self?.phone.text = $0.phone
            self?.address.text = $0.address
        }).disposed(by: disposeBag)
    }
    
    private func setupKeyboardForProfile() {
        name?.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.textFieldShouldReturn(self?.name)
            }).disposed(by: disposeBag)
        
        phone?.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.textFieldShouldReturn(self?.phone)
            }).disposed(by: disposeBag)
        
        address?.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.textFieldShouldReturn(self?.address)
            }).disposed(by: disposeBag)
    }
    
    private func textFieldShouldReturn(_ textField: UITextField?) {
      if IQKeyboardManager.shared.canGoNext {
        IQKeyboardManager.shared.goNext()
      } else {
        textField?.resignFirstResponder()
      }
    }
    
    private func setupSaveAction() {
        save.rx.tap.asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .asObservable()
            // Get data for profile
            .flatMapLatest { [weak self] _ -> Observable<(name: String?, phone: String?, address: String?)> in
                guard let name = self?.name,
                      let phone = self?.phone,
                      let address = self?.address
                else {
                    return Observable.empty()
                }
                return Observable.just((name.text, phone.text, address.text))
            }
            // Update profile
            .observeOn(SerialDispatchQueueScheduler.init(qos: .userInteractive))
            .flatMap { [weak self] profile -> Observable<Result<Void, Error>> in
                guard let viewModel = self?.viewModel else {
                    return Observable.empty()
                }
                return Observable.just(
                    viewModel.updateProfile(name: profile.name, phone: profile.phone, address: profile.address)
                )
            }
            // Show result message
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
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
