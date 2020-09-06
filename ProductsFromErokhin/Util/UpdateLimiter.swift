//
//  UpdateLimiter.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 06.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation

/** Set limit for "true" result for needUpdate() by timeout */
class UpdateLimiter {
    private let timeout: Double
    private var last: Double?
    private let isolationQueue: DispatchQueue?
    
    /**
     - Parameters:
        - timeout: timeout ins seconds for true result from needUpdate()
        - isolationQueue: serial queue for syncronize
     */
    init(timeout: Double?, isolationQueue: DispatchQueue?) {
        self.timeout = timeout ?? 0
        self.isolationQueue = isolationQueue
    }
    
    /** Return true if timeout is over */
    func needUpdate() -> Bool {
        var result = false
        isolationQueue?.sync {
            let now = ProcessInfo.processInfo.systemUptime
            /** Return true for first exec & update last */
            guard let last = last else {
                self.last = now
                print("needUpdate() -> true, from nil last is: \(self.last ?? 0), timeout: \(timeout)")
                result = true
                return
            }
            /** Return true if timeout is over & update last */
            if now - last >= timeout {
                self.last = now
                print("needUpdate() -> true, last is: \(self.last ?? 0), timeout: \(timeout)")
                result = true
                return
            }
            /** Return false if timeout isn't over */
            print("needUpdate() -> false, last is: \(self.last ?? 0), timeout: \(timeout)")
            result = false
        }
        return result
    }
    
    /** Reset as if no fetch yet */
    func reset() {
        isolationQueue?.sync {
            last = nil
            print("Reset last to nil")
        }
    }
}
