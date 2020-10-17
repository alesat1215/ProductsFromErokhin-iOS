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

class CoreDataSourceCollectionView<T: NSFetchRequestResult>: NSObject, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    typealias Observer = AnyObserver<CoreDataSourceCollectionView<T>>
    
    private let observer: Observer
    private let frc: NSFetchedResultsController<T>
    private let cellId: [String]
    private weak var collectionView: UICollectionView?
    
    init(
        observer: Observer,
        cellId: [String],
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
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = frc.sections, sections.indices.contains(section) {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let id = cellId.indices.contains(indexPath.section) ?
            cellId[indexPath.section] : cellId.last ?? ""
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        (cell as? BindableCollectionViewCell)?.bind(model: object(at: indexPath))
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        frc.sections?.count ?? 0
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
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
            if let indexPath = indexPath, let anObject = anObject as? T {
                (collectionView.cellForItem(at: indexPath) as? BindableCollectionViewCell)?
                    .bind(model: anObject)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                collectionView.deleteItems(at: [indexPath])
                collectionView.insertItems(at: [newIndexPath])
            }
        case .delete:
            if let indexPath = indexPath, collectionView.numberOfItems(inSection: indexPath.section) > 0 {
                collectionView.deleteItems(at: [indexPath])
            }
        @unknown default:
            print("Unknown type of change")
        }
    }
    
    /** Select group for indexPath after unselect previous */
    func select(indexPath: IndexPath) -> Result<Void, Error> where T == Group {
        // Uselect previous group
        frc.fetchedObjects?.first { $0.isSelected }?.unSelect()
        // Select group for indexPath
        return object(at: indexPath)?.select() ?? .success(())
    }
    
    /** - Returns: Object for indexPath */
    func object(at indexPath: IndexPath) -> T? {
        var result: T?
        if frc.sections?.indices.contains(indexPath.section) ?? false,
           let numberOfObjects = frc.sections?[indexPath.section].numberOfObjects, numberOfObjects > indexPath.item
        {
            result = frc.object(at: indexPath)
        }
        return result
    }
    
    /** - Returns: IndexPath for object */
    func indexPath(for object: T) -> IndexPath? {
        frc.indexPath(forObject: object)
    }

}

// MARK: - Rx
extension CoreDataSourceCollectionView: Disposable {
    func dispose() {
        frc.delegate = nil
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.dataSource = nil
        }
    }
}
