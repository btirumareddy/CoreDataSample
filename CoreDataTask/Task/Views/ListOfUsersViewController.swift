//
//  ListOfUsersViewController.swift
//  Task
//
//  Created by Bhanuja Tirumareddy on 25/06/20.
//  Copyright © 2020 Bhanuja Tirumareddy. All rights reserved.
//

import UIKit

class ListOfUsersViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    var listOfUsersViewModel: ListOfUsersViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()        
        registerCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listOfUsersViewModel = ListOfUsersViewModel()
        userTableView.reloadData()
        NotificationCenter.default
                   .addObserver(self,
                                selector: #selector(statusManager),
                                name: .flagsChanged,
                                object: nil)
               updateUserInterface()
    }
   func updateUserInterface() {
        switch network.reachability.status {
        case .unreachable:
            return
        case .wwan:
            for users in listOfUsersViewModel.users {
                listOfUsersViewModel.pushUsertoServer(user: users)
            }
            self.userTableView.reloadData()
        case .wifi:
            for users in listOfUsersViewModel.users {
                listOfUsersViewModel.pushUsertoServer(user: users)
            }
            self.userTableView.reloadData()
        }
        print("Reachability Summary")
        print("Status:", network.reachability.status)
        print("HostName:", network.reachability.hostname ?? "nil")
        print("Reachable:", network.reachability.isReachable)
        print("Wifi:", network.reachability.isReachableViaWiFi)
  }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    func registerCell() {
        let nib = UINib(nibName: "UserCell", bundle: nil)
        self.userTableView.register(nib, forCellReuseIdentifier: "UserCell")
    }
}
extension ListOfUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension ListOfUsersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfUsersViewModel.numberOfRowsforCell()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell")as? UserCell else { return UITableViewCell() }
         let user = listOfUsersViewModel.cellForIndexPath(index: indexPath.row)
        userCell.nameLabel.text = user.name
        userCell.phoneNumberLabel.text = user.phoneNumber
        if let data = user.profilePic {
             userCell.profilePic.image = UIImage(data: data)
        }
        return userCell
    }
}
