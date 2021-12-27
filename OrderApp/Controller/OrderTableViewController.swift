//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 24.12.21.
//

import UIKit

class OrderTableViewController: UITableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdateNotification, object: nil)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
}

 // MARK: - TableView
extension OrderTableViewController {
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath)
        configureCell(cell, forItemAt: indexPath)
        return cell
    }
    
    private func configureCell(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let order = MenuController.shared.order.menuItems[indexPath.row]
        cell.textLabel?.text = order.name
        cell.detailTextLabel?.text = MenuController.priceFormatter.string(from: NSNumber(value: order.price))
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        }
    }
}
