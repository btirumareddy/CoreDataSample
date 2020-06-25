//
//  AddUserViewModel.swift
//  Task
//
//  Created by Bhanuja Tirumareddy on 25/06/20.
//  Copyright © 2020 Bhanuja Tirumareddy. All rights reserved.
//

import Foundation
class AddUserViewModel: NSObject {
    var txtUserName: String?
    var txtPhoneNumber: String?
    var txtAddress: String?
    var dataProfilePic : Data?
    
    func clearData(){
        txtUserName = ""
        txtPhoneNumber = ""
        txtAddress = ""
        dataProfilePic = Data()
    }
}
