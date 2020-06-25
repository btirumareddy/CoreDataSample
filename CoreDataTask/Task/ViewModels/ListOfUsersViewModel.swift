//
//  ListOfUsersViewModel.swift
//  Task
//
//  Created by Bhanuja Tirumareddy on 25/06/20.
//  Copyright © 2020 Bhanuja Tirumareddy. All rights reserved.
//


import Foundation
class ListOfUsersViewModel {
    var users = [User]()
    init() {
        CoreDataWrapper().fetchUsers { (user) in
            self.users = user
        }
    }
    
    func numberOfRowsforCell() -> Int{
        return self.users.count
    }
    func cellForIndexPath(index: Int) -> User {
        return self.users[index]
    }
    func pushUsertoServer(user: User) {
        let params = [ "name" : user.name,
            "phoneNumber" : user.phoneNumber,
            "address" : user.address,
            "profilePic": user.profilePic?.base64EncodedString()]
        Network.Shared.saveUser(url: "sampleUrl", users: params as [String : Any]) { (STATUS) in
            if STATUS == "Success" {
                CoreDataWrapper().deleteUser(user.phoneNumber ?? "")
            }
        }
        
        
    }
}
