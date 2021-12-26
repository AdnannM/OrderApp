//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 24.12.21.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCategories()
    }
    
    private func fetchCategories() {
        MenuController.shared.fetchCategories { result in
            switch result {
            case.success(let category):
                self.updateUI(with: category)
            case .failure(let error):
                self.displayError(error, title: "Failed To Fetch Categories")
            }
        }
    }
    
    private func updateUI(with categories: [String]) {
        DispatchQueue.main.async {
            self.categories = categories
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
    
     // MARK: - IBSegueAction - Pass Data
    @IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
                  return nil
              }
        let category = categories[indexPath.row]
        return MenuTableViewController(coder: coder, categories: category)
    }
}

 // MARK: - TableView
extension CategoryTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        configureCell(cell, forCategoryAt: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.capitalized
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 20)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
