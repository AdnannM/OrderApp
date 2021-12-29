//
//  MenuDetailViewController.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 24.12.21.
//

import UIKit

class MenuDetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton! {
        didSet {
            addToOrderButton.layer.cornerRadius = 20
        }
    }
    
    let menuItem: MenuItem
    
    // Pass Data
    init?(coder: NSCoder, menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(with: .menuItemDetail(menuItem))
    }
    
    private func updateUI() {
        nameLabel.text = menuItem.name
        detailLabel.text = menuItem.description
        priceLabel.text = MenuController.priceFormatter.string(from: NSNumber(value: menuItem.price))
        
        MenuController.shared.fetchImage(with: menuItem.imageURL) { image in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    // MARK: - Action
    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 3.0, y: 2.0)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
        MenuController.shared.order.menuItems.append(menuItem)
    }
}

