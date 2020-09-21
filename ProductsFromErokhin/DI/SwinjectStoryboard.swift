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
import FirebaseAuth
import FirebaseStorage
import CoreData

extension SwinjectStoryboard {
    public static func setup() {
        // Disable di for test
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return
        }
        // MARK: - Load
        defaultContainer.storyboardInitCompleted(LoadViewController.self) { r, c in
            c.viewModel = r.resolve(LoadViewModel.self)
        }
        defaultContainer.register(LoadViewModel.self) { r in
            LoadViewModel(
                repository: r.resolve(AppRepository.self),
                anonymousAuth: r.resolve(AnonymousAuth.self)
            )
        }
        // MARK: - Start
        defaultContainer.storyboardInitCompleted(StartViewController.self) { r, c in
            c.viewModel = r.resolve(StartViewModel.self)
        }
        defaultContainer.register(StartViewModel.self) { r in
            StartViewModel(
                repository: r.resolve(AppRepository.self)
            )
        }
        // MARK: - Repository
        defaultContainer.register(AppRepository.self) { r in
            AppRepository(
                updater: r.resolve(DatabaseUpdater.self),
                context: r.resolve(NSManagedObjectContext.self)
            )
        }.inObjectScope(.container)
        
        // MARK: - Auth
        defaultContainer.register(AnonymousAuth.self) { r in
            AnonymousAuth(
                auth: r.resolve(Auth.self),
                authComplection: r.resolve(AuthComplection.self)
            )
        }
        defaultContainer.register(Auth.self) { _ in
            Auth.auth()
        }.inObjectScope(.container)
        
        defaultContainer.register(AuthComplection.self) { _ in
            AuthComplection()
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
            let remoteConfig = RemoteConfig.remoteConfig()
            remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
            return remoteConfig
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
        
        // MARK: - Storage
        defaultContainer.register(StorageReference.self) { _ in
            Storage.storage().reference()
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
