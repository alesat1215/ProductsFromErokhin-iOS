//
//  DataSourceCoreData.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 13.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class DataSourceCoreData<T: NSManagedObject>: NSObject, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    typealias Observer = AnyObserver<DataSourceCoreData<T>>
    
    private let observer: Observer
    private let frc: NSFetchedResultsController<T>
    private let cellId: String
    private weak var collectionView: UICollectionView?
    
    init(observer: Observer, frc: NSFetchedResultsController<T>, cellId: String) {
        self.observer = observer
        self.frc = frc
        self.cellId = cellId
        super.init()
        self.frc.delegate = self
        
        do {
            try self.frc.performFetch()
            observer.onNext(self)
        } catch {
            observer.on(.error(error))
        }
    }
    
    func bind(collectionView: UICollectionView?) {
        self.collectionView?.dataSource = nil
        self.collectionView = collectionView
        self.collectionView?.dataSource = self
        self.collectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        frc.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        (cell as? CellBind)?.bind(model: frc.object(at: indexPath))
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let collectionView = collectionView else {
            print("Collection view is not available")
            return
        }
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                collectionView.insertItems(at: [newIndexPath])
            }
        case .update:
            if let indexPath = indexPath {
                (collectionView.cellForItem(at: indexPath) as? CellBind)?
                    .bind(model: controller.object(at: indexPath))
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                collectionView.deleteItems(at: [indexPath])
                collectionView.insertItems(at: [newIndexPath])
            }
        case .delete:
            if let indexPath = indexPath {
                collectionView.deleteItems(at: [indexPath])
            }
        @unknown default:
            print("Unknown type of change")
        }
    }

}

extension DataSourceCoreData: Disposable {
    func dispose() {
        frc.delegate = nil
        collectionView?.dataSource = nil
    }
}

protocol CellBind {
    func bind<T>(model: T)
}
