//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 28.12.21.
//

import UIKit
import UserNotifications

class OrderConfirmationViewController: UIViewController {
    
    let minuteToPrepare: Int
    var timeToNotify = 10
    @IBOutlet weak var progresView: UIProgressView!
    
    @IBOutlet weak var confirmationLabel: UILabel! {
        didSet {
            confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minuteToPrepare) minutes"
        }
    }
    
    init?(coder: NSCoder, minuteToPrepare: Int) {
        self.minuteToPrepare = minuteToPrepare
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let progres = Progress()
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestNotificationAuthorization()
        self.sendNotification()
        
        updateProgresView()
    }
    
    private func updateProgresView() {
        let menuItem = MenuController.shared.order.menuItems.map {$0.id}
        MenuController.shared.submitOrder(forMenuIDs: menuItem) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let timeLeft):
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        self.progresView.setProgress(Float(timeLeft)*Float(self.minuteToPrepare), animated: true)
                    })
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func requestNotificationAuthorization() {
        // Auth options
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
   private func sendNotification() {
        // Create new notifcation content instance
        let content = UNMutableNotificationContent()
        
        // Add the content to the notification content
        content.title = "Your order will be ready in \(minuteToPrepare) minutes"
        content.body = " Thank you ORDER APP"
        content.sound = .default
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
 
       /// Fix Me
       dateComponents.second = 15
       
    
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: false)
       
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }
}

