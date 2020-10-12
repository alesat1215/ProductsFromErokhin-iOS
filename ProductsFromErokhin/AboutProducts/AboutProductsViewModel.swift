//
//  AboutProductsViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 12.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

protocol AboutProductsViewModel {
    func aboutProducts() -> Observable<Event<CoreDataSourceCollectionView<AboutProducts>>>
}

class AboutProductsViewModelImpl: AboutProductsViewModel {
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    func aboutProducts() -> Observable<Event<CoreDataSourceCollectionView<AboutProducts>>> {
        repository.aboutProducts(cellId: "aboutProducts")
    }
}
