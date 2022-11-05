//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Rajveer Singh on 02/11/22.
//

import UIKit

@MainActor
class MenuTableViewController: UITableViewController {

    let category: String
    var menuItems = [MenuItem]()
    
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    init?(coder: NSCoder, category: String) {
        
        self.category = category
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Task.init {
            
            do {
                
                let menuItems = try await MenuController.shared.fetchMenuItems(forCategory: category)
                
                updateUI(with: menuItems)
            } catch {
                
                displayError(error, title: "Failed to Fetch Menu Items for \(self.category)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MenuController.shared.updateUserActivity(with: .menu(category: category))
    }
    
    @IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuItemDetailViewController? {
        
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            
            return nil
        }
        
        return MenuItemDetailViewController(coder: coder, menuItem: menuItems[indexPath.row])
    }
    
    func updateUI(with menuItems: [MenuItem]) {
        
        self.menuItems = menuItems
        self.tableView.reloadData()
    }
    
    func displayError(_ error: Error, title: String) {
        
        guard let _ = viewIfLoaded?.window else { return }
        
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)
        
        configureCell(cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        imageLoadTasks[indexPath]?.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        imageLoadTasks.forEach { (key, value) in
            
            value.cancel()
        }
    }
    
    func configureCell(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? MenuItemCell else { return }
        
        let menuItem = menuItems[indexPath.row]
            
        cell.itemName = menuItem.name
        cell.price = menuItem.price
        cell.image = nil
        
        imageLoadTasks[indexPath] = Task.init {
            
            if let image = try? await MenuController.shared.fetchImage(from: menuItem.imageURL) {
                
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                   currentIndexPath == indexPath {
                    
                    //cell resizes to fit original image size.
                    //cell.image = image
                }
            }
            
            imageLoadTasks[indexPath] = nil
        }
    }
}
