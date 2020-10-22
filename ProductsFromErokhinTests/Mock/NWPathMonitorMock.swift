//
//  NWPathMonitorMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 22.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import Network
@testable import ProductsFromErokhin

class NWPathMonitorMock: NWPathMonitorMethods {
    var pathUpdateHandler: ((NWPathMock) -> Void)?
    
    var isStart = false
    func start(queue: DispatchQueue) {
        isStart.toggle()
    }
    
    var isCancel = false
    func cancel() {
        isCancel.toggle()
    }
}

struct NWPathMock: NWPathMethods {
    var status: NWPath.Status
}
