//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 24.12.21.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var categories: String
    var menuItems = [MenuItem]()
    
    init?(coder: NSCoder, categories: String) {
        self.categories = categories
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMenuItems()
        
    }
    
    private func fetchMenuItems() {
        title = categories.description.capitalized
        MenuController.shared.fetchMenuItems(forCategory: categories) { result in
            switch result {
            case .success(let menuItems):
                self.updateUI(with: menuItems)
            case.failure(let error):
                self.displayError(error, title: "Failed to Fetch Menu Items")
            }
        }
    }
    
    private func updateUI(with menuItems: [MenuItem]) {
        DispatchQueue.main.async {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
    }
    
    private func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
     // MARK: - IBActionSegue
    @IBSegueAction func showMenuItem(_ coder: NSCoder, sender: Any?) -> MenuDetailViewController? {
        guard let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell) else { return nil }
              let menuItem = menuItems[indexPath.row]
              return MenuDetailViewController(coder: coder, menuItem: menuItem)
    }
}
    // MARK: - TableView
    extension MenuTableViewController {
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return menuItems.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuItem", for: indexPath)
            configureCell(cell, forMenuItemsAt: indexPath)
            return cell
        }
        
        func configureCell(_ cell: UITableViewCell, forMenuItemsAt indexPath: IndexPath) {
            let menuItem = menuItems[indexPath.row]
            cell.textLabel?.text = menuItem.name
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 20)
            cell.detailTextLabel?.text = MenuController.priceFormatter.string(from: NSNumber(value: menuItem.price))
            MenuController.shared.fetchImage(with: menuItem.imageURL) { image in
                guard let image = image else {
                    return
                }
                DispatchQueue.main.async {
                    if let currentIndex = self.tableView.indexPath(for: cell),
                       currentIndex != indexPath {
                        return
                    }
                    
                    cell.imageView?.image = image
                    cell.setNeedsLayout()
                }
            }
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
    }
    
