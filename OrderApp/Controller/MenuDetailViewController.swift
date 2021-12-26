//
//  MenuDetailViewController.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 24.12.21.
//

import UIKit

class MenuDetailViewController: UIViewController {
    
    let menuItem: MenuItem
    
    init?(coder: NSCoder, menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
