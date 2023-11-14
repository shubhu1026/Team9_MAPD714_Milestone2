//
//  PassengerDetailsViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-13.
//
//  Team Number: 9
//  Milestone Number: 3
//
//  Team Members:
//  Shubham Patel - 301366205
//  Anmol Sharma - 301364872
//  Submission date - 13 Nov 2023
//
//  The current file contains code to show sample guests, to add new guest and code for navigating to payment page.
//

import UIKit

class PassengerDetailsViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cruise: Cruise?
    var booking : bookingDetails?
    var totalRooms  : String?
    @IBOutlet weak var cruiseName: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var totalRoomsCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        if let totalRooms = totalRooms {
            totalRoomsCount.text = totalRooms
        }
        if let cruise = cruise {
            cruiseName.text = cruise.name
        }
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupButton()
        addSampleData()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let booking = booking {
            return booking.guestDetails.count
                        // Access properties of booking safely here
        } else {
            return 0
                        // Handle the case where booking is nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestCell", for: indexPath) as! GuestCell
        
        if let guest = booking?.guestDetails[indexPath.item] {
            cell.setupGuest(guest: guest)
        }
        
        return cell
    }
    
    @IBAction func AddGuestDetails(_ sender: UIButton) {
        if booking != nil {
            let newGuest = GuestDetail(Name: "Emma", Age: 25, Gender: "Female")
            booking!.addGuest(newGuest) // Add the new guest to the booking
            tableView.reloadData() // Reload table data after adding a new guest
        } else {
            // Handle the case where booking is nil
        }
    }
    
    func addSampleData() {
                let sampleGuests = [
                    GuestDetail(Name: "John", Age: 30, Gender: "Male"),
                    GuestDetail(Name: "Alice", Age: 25, Gender: "Female"),
                    // Add more sample guests as needed
                ]
                
                // Create a booking object and populate it with sample data
                booking = bookingDetails(BookedBy: "Sample", guestDetails: sampleGuests, totalRooms: "5", bookingDate: "2023-11-14")
                
                // Reload table data after adding sample guests
                tableView.reloadData()
            }
    
    func setupButton()
    {
        let customColor = UIColor(red: 5/255, green: 29/255, blue: 31/255, alpha: 0.7)
        continueButton.tintColor = customColor
        
        continueButton.layer.shadowColor = UIColor.black.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 4, height: 8)
        continueButton.layer.shadowRadius = 4
        continueButton.layer.shadowOpacity = 0.25
    }
    
    @IBAction func continuePaymentPage(_ sender: Any) {
        let storyboard = UIStoryboard(name: "PaymentScreen", bundle: nil)

                let viewController = storyboard.instantiateViewController(withIdentifier: "paymentViewController") as! PaymentViewController
        setupBackButton()
                self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    func setupBackButton()
        {
            let backButton = UIBarButtonItem()
            backButton.title = "Back"
            backButton.tintColor = UIColor.black

            // Set the custom back button for this view controller
            self.navigationItem.backBarButtonItem = backButton
    }
}

struct GuestDetail {
        var Name: String
        var Age: Int
        var Gender : String
}

class GuestCell: UITableViewCell{
    
    @IBOutlet weak var guestGenderLabel: UILabel!
    @IBOutlet weak var guestAgeLabel: UILabel!
    @IBOutlet weak var guestNameLabel: UILabel!
    
    func setupGuest(guest: GuestDetail)
    {
        guestNameLabel.text = guest.Name
        guestAgeLabel.text = "\(guest.Age)"
        guestGenderLabel.text = guest.Gender
    }
}

class bookingDetails {
        var totalRooms : String
        var BookedBy : String
        var BookingDate : String
        var guestDetails: [GuestDetail]
    
    init(BookedBy: String, guestDetails: [GuestDetail] , totalRooms : String, bookingDate : String) {
        self.BookedBy = BookedBy
        self.guestDetails = guestDetails
        self.totalRooms = totalRooms
        self.BookingDate = bookingDate
    }
    
    func addGuest(_ guestDetail: GuestDetail) {
        guestDetails.append(guestDetail)
    }
}

