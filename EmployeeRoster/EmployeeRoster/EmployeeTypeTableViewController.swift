//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by Rajveer Singh on 12/10/22.
//

import UIKit

protocol EmployeeTypeTableViewControllerDelegate: AnyObject {
    
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType)
}

class EmployeeTypeTableViewController: UITableViewController {

    weak var delegate: EmployeeTypeTableViewControllerDelegate?
    var employeeType: EmployeeType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return EmployeeType.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTypeCell", for: indexPath)
        let type = EmployeeType.allCases[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = type.description
        
        cell.contentConfiguration = content
        
        if employeeType == type {
            
            cell.accessoryType = .checkmark
        } else {
            
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = EmployeeType.allCases[indexPath.row]
        employeeType = type
        
        delegate?.employeeTypeTableViewController(self, didSelect: type)
        
        tableView.reloadData()
    }
}
