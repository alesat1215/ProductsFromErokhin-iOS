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

extension SwinjectStoryboard {
    public static func setup() {
        // MARK: - Start
        defaultContainer.storyboardInitCompleted(StartViewController.self) { r, c in
            c.viewModel = r.resolve(StartViewModel.self)
        }
        defaultContainer.register(StartViewModel.self) { r in
            StartViewModel(repository: r.resolve(ProductsRepository.self))
        }
        defaultContainer.register(ProductsRepository.self) { r in
            ProductsRepository(remoteConfigRepository: r.resolve(RemoteConfigRepository.self))
        }
        defaultContainer.register(RemoteConfigRepository.self) { r in
            RemoteConfigRepository(remoteConfig: r.resolve(RemoteConfig.self), remoteConfigComplection: r.resolve(RemoteConfigComplection.self))
        }
        defaultContainer.register(RemoteConfig.self) { _ in
            RemoteConfig.remoteConfig()
        }.inObjectScope(.container)
        defaultContainer.register(RemoteConfigComplection.self) { _ in
            RemoteConfigComplection()
        }
    }
}
