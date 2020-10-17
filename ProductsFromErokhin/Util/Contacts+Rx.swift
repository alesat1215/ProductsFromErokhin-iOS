//
//  Contacts+Rx.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 02.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Contacts
import Foundation
import RxSwift

// MARK: - CNContactStore
extension Reactive where Base: CNContactStore {
    // MARK: - Privacy Access
    
    /// Requests access to the user's contacts.
    ///
    /// - Parameter entityType: Set to CNEntityTypeContacts.
    /// - Returns: Set granted to true if the user allows access.
    public func requestAccess(for entityType: CNEntityType) -> Observable<Bool> {
        return Observable.create { observer in
            self.base.requestAccess(for: entityType, completionHandler: { bool, error in
                observer.onNext(bool)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    // MARK: - Fetching Unified Contacts
    
    /// Fetches all unified contacts matching the specified predicate.
    ///
    /// - Parameters:
    ///   - predicate: The predicate to match against.
    ///   - keys: The properties to fetch in the returned CNContact objects. You should fetch only the properties that you plan to use. Note that you can combine contact keys and contact key descriptors.
    /// - Returns: An array of CNContact objects matching the predicate.
    public func unifiedContacts(matching predicate: NSPredicate,
                                keysToFetch keys: [CNKeyDescriptor]) -> Observable<[CNContact]> {
        return Observable.create { observer in
            do {
                observer.onNext(try self.base.unifiedContacts(matching: predicate, keysToFetch: keys))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
