//
//  Retries.swift
//  Authentication
//
//  Created by Marco Ghaly on 05/05/2021.
//

import Foundation

struct Retries {
    private let count: Int
    private var counter: Int = 1
    private let delay: TimeInterval
    private let incrementalDelay: Bool
    
    init(count: Int, delay: TimeInterval, incrementalDelay: Bool = true) {
        self.count = count
        self.delay = delay
        self.incrementalDelay = incrementalDelay
    }
    
    var canRetry: Bool {
        return counter <= count
    }
    
    var shouldDelay: Bool {
        return canRetry && delay > 0
    }
    
    var nextDelay: TimeInterval {
        var delay = self.delay
        if incrementalDelay {
            delay *= TimeInterval(counter)
        }
        return delay
    }
    
    func retry() -> Retries {
        var retries = self
        retries.counter += 1
        return retries
    }
}
