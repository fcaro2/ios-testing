//
//  RealmRepo.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import RealmSwift

// MARK: - Class RealmRepo
class RealmRepo<T: Object>: Addable, Deletable, Gettable {
    typealias Item = T
}

// MARK: - Keyable
protocol Keyable {
    associatedtype KeyType
}

// MARK: - PrimaryKeyable
protocol PrimaryKeyable: AnyObject, Keyable {
    static var primaryKeyIdentifier: String {get}
    var id: KeyType? {get}
    static func primaryKey() -> String?
}

extension PrimaryKeyable {
    static var primaryKeyIdentifier: String {
        return "id"
    }
}

// MARK: - Itemable
protocol Itemable: AnyObject {
    associatedtype Item: Object
}

// MARK: - Addable
protocol Addable: Itemable {
    static func add(item: Item..., completion: CompletionHandler)
    static func add(itemList: [Item], completion: CompletionHandler)
}

extension Addable {
    static func add(item: Item..., completion: CompletionHandler = nil) {
        
        let realm = try! Realm()
        
        try! realm.write {
            item.forEach {
                realm.add($0)
            }
        }
        
        guard let completion = completion else {
            return
        }
        
        completion()
    }
    
    static func add(itemList: [Item], completion: CompletionHandler = nil) {
        
        guard !itemList.isEmpty else {
            return
        }
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(itemList)
        }
        
        guard let completion = completion else {
            return
        }
        
        completion()
    }
}

extension Addable where Item: PrimaryKeyable {
    static func add(item: Item..., completion: CompletionHandler = nil) {
        
        let realm = try! Realm()
        
        try! realm.write {
            item.forEach {
                realm.add($0, update: .all)
            }
        }
        
        guard let completion = completion else {
            return
        }
        
        completion()
    }
    
    static func add(itemList: [Item], completion: CompletionHandler = nil) {
        
        guard !itemList.isEmpty else {
            return
        }
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(itemList, update: .all)
        }
        
        guard let completion = completion else {
            return
        }
        
        completion()
    }
}

// MARK: - Deletable
protocol Deletable: Itemable {
    static func delete(item: Item..., completion: CompletionHandler)
    static func delete(item: [Item], completion: CompletionHandler)
    static func deleteAll(completion: CompletionHandler)
}

extension Deletable {
    static func deleteAll(completion: CompletionHandler = nil) {
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(realm.objects(Item.self))
        }
        
        guard let completion = completion else {
            return
        }
        
        completion()
    }
    
    static func delete(item: Item..., completion: CompletionHandler = nil) {
        
        let realm = try! Realm()
        
        try! realm.write {
            item.forEach {
                realm.delete($0)
            }
        }
        
        guard let completion = completion else {
            return
        }
        
        completion()
    }
    
    static func delete(item: [Item], completion: CompletionHandler = nil) {
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(item)
        }
        
        guard let completion = completion else {
            return
        }
        
        completion()
    }
}

// MARK: - Gettable
protocol Gettable: Itemable {
    static func getBy<T>(key: String, value: T) -> Item?
    static func getAll() -> Results<Item>
    static func getFirst() -> Item?
}

extension Gettable {
    static func getBy<T>(key: String, value: T) -> Item? {
        
        let realm = try! Realm()
        
        return realm.objects(Item.self).filter("\(key) == %@", value).first
    }
    
    static func getAll() -> Results<Item> {
        
        let realm = try! Realm()
        
        return realm.objects(Item.self)
    }
    
    static func getFirst() -> Item? {
        
        let realm = try! Realm()
        
        return realm.objects(Item.self).first
    }
}
