//
//  DetailViewController.swift
//  HouseManagement
//
//  Created by Robert Ababei on 27/08/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class DetailViewController: UIViewController {
    
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var todaySwitch: UISwitch!
    @IBOutlet weak var containerDescriptionView: UIView!
    @IBOutlet weak var descriptionSwitch: UISwitch!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    
    var array = ["Dus gunoi", "Saci de gunoi", "Detergent", "Curat in baie", "Curat in bucatarie", "Curat pe hol"]
    private var ref = Database.database().reference()
    private var usersName = [String]()
    private var currentPickerValue: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        
        currentPickerValue = array[0]
        configureViews()
        getUsersName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datePickerView.isHidden = true
    }
    
    func configureViews() {
        CustomizedUI.customizePickerView(thePicker: pickerView)
        CustomizedUI.customizeButton(theButton: addButton, type: .shine)
        CustomizedUI.customizeDatePickerView(thePicker: datePickerView)
    }
    
    @IBAction func todaySwitchChanged(_ sender: UISwitch) {
        if sender.isOn == false {
            datePickerView.isHidden = false
            
            containerDescriptionView.frame = CGRect(x: 0, y: datePickerView.frame.maxY + 15, width: containerDescriptionView.frame.width, height: containerDescriptionView.frame.height)
        } else {
            datePickerView.isHidden = true
            
            containerDescriptionView.frame = CGRect(x: 0, y: todaySwitch.frame.maxY + 20, width: containerDescriptionView.frame.width, height: containerDescriptionView.frame.height)
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addThing(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        let autoIdKey = ref.child("history").childByAutoId().key
        let userEmail = Auth.auth().currentUser?.email
        let userEmailRemoved = userEmail?.removeEmailSuffix()
        let date: Date
        if todaySwitch.isOn {
            date = Date()
        } else {
            date = datePickerView.date
            
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        let actualDate = dateFormatter.string(from: date)
        
        let dataDict = [
            "date": actualDate,
            "name": userEmail,
            "type": currentPickerValue,
            "autoId": autoIdKey
        ]
        
        ref.child("history").child(autoIdKey!).setValue(dataDict)
        ref.child("usersWork").child(userID!).child(autoIdKey!).setValue(dataDict)
        
        ref.child("statistics").child("perTotal").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let dict = snapshot.value as? [String: AnyObject] {
                    if let _ = dict[userEmailRemoved!] {
                        var value = dict[userEmailRemoved!] as! Int
                        value += 1
                        self.ref.child("statistics").child("perTotal").updateChildValues([userEmailRemoved!: value])
                    
                    }
                    else {
                        self.ref.child("statistics").child("perTotal").updateChildValues([userEmailRemoved!: 0])
                    }
                }
            }
            else {
                self.ref.child("statistics").child("perTotal").setValue([userEmailRemoved: 0])
            }
        }
        
        ref.child("statistics").child("thisWeek").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let dict = snapshot.value as? [String: Int] {
                    if let _ = dict[userEmailRemoved!] {
                        var value = dict[userEmailRemoved!] as! Int
                        value += 1
                        self.ref.child("statistics").child("thisWeek").updateChildValues([userEmailRemoved!: value])
                    }
                }
            }
            else {
                for name in self.usersName {
                    self.ref.child("statistics").child("thisWeek").updateChildValues([name: 0])
                }
                let todayDate = Date()
                let date = dateFormatter.string(from: todayDate)
                self.ref.child("statistics").child("weekDate").setValue(["date": date])
            }
        }
        

        dismiss(animated: true, completion: nil)
    }
    
}

extension DetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentPickerValue = array[row]
    }
}

extension DetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
    }
    
}

extension DetailViewController {
    func getUsersName() {
        ref.child("users").observeSingleEvent(of: .value) { snapshot in
            if let dict = snapshot.value as? [String: String] {
                for name in dict.keys {
                    self.usersName.append(name)
                }
            }
        }
    }
    
}
