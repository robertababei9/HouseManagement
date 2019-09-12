//
//  ProfileViewController.swift
//  HouseManagement
//
//  Created by Robert Ababei on 30/08/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var innerContainerView: UIView!
    @IBOutlet weak var collectionContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var userWorks: [Work] = []
    let userId = Auth.auth().currentUser?.uid
    let userEmailRemoved = Auth.auth().currentUser?.email!.removeEmailSuffix()
    var selectedCellIndexPath: IndexPath?
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "ProfileCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self

        configureViews()
        usernameLabel.text = Auth.auth().currentUser?.email
        
        listenForChildAdded()
//        getAutoIdForWorks()
        listenForChildRemoved()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        numberOfPostsLabel.text = String(userWorks.count)
        
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        if let index = selectedCellIndexPath?.row,
            let autoId = userWorks[index].autoId {
            ref.child("usersWork").child(userId!).child(autoId).removeValue()
            ref.child("history").child(autoId).removeValue()
            
            ref.child("statistics").child("perTotal").observeSingleEvent(of: .value) { snapshot in
                if let dict = snapshot.value as? [String: AnyObject] {
                    var value = dict[self.userEmailRemoved!] as! Int
                    value -= 1
                    self.ref.child("statistics").child("perTotal").updateChildValues([self.userEmailRemoved!: value])
                }
                
            }
            
            collectionView.reloadData()
        }
    }
    
    func configureViews(){
        CustomizedUI.customizeImageView(theImage: profileImageView, type: .profile)
        CustomizedUI.customizeButton(theButton: logoutButton, type: .dark)
        CustomizedUI.customizeButton(theButton: deleteButton, type: .delete)
        CustomizedUI.addGradientToView(theView: innerContainerView, gradientType: .redOrange)
        CustomizedUI.addGradientToView(theView: backgroundContainerView, gradientType: .pizelex)
    }
    
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileCollectionViewCell
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.cornerRadius = 12
        
        deleteButton.isEnabled = true
        deleteButton.alpha = 1
        
        //TODO: work more on selection
        if selectedCellIndexPath?.row == indexPath.row {
            cell.layer.borderWidth = 0
            deleteButton.isEnabled = false
            deleteButton.alpha = 0.5
        }
        selectedCellIndexPath = indexPath
    }
    
    //TODO: selection is not good enough. fix it
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileCollectionViewCell
        cell.layer.borderWidth = 0
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userWorks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: collectionView.bounds.size.height * 0.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        
        cell.typeLabel.text = self.userWorks[indexPath.row].type
        cell.descriptionLabel.text = " Lorem ipsum, this is a simple test and you should treat it just LIKE A TEST."
        cell.dateLabel.text = self.userWorks[indexPath.row].date
        
        return cell
    }
}


extension ProfileViewController {
    func listenForChildRemoved() {
        Database.database().reference().child("usersWork").child(userId!).observe(.childRemoved) { snapshot in
            if let index = self.selectedCellIndexPath?.row {
                self.userWorks.remove(at: index)
            }
            DispatchQueue.main.async {
                self.numberOfPostsLabel.text = String(self.userWorks.count)
                self.collectionView.reloadData()
            }
        }
    }
    
    func listenForChildAdded() {
        Database.database().reference().child("usersWork").child(userId!).observe(.childAdded) { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //Actually at this point dictionary.keys  are : name, date, type
                if let name = dictionary["name"] as? String, let date = dictionary["date"] as? String, let type = dictionary["type"] as? String, let autoId = dictionary["autoId"] as? String {
                    let work = Work(date: date, name: name, type: type, autoId: autoId)
                    self.userWorks.append(work)
                    DispatchQueue.main.async {
                        self.numberOfPostsLabel.text = String(self.userWorks.count)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
