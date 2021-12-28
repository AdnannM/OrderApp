//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 24.12.21.
//

import UIKit

class OrderTableViewController: UITableViewController {

    var minuteToPrepare = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdateNotification, object: nil)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
     // MARK: - Action
    @IBSegueAction func confirmOrder(_ coder: NSCoder, sender: Any?) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder, minuteToPrepare: minuteToPrepare)
    }
    
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) {
            (reuslt, menuItem) -> Double in
            return reuslt + menuItem.price
        }
        
        let formattedTotal = MenuController.priceFormatter.string(from: NSNumber(value: orderTotal)) ?? "\(orderTotal)"
        
        let alertController = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with total of \(formattedTotal)", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            self.uploadOrder()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func uploadOrder() {
        
        let menuItem = MenuController.shared.order.menuItems.map {$0.id}
        MenuController.shared.submitOrder(forMenuIDs: menuItem) { result in
            switch result {
            case .success(let minuteToPrepare):
                DispatchQueue.main.async {
                    self.minuteToPrepare = minuteToPrepare
                    self.performSegue(withIdentifier: "confirmOrder", sender: nil)
                }
                
            case.failure(let error):
                self.displayError(error, title: "Order Submission Failed")
            }
        }
    }
    
    private func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToOrder(segue: UIStoryboardSegue) {
        if segue.identifier == "dismissOrder" {
            MenuController.shared.order.menuItems.removeAll()
        }
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
        
        MenuController.shared.fetchImage(with: order.imageURL) { image in
            guard let image = image else {
                return
            }
            
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                   currentIndexPath != indexPath {
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
