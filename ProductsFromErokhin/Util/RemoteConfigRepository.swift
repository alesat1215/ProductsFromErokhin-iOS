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
import CoreData

class RemoteConfigRepository {
    let remoteConfig: RemoteConfig? // di
    private let remoteConfigComplection: RemoteConfigComplection? // di
    private let decoder = JSONDecoder()
    private let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    
    init(remoteConfig: RemoteConfig?,
         remoteConfigComplection: RemoteConfigComplection?) {
        self.remoteConfig = remoteConfig
        self.remoteConfigComplection = remoteConfigComplection
    }
    
//    func fetchAndActivate() -> Observable<Result<Void, Error>>? {
//        remoteConfig?.fetchAndActivate(completionHandler: remoteConfigComplection?.completionHandler(status:error:))
//        return remoteConfigComplection?.result()
//    }
//
//    func remoteData<T: Codable>(key: String) -> Observable<T>? {
//        fetchAndActivate()?.flatMap { [weak self] result -> Observable<T> in
//            guard let self = self, let remoteCondig = self.remoteConfig else { return Observable.empty() }
////            guard let remoteCondig = self.remoteConfig else { return Observable.empty() }
////            guard let decoder = self.decoder else { return Observable.empty() }
//            switch result {
//            case .failure(let error):
//                throw error
//            default:
//                let data = try self.decoder.decode(T.self, from: remoteCondig[key].dataValue)
//                return Observable.just(data)
//            }
//        }
//    }
    
    private func remoteData<T: Codable>(key: String) throws -> T {
        try decoder.decode(T.self, from: remoteConfig![key].dataValue)
    }
    
    private func updateDB() throws {
        let groups: [GroupRemote] = try remoteData(key: "products")
        
        try Group.clearEntity(context: context)
        
        var productOrder = 0
        groups.enumerated().forEach {
            context.insert($1.managedObject(context: context, groupOrder: $0, productOrder: &productOrder))
        }
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    func fetchAndActivate<T>() -> Observable<T> {
        remoteConfig?.fetchAndActivate(completionHandler: remoteConfigComplection?.completionHandler(status:error:))
        return remoteConfigComplection!.result().flatMap { [weak self] result -> Observable<T> in
            switch result {
            case .failure(let error):
                return Observable.error(error)
            default:
                try self?.updateDB()
                return Observable.empty()
            }
//            try self?.updateDB()
//            return Observable.empty()
            }
    }
    
//    private func updateDB(groups: [GroupRemote]) throws {
//
//        guard let context = context else {
//            print("Context is nil. Nothing to update")
//            throw AppError.productsRepositoryDI
//        }
//
//        try Group.clearEntity(context: context)
//
//        var productOrder = 0
//        groups.enumerated().forEach {
//            context.insert($1.managedObject(context: context, groupOrder: $0, productOrder: &productOrder))
//        }
//
//        if context.hasChanges {
//            try context.save()
//        }
//    }
    
}

class RemoteConfigComplection {
    private let _result = PublishRelay<Result<Void, Error>>()
//    private let _result = PublishSubject<Void>()
    
    func completionHandler(status: RemoteConfigFetchAndActivateStatus, error: Error?) -> Void {
        switch status {
        case .error:
            let error = error ?? AppError.unknown
            _result.accept(.failure(error))
//            _result.onError(error)
            print("Remote config fetch error: \(error.localizedDescription)")
        case .successFetchedFromRemote:
            _result.accept(.success(()))
//            _result.onNext(())
            print("Remote config fetched data from remote")
        case .successUsingPreFetchedData:
//            _result.accept(.success(()))
            print("Remote config using prefetched data")
        @unknown default:
            print("Remote config unknown status")
        }
    }
    
    func result() -> Observable<Result<Void, Error>> {
        _result.asObservable()
    }
//    func result() -> Observable<Void> {
//        _result.asObservable()
//    }
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
