//
//  AbilityModalViewController.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 2/3/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class AbilityModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var abilityTableView: UITableView!
    var abilities = [String]()
    var job = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        abilityTableView.delegate = self
        abilityTableView.dataSource = self
        abilityTableView.reloadData()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ability = AbilityList[job][abilities[indexPath.row]]
        let cell = tableView.dequeueReusableCell(withIdentifier: "abilityCell", for: indexPath)
        cell.textLabel?.text = "\(ability["name"])"
        cell.detailTextLabel?.text = "\(ability["cost"])"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stack = self.navigationController?.viewControllers
        if let battleVC = stack?[(stack?.count)! - 1] as? BattleViewController {
            battleVC.use(ability: abilities[indexPath.row])
        }
        dismiss(animated: true, completion: nil)
    }
}
