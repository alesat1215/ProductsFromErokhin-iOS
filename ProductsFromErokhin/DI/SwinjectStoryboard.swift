//
//  SwinjectStoryboard.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 03.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import SwinjectStoryboard
import FirebaseRemoteConfig
import CoreData

extension SwinjectStoryboard {
    public static func setup() {
        // MARK: - Start
        defaultContainer.storyboardInitCompleted(StartViewController.self) { r, c in
            c.viewModel = r.resolve(StartViewModel.self)
        }
        defaultContainer.register(StartViewModel.self) { r in
            StartViewModel(repository: r.resolve(ProductsRepository.self))
        }
        // MARK: - Products
        defaultContainer.register(ProductsRepository.self) { r in
            ProductsRepository(
                updater: r.resolve(DatabaseUpdater.self),
                context: r.resolve(NSManagedObjectContext.self)
            )
        }
        // MARK: - Remote config
        defaultContainer.register(DatabaseUpdater.self) { r in
            DatabaseUpdater(
                remoteConfig: r.resolve(RemoteConfig.self),
                remoteConfigComplection: r.resolve(RemoteConfigComplection.self),
                decoder: r.resolve(JSONDecoder.self),
                context: r.resolve(NSManagedObjectContext.self),
                fetchLimiter: r.resolve(FetchLimiter.self)
            )
        }
        defaultContainer.register(RemoteConfig.self) { _ in
            RemoteConfig.remoteConfig()
        }.inObjectScope(.container)
        defaultContainer.register(RemoteConfigComplection.self) { _ in
            RemoteConfigComplection()
        }
        defaultContainer.register(FetchLimiter.self) { r in
            FetchLimiter(serialQueue: r.resolve(DispatchQueue.self))
        }
        defaultContainer.register(DispatchQueue.self) { _ in
            DispatchQueue(label: "com.alesat1215.ProductsFromErokhin.serialQueue")
        }.inObjectScope(.container)
        // MARK: - Shared
        defaultContainer.register(NSManagedObjectContext.self) { _ in
            (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }.inObjectScope(.container)
        defaultContainer.register(JSONDecoder.self) { _ in
            JSONDecoder()
        }.inObjectScope(.container)
    }
}
