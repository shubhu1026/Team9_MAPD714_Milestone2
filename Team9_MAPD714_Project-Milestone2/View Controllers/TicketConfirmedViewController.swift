//
//  TicketConfirmedViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-12-01.
//

import UIKit

class TicketConfirmedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var booking: BookingDetails?
    
    let dbManager = DatabaseManager()
    
    @IBOutlet weak var ticketItineraryTable: UITableView!
    
    @IBOutlet weak var ticketIdText: UILabel!
    @IBOutlet weak var cruiseNameText: UILabel!
    @IBOutlet weak var bookedByText: UILabel!
    @IBOutlet weak var bookingDateText: UILabel!
    @IBOutlet weak var totalRoomsCountText: UILabel!
    @IBOutlet weak var guestsCountText: UILabel!
    @IBOutlet weak var totalTripFareText: UILabel!
    
    var Itinerary : [PortInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let booking = booking {
            ticketItineraryTable.delegate = self
            ticketItineraryTable.dataSource = self
            ticketItineraryTable.reloadData()
            Itinerary = booking.cruiseSelected.visitingPorts
            print("Ticket - Selected Cruise Name: \(booking.cruiseSelected.name)")
            setupLabels()
            
            dbManager.insertBooking(booking: booking)
            guard let email = UserDefaults.standard.string(forKey: "userEmail") else {
                        return  // Handle case where username is not available
                    }
            if let userId = dbManager.getUserId(forEmail: email) {
                dbManager.insertFamilyMembers(forBooking: booking, bookingId: booking.ticketId, userId: userId)
            } else {
                print("Failed to get user ID for email: \(email)")
            }
        }
    }

    private func setupLabels() {
            ticketIdText.text = booking?.ticketId
            cruiseNameText.text = booking?.cruiseSelected.name
            bookedByText.text = booking?.bookedBy
            bookingDateText.text = booking?.bookingDate
            
            if let totalRooms = booking?.totalRooms {
                totalRoomsCountText.text = "\(totalRooms)"
            }
            
            guestsCountText.text = "\(booking?.GuestDetails.count ?? 0)"
            totalTripFareText.text = "$\(booking?.totalTripFare ?? 0)"
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected item
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           // Set the desired height for the cell
           return 130.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Itinerary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ticketItineraryViewCell", for: indexPath) as! TicketItineraryViewCell
        // Add a separator inset to the cell
        let cruiseItinerary = Itinerary[indexPath.row]
        cell.ItineraryTime.text = cruiseItinerary.time
        cell.ItineraryPort.text = cruiseItinerary.name
        cell.ItineraryDate.text = cruiseItinerary.date
        cell.ItineraryPortImage.image = UIImage(named: cruiseItinerary.portImage)
        return cell
    }
    
    func generateRandomTicketNumber() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers = "0123456789"

        let letter1 = String(letters.randomElement()!)
        let letter2 = String(letters.randomElement()!)
        let number1 = String(numbers.randomElement()!)
        let number2 = String(numbers.randomElement()!)
        let number3 = String(numbers.randomElement()!)
        let number4 = String(numbers.randomElement()!)
        let letter3 = String(letters.randomElement()!)

        let ticketNumber = "\(letter1)\(letter2)\(number1)\(number2)\(number3)\(number4)\(letter3)"
        return ticketNumber
    }

    // Generate a random ticket number
    //let randomTicketNumber = generateRandomTicketNumber()
    //print(randomTicketNumber) // Output something like "LX23412A"
}
