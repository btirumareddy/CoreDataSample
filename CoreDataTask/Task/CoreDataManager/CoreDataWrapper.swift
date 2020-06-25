//
//  CoreDataWrapper.swift
//  Task
//
//  Created by Bhanuja Tirumareddy on 25/06/20.
//  Copyright © 2020 Bhanuja Tirumareddy. All rights reserved.
//


import UIKit
import CoreData

class CoreDataWrapper: NSObject {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    func saveUser( _ user: User, completionHandler onCompletion: (_ success: Bool) -> () ) {
        //Create entityDescription object
        let entityTenantDetails = NSEntityDescription.entity(forEntityName: "UserDetails", in: appDelegate.managedObjectContext)
        //Create receipts object with entityDescription
        let userDetails = NSManagedObject(entity: entityTenantDetails!, insertInto: appDelegate.managedObjectContext) as?UserDetails
        userDetails?.name = user.name?.base64Encoded()
        userDetails?.phoneNumber = user.phoneNumber?.base64Encoded()
        userDetails?.address = user.address?.base64Encoded()
        userDetails?.profilePic = user.profilePic
        if user.address != nil {
            let entityTenantDetails = NSEntityDescription.entity(forEntityName: "Address", in: appDelegate.managedObjectContext)
            let adressDetails = NSManagedObject(entity: entityTenantDetails!, insertInto: appDelegate.managedObjectContext) as? Address
            adressDetails?.userAddress = user.address?.base64Encoded()
            adressDetails?.name = user.name?.base64Encoded()
            userDetails?.adresses = NSSet(object: adressDetails as Any)
        }
        do {
            try appDelegate.managedObjectContext.save()
            print("Saved")
             onCompletion(true)
        } catch {
            print(error.localizedDescription)
             onCompletion(false)
        }       
    }
    //Fetch  List
    
    func fetchUsers(completionHandler onCompletion: @escaping (_ users: [User]) -> ()) {
        
        //Create receipts  array
        var receiptsList = [User]()
        //Create private background MOC
        var privateContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        privateContext.automaticallyMergesChangesFromParent = true
        if #available(iOS 10.0, *) {
            privateContext = appDelegate.persistentContainer.newBackgroundContext()
        } else {
            privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = appDelegate.managedObjectContext
        }
        
        // Create fetch request
        let receiptsFetchRequest: NSFetchRequest<UserDetails> = NSFetchRequest<NSFetchRequestResult>.init(entityName: "UserDetails") as! NSFetchRequest<UserDetails>
        do {
            let users = try self.appDelegate.managedObjectContext.fetch(receiptsFetchRequest)
            for receipt in users {
                let individualUser:User = User()
                individualUser.name = receipt.name?.base64Decoded()
                individualUser.phoneNumber = receipt.phoneNumber?.base64Decoded()
                individualUser.address = receipt.address?.base64Decoded()
                individualUser.profilePic = receipt.profilePic
                receiptsList.append(individualUser)
            }
        } catch {
            print("\(error.localizedDescription)")
        }
        onCompletion(receiptsList)
    }
    
    func deleteUser(_ phoneNuber: String) {
        let entity = NSEntityDescription.entity(forEntityName: "UserDetails", in: appDelegate.managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        let predicate = NSPredicate(format: "(imagePath = %@)", phoneNuber.base64Encoded() ?? "")
        request.predicate = predicate
        do {
            guard let results = try appDelegate.managedObjectContext.fetch(request) as? [UserDetails] else {return}
            do {
                if results.count > 0 {
                    for item in results {
                        appDelegate.managedObjectContext.delete(item)
                        try appDelegate.managedObjectContext.save()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func updateReceipt(_ receipt: User) {
        var privateContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        privateContext.automaticallyMergesChangesFromParent = true
        if #available(iOS 10.0, *) {
            privateContext = appDelegate.persistentContainer.newBackgroundContext()
        } else {
            privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = appDelegate.managedObjectContext
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "UserDetails", in: appDelegate.managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        let predicate = NSPredicate(format: "(mobileNumber == %@)", receipt.phoneNumber?.base64Encoded() ?? "")
        request.predicate = predicate
        do {
            guard let receiptsResults = try appDelegate.managedObjectContext.fetch(request) as? [User] else {return}
            if receiptsResults.count > 0 {
                let receiptDetails = receiptsResults[0]
                receiptDetails.name = receipt.name?.base64Encoded()
                do {
                    try appDelegate.managedObjectContext.save()
                } catch {
                    print(error)
                }
            } else {
                self.saveUser(receipt) { (flag) in
                    print(flag)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}

