//
//  UserDataManager.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

// MARK: - UserDataManagerProtocol
protocol UserDataManagerProtocol: AnyObject {
    func add(user: User, completion: CompletionHandler)
    func getUser() -> User?
    func deleteAll(completion: CompletionHandler)
}

// MARK: - UserDataManager
class UserDataManager: UserDataManagerProtocol {
    func add(user: User, completion: CompletionHandler) {
        RealmRepo<User>.add(
            item: user,
            completion: completion
        )
    }
    
    func getUser() -> User? {
        print(RealmRepo<User>.getAll())
        return RealmRepo<User>.getFirst()
    }
    
    func deleteAll(completion: CompletionHandler) {
        RealmRepo<User>.deleteAll(completion: completion)
    }
}
