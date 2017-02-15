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
    var delegate: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        abilityTableView.delegate = self
        abilityTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func update() {
        if job != "" {
            for ability in AbilityList[job]! {
                abilities.append(ability.key)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ability = AbilityList[job]?[abilities[indexPath.row]] as! [String:Any]
        let cell = tableView.dequeueReusableCell(withIdentifier: "abilityCell", for: indexPath)
        cell.textLabel?.text = "\(ability["name"] as! String)"
        cell.detailTextLabel?.text = "Mana Cost: \(ability["cost"] as! Int)"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let battleVC = delegate as? BattleViewController {
            battleVC.use(ability: abilities[indexPath.row])
        }
        dismiss(animated: true, completion: nil)
    }
}
