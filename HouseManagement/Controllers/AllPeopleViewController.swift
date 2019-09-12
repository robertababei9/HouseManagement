//
//  AllPeopleViewController.swift
//  HouseManagement
//
//  Created by Robert Ababei on 10/09/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AllPeopleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var users = [User]()
    private var usersId = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AllPeopleTableCell", bundle: Bundle.main), forCellReuseIdentifier: "AllPeopleTableCell")
        
        fetchUsersNameAndId()
        
    }
    
}

extension AllPeopleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toPeopleDetail", sender: users[indexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let peopleDetailViewController = segue.destination as! PeopleDetailViewController
        peopleDetailViewController.userIdReceived = sender as? String
    }
}

extension AllPeopleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPeopleTableCell", for: indexPath) as! AllPeopleTableCell
        cell.nameLabel.text = users[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension AllPeopleViewController {
    
    func fetchUsersNameAndId() {
        Database.database().reference().child("users").observe(.childAdded) { snapshot in
            if let id = snapshot.value as? String, let name = snapshot.key as? String {
               let user = User(name: name, id: id)
                self.users.append(user)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
