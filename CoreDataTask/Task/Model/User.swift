//
//  User.swift
//  Task
//
//  Created by Bhanuja Tirumareddy on 25/06/20.
//  Copyright © 2020 Bhanuja Tirumareddy. All rights reserved.
//

import Foundation
class User: NSObject {
    var name: String?
    var phoneNumber: String?
    var address: String?
    var profilePic: Data?
    override init() {
        self.name = ""
        self.phoneNumber = ""
        self.address = ""
        self.profilePic = Data()
    }
    init(name: String, phoneNumber: String, address: String, profilePic: Data) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.profilePic = profilePic
    }
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        profilePic = aDecoder.decodeObject(forKey: "profilePic") as? Data
        
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(profilePic, forKey: "profilePic")
    }
}
