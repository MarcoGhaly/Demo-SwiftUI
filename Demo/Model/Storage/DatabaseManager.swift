//
//  DatabaseManager.swift
//  Demo
//
//  Created by Marco Ghaly on 19/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

struct DatabaseManager {
    static func save<T>(object: T) throws -> T where T: Object {
        let realm = try Realm()
        try realm.write {
            realm.add(object)
        }
        return object.freeze()
    }
    
    static func loadObjects<T>(predicate: NSPredicate) throws -> AnyPublisher<[T], DefaultAppError> where T: Object {
        let publisher = PassthroughSubject<[T], DefaultAppError>()
        
        let realm = try Realm()
        let objects = Array(realm.objects(T.self).filter(predicate).freeze())
        DispatchQueue.main.async {
            publisher.send(objects)
            publisher.send(completion: .finished)
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    static func deleteObjects<T>(predicate: NSPredicate) throws -> [T] where T: Object {
        let realm = try Realm()
        let objects = realm.objects(T.self).filter(predicate)
        try realm.write {
            realm.delete(objects)
        }
        return Array(objects)
    }
}
