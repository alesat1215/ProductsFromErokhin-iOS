//
//  CoreDataSourceTableView.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 22.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class CoreDataSourceTableView<T: NSFetchRequestResult>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    typealias Observer = AnyObserver<CoreDataSourceTableView<T>>
    
    private let observer: Observer
    private let frc: NSFetchedResultsController<T>
    private let cellId: String
    private weak var tableView: UITableView?
    
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
    
    func bind(tableView: UITableView?) {
        self.tableView?.dataSource = nil
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let sections = frc.sections, sections.indices.contains(section) {
            count = sections[section].numberOfObjects
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        (cell as? BindableTableViewCell)?.bind(model: frc.object(at: indexPath))
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let tableView = tableView else {
            print("Table view is not available")
            return
        }
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let anObject = anObject as? T {
                (tableView.cellForRow(at: indexPath) as? BindableTableViewCell)?
                    .bind(model: anObject)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath, tableView.numberOfRows(inSection: indexPath.section) > 0 {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            print("Unknown type of change")
        }
    }
    
}

// MARK: - Rx
extension CoreDataSourceTableView: Disposable {
    func dispose() {
        frc.delegate = nil
        tableView?.dataSource = nil
    }
}
