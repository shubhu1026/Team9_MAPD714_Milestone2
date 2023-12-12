//
//  MyBookingsViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-12-11.
//

import UIKit

class MyBookingsViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var bookingsCollectionView: UICollectionView!
    
    let dbManager = DatabaseManager()
    
    var bookingsForUser: [BookingDetails] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        bookingsCollectionView.dataSource = self
        bookingsCollectionView.delegate = self
        
        guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
            print("Not logged in")
            return
        }
        
        if let userID = dbManager.getUserId(forEmail: userEmail) {
            // Retrieve bookings for the user using the obtained userID
            print("User ID: \(userID)")
            bookingsForUser = dbManager.getBookingsForUser(userID: userID)
            bookingsCollectionView.reloadData()
        }
    }
}

extension MyBookingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Bookings: \(bookingsForUser.count)")
        return bookingsForUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCollectionViewCell", for: indexPath) as! BookingCollectionViewCell
        let booking = bookingsForUser[indexPath.item]
        cell.setup(with: booking)
            
        return cell
    }

}
