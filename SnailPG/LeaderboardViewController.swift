//
//  LeaderboardViewController.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 2/1/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardViewController: UIViewController {
    
    @IBOutlet weak var leaderboardTableView: UITableView!
    
    var leaderboard = [FIRDataSnapshot]()

    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        update()
        ref.child("users").observe(.childChanged, with: {(snapshot) in
            self.update()
        })
    }
    
    func update() {
        let query = ref.child("users").queryOrdered(byChild: "totalVictories").queryLimited(toLast: 10)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            self.leaderboard = []
            for data in snapshot.children.allObjects as! [FIRDataSnapshot] {
                self.leaderboard.insert(data, at: 0)
            }
            self.leaderboardTableView.reloadData()
        })
    }

}

extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath)
        cell.textLabel?.text = "\(leaderboard[indexPath.row].childSnapshot(forPath: "name").value!)"
        cell.detailTextLabel?.text = "Victories: \(leaderboard[indexPath.row].childSnapshot(forPath: "totalVictories").value!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard.count
    }
    
}
