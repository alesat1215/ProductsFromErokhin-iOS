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
import Contacts

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
            LoadViewModelImpl(
                repository: r.resolve(AppRepository.self),
                anonymousAuth: r.resolve(Auth.self),
                userDefaults: r.resolve(UserDefaults.self)
            )
        }
        // MARK: - Tutorial
        defaultContainer.storyboardInitCompleted(TutorialViewController.self) { r, c in
            c.viewModel = r.resolve(TutorialViewModel.self)
        }
        defaultContainer.register(TutorialViewModel.self) { r in
            TutorialViewModelImpl(
                repository: r.resolve(AppRepository.self),
                userDefaults: r.resolve(UserDefaults.self)
            )
        }
        // MARK: - TabBar
        defaultContainer.storyboardInitCompleted(TabBarController.self) { r, c in
            c.viewModel = r.resolve(CartViewModel.self)
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
        // MARK: - Menu
        defaultContainer.storyboardInitCompleted(MenuViewController.self) { r, c in
            c.viewModel = r.resolve(MenuViewModel.self)
        }
        defaultContainer.register(MenuViewModel.self) { r in
            MenuViewModel(
                repository: r.resolve(AppRepository.self)
            )
        }
        // MARK: - Cart
        defaultContainer.storyboardInitCompleted(CartViewController.self) { r, c in
            c.viewModel = r.resolve(CartViewModel.self)
        }
        defaultContainer.register(CartViewModel.self) { r in
            CartViewModel(
                repository: r.resolve(AppRepository.self),
                contactStore: r.resolve(CNContactStore.self)
            )
        }.inObjectScope(.weak)
        defaultContainer.register(CNContactStore.self) { _ in
            CNContactStore()
        }.inObjectScope(.container)
        
        // MARK: - Profile
        defaultContainer.storyboardInitCompleted(ProfileViewController.self) { r, c in
            c.viewModel = r.resolve(ProfileViewModel.self)
        }
        defaultContainer.register(ProfileViewModel.self) { r in
            ProfileViewModelImpl(
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
        defaultContainer.register(Auth.self) { _ in
            Auth.auth()
        }.inObjectScope(.container)

        // MARK: - Remote config
        defaultContainer.register(DatabaseUpdater.self) { r in
            DatabaseUpdaterImpl(
                remoteConfig: r.resolve(RemoteConfig.self),
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
        
        defaultContainer.register(UserDefaults.self) { r in
            UserDefaults.standard
        }.inObjectScope(.container)
    }
}
