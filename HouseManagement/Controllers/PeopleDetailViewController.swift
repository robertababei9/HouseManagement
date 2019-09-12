//
//  PeopleDetailViewController.swift
//  HouseManagement
//
//  Created by Robert Ababei on 10/09/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import UIKit
import FirebaseAuth

class PeopleDetailViewController: UIViewController {
    
    @IBOutlet weak var sortByLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let userId = Auth.auth().currentUser?.uid
    var userIdReceived: String?
    private var userWorks = [Work]()
    
    private var viewForPicker: UIView!
    private let sortArray = ["Date", "Alphabetical"]
    private var counterPicker = 0
    private var selectedSortingIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PeopleDetailTableCell", bundle: Bundle.main), forCellReuseIdentifier: "PeopleDetailTableCell")
        
        let labelTapped = UITapGestureRecognizer(target: self, action: #selector(showSortingPicker))
        sortByLabel.addGestureRecognizer(labelTapped)
        
        FirebaseAPI.fetchWorksForUser(withId: userIdReceived!) { work in
            self.userWorks.append(work)
            self.tableView.reloadData()
        }

    }
}

extension PeopleDetailViewController: UITableViewDelegate {
    
}

extension PeopleDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userWorks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleDetailTableCell") as! PeopleDetailTableCell
        cell.typeLabel.text = userWorks[indexPath.row].type
        cell.dateLabel.text = userWorks[indexPath.row].date
        
        return cell
    }
}


extension PeopleDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortArray[row]
    }
}

extension PeopleDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSortingIndex = row
    }
}

extension PeopleDetailViewController {
    @objc func showSortingPicker() {
        //we use counterPicker to be sure that only one view will be displayed
        //when label is tapped
        if counterPicker == 0 {
            let pickerHeight: CGFloat = 250
            let toolBarHeight: CGFloat = 40
            
            viewForPicker = UIView(frame: CGRect(x: 0 , y: view.bounds.height - pickerHeight, width: view.bounds.width, height: pickerHeight))
            
            let sortPickerView = UIPickerView(frame: CGRect(x: 0, y: toolBarHeight, width: viewForPicker.frame.width, height: pickerHeight - toolBarHeight))
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: viewForPicker.bounds.width, height: toolBarHeight))
            let cancelBarBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarBtnClicked))
            let doneBarBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBatBtnClicked))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([cancelBarBtn, flexibleSpace, doneBarBtn], animated: true)
            
            sortPickerView.delegate = self
            sortPickerView.dataSource = self
            
            CustomizedUI.customizePickerView(thePicker: sortPickerView)
            viewForPicker.addSubview(toolbar)
            viewForPicker.addSubview(sortPickerView)
            view.addSubview(viewForPicker)
            counterPicker += 1
        }
    }
    
    @objc func cancelBarBtnClicked() {
        viewForPicker.removeFromSuperview()
        counterPicker = 0
    }
    
    @objc func doneBatBtnClicked() {
        sortByLabel.text = sortArray[selectedSortingIndex]
        viewForPicker.removeFromSuperview()
        counterPicker = 0
        
        switch selectedSortingIndex {
        case 0:
            userWorks = userWorks.sorted {
                $0.date > $1.date
            }
            tableView.reloadData()
        case 1:
            userWorks = userWorks.sorted {
                $0.type < $1.type
            }
            tableView.reloadData()
        default:
            break
        }
    }
}
