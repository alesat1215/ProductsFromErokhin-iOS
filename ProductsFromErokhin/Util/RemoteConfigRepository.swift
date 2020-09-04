//
//  RemoteConfigRepository.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 03.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import RxSwift
import RxRelay

class RemoteConfigRepository {
    let remoteConfig: RemoteConfig? // di
    private let remoteConfigComplection: RemoteConfigComplection? // di
    
    init(remoteConfig: RemoteConfig?,
         remoteConfigComplection: RemoteConfigComplection?) {
        self.remoteConfig = remoteConfig
        self.remoteConfigComplection = remoteConfigComplection
    }
    
    func fetchAndActivate() -> Observable<Result<Void, Error>>? {
        remoteConfig?.fetchAndActivate(completionHandler: remoteConfigComplection?.completionHandler(status:error:))
        return remoteConfigComplection?.result()
    }
}

class RemoteConfigComplection {
    private let _result = PublishRelay<Result<Void, Error>>()
    
    func completionHandler(status: RemoteConfigFetchAndActivateStatus, error: Error?) -> Void {
        switch status {
        case .error:
            let error = error ?? AppError.unknown
            _result.accept(.failure(error))
            print("Remote config fetch error: \(error.localizedDescription)")
        case .successFetchedFromRemote:
            _result.accept(.success(()))
            print("Remote config fetched data from remote")
        case .successUsingPreFetchedData:
            _result.accept(.success(()))
            print("Remote config using prefetched data")
        @unknown default:
            print("Remote config unknown status")
        }
    }
    
    func result() -> Observable<Result<Void, Error>> {
        _result.asObservable()
    }
}

//enum RemoteConfigError: LocalizedError {
//    case error(_ description: String?)
//
//    // Need for print localizedDescription
//    var errorDescription: String? {
//        switch self {
//        case .error(let error):
//            return NSLocalizedString(error ?? "", comment: "")
//        }
//    }
//}

extension AppError {
    static let unknown: AppError = .error("unknown")
}
