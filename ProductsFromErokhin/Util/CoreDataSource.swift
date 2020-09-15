//
//  CoreDataSource.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 13.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class CoreDataSource<T: NSFetchRequestResult>: NSObject, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    typealias Observer = AnyObserver<CoreDataSource<T>>
    
    private let observer: Observer
    private let frc: NSFetchedResultsController<T>
    private let cellId: String
    private weak var collectionView: UICollectionView?
    
    init(
        observer: Observer,
        cellId: String,
        fetchRequest: NSFetchRequest<T>,
        managedObjectContext: NSManagedObjectContext,
        sectionNameKeyPath: String?,
        cacheName: String?
    ) {
        self.observer = observer
        self.cellId = cellId
        self.frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName
        )
        super.init()
        self.frc.delegate = self
        
        do {
            try self.frc.performFetch()
            observer.onNext(self)
        } catch {
            observer.onError(error)
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
        (cell as? BindableCell)?.bind(model: frc.object(at: indexPath), indexPath: indexPath, dataSource: self)
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
                (collectionView.cellForItem(at: indexPath) as? BindableCell)?
                    .bind(model: frc.object(at: indexPath), indexPath: indexPath, dataSource: self)
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

extension CoreDataSource: Disposable {
    func dispose() {
        frc.delegate = nil
        collectionView?.dataSource = nil
    }
}

extension CoreDataSource {
    func object(at indexPath: IndexPath) -> T {
        frc.object(at: indexPath)
    }
}

class BindableCell<T: NSFetchRequestResult>: UICollectionViewCell {
    var indexPath: IndexPath!
    weak var dataSource: CoreDataSource<Product>?
    
    func bind(model: T, indexPath: IndexPath, dataSource: CoreDataSource<T>?) {
        print("Warning! Bind for cell isn't ovverite")
    }
}
