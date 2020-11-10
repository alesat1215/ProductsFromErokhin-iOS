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

        bindProfile()
        setupKeyboardForProfile()
        setupSaveAction()
    }

}

// MARK: - Profile
extension ProfileViewController {
    /** Set values to profile text fields */
    private func bindProfile() {
        viewModel?.profile().subscribe(onNext: { [weak self] in
            self?.name.text = $0.name
            self?.phone.text = $0.phone
            self?.address.text = $0.address
        }).disposed(by: disposeBag)
    }
    /** Setup keyboard return key for profile text fields */
    private func setupKeyboardForProfile() {
        // name
        name?.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.setupFirstResponder(self?.name)
            }).disposed(by: disposeBag)
        // phone
        phone?.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.setupFirstResponder(self?.phone)
            }).disposed(by: disposeBag)
        // address
        address?.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.setupFirstResponder(self?.address)
            }).disposed(by: disposeBag)
    }
    /** Go to next field or hide keyboard */
    private func setupFirstResponder(_ textField: UITextField?) {
      if IQKeyboardManager.shared.canGoNext {
        IQKeyboardManager.shared.goNext()
      } else {
        textField?.resignFirstResponder()
      }
    }
}

// MARK: - Action
extension ProfileViewController {
    /** Save profile data & show result message */
    private func setupSaveAction() {
        save?.rx.tap.asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .asObservable()
            // Save profile data
            .flatMapLatest { [weak self] in
                self?.updateProfile() ?? Observable.empty()
            }
            // Show result message
//            .observeOn(MainScheduler.instance)
//            .flatMap { [weak self] in
//                self?.showUpdateProfileResult($0) ?? Observable.empty()
//            }
            // Log success result
            .subscribe(onNext: {
                print("Profile saved success")
            }).disposed(by: disposeBag)
    }
    /** Save data from profile text fields */
    private func updateProfile() -> Observable<Void> {
        Observable.just((name.text, phone.text, address.text))
            // Update profile
//            .observeOn(SerialDispatchQueueScheduler.init(qos: .userInteractive))
            .flatMap { [weak self] profile -> Observable<Event<Void>> in
//                guard let viewModel = self?.viewModel else {
//                    return Observable.empty()
//                }
//                return Observable.just(
//                    viewModel.updateProfile(name: profile.0, phone: profile.1, address: profile.2)
//                )
                self?.viewModel?.updateProfile2(name: profile.0, phone: profile.1, address: profile.2) ?? Observable.empty()
            }
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }
    }
    /** Show result for update profile */
//    private func showUpdateProfileResult(_ result: Result<Void, Error>) -> Observable<Void> {
//        switch result {
//        case .failure(let error):
//            print("Profile saved error: \(error.localizedDescription)")
//            return self.rx.showMessage(error.localizedDescription)
//        default:
//            return self.rx.showMessage(NSLocalizedString("profile", comment: ""), withEvent: true)
//        }
//    }
}
