//
//  AboutProductsViewModelMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 13.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import ProductsFromErokhin

class AboutProductsViewModelMock: AboutProductsViewModel {
    let aboutProductsResult = PublishRelay<Event<CoreDataSourceCollectionView<AboutProducts>>>()
    func aboutProducts() -> Observable<Event<CoreDataSourceCollectionView<AboutProducts>>> {
        aboutProductsResult.asObservable()
    }
}
