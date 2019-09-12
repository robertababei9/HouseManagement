//
//  NewsViewController.swift
//  HouseManagement
//
//  Created by Robert Ababei on 27/08/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewsViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let ref = Database.database().reference()
    var newsArray: [Work] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomizedUI.customizeNavigationBar(theBar: navigationBar)

        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NewsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        checkIfOneWeekPassed()
        fetchNewsFromDatabase()
        listenForChildRemove()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func addNewRow(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController

        navigationController?.present(detailViewController, animated: true)
        
    }

}

extension NewsViewController: UITableViewDelegate {
    
}

extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        cell.nameLabel.text = newsArray[indexPath.row].name
        cell.dateLabel.text = newsArray[indexPath.row].date
        cell.typeLabel.text = newsArray[indexPath.row].type
        
        return cell
        
    }
}

extension NewsViewController {
    func fetchNewsFromDatabase() {
        ref.child("history").observe(.childAdded, with: { snapshot in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let theName = dictionary["name"] as? String, let theDate = dictionary["date"] as? String, let theType = dictionary["type"] as? String {
                    let work = Work(date: theDate, name: theName, type: theType)
                    self.newsArray.append(work)
                    self.newsArray = self.newsArray.sorted {
                        $0.date > $1.date
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        }, withCancel: nil)
    }
    
    func listenForChildRemove() {
        ref.child("history").observe(.childRemoved) { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let theName = dictionary["name"] as? String, let theDate = dictionary["date"] as? String, let theType = dictionary["type"] as? String {
                    let work = Work(date: theDate, name: theName, type: theType)
                    self.newsArray = self.newsArray.removeAt(work: work)

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }

            }
        }
    }
    
    func checkIfOneWeekPassed() {
        ref.child("statistics").child("weekDate").observeSingleEvent(of: .value) {
            snapshot in
            if snapshot.exists() {
                var dateStringFromDatabase: String?
                if let dict = snapshot.value as? [String: String] {
                    dateStringFromDatabase = dict["date"]
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yy/MM/dd"
                let dateFromDatabase = formatter.date(from: dateStringFromDatabase!)
                let actualDate = Date()
                
                if self.isPassedMoreThan(days: 7, fromDate: dateFromDatabase!, toDate: actualDate) {
                    self.ref.child("statistics").child("thisWeek").removeValue()
                    self.ref.child("statistics").child("weekDate").removeValue()
                }
            }
        }
    }
    
    func isPassedMoreThan(days: Int, fromDate date: Date, toDate date2: Date) -> Bool {
        let unitFlags: Set<Calendar.Component> = [.day]
        let deltaD = Calendar.current.dateComponents(unitFlags, from: date, to: date2)
        return deltaD.day! > days
    }
}



