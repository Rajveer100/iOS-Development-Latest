//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Rajveer Singh on 07/10/22.
//

import UIKit

class RegistrationTableViewController: UITableViewController {

    var registrations: [Registration] = []
    
    var isInViewMode: Bool = false
    var viewModeIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func unwindFromAddRegistration(unwindSegue: UIStoryboardSegue) {
        
        guard let addRegistrationTableViewController = unwindSegue.source as? AddRegistrationTableViewController else { return }
        
        guard let registration = addRegistrationTableViewController.registration else
        { return }
        
        if !isInViewMode {
            
            registrations.append(registration)
        } else {
            
            if let viewModeIndexPath = viewModeIndexPath {
                
                registrations[viewModeIndexPath.row] = registration
            }
        }
        
        tableView.reloadData()
    }
    
    @IBSegueAction func viewEditRegistration(_ coder: NSCoder, sender: Any?) -> AddRegistrationTableViewController? {
        
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            
            return AddRegistrationTableViewController(coder: coder, registration: nil)
        }
        
        isInViewMode = true
        viewModeIndexPath = indexPath
        
        let registration = registrations[indexPath.row]
        
        return AddRegistrationTableViewController(coder: coder, registration: registration)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return registrations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        
        let registration = registrations[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(registration.firstName) \(registration.lastName)"
        content.secondaryText = (registration.checkInDate..<registration.checkOutDate).formatted(date: .numeric, time: .omitted) + " " + registration.roomType.name
        
        cell.contentConfiguration = content
        
        return cell
    }
}
