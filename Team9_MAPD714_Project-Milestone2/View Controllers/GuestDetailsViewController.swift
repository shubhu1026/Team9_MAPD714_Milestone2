//
//  GuestDetailsViewController.swift
//  IOS_Design_Practice
//
//  Created by Anmol Sharma on 2023-11-27.
//

import UIKit
class GuestDetailsViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var guestDetailsTable: UITableView!
    var selectedCruise: Cruise?
    @IBOutlet weak var cruiseName: UILabel!
    @IBOutlet weak var guestDetailsModal: UIView!
    
    var totalRooms : String = "0"
    
    var booking: BookingDetails?
    
    let dbManager = DatabaseManager()

    @IBOutlet weak var totalRoomLabel: UILabel!
    var guestDetails : [GuestDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Apply styles to guestDetailsModal
        guestDetailsModal.layer.cornerRadius = 12
        guestDetailsModal.layer.borderWidth = 1
        guestDetailsModal.layer.borderColor = UIColor(hex: "#A7A7A7").cgColor
        guestDetailsModal.backgroundColor = UIColor.white
        guestDetailsModal.layer.shadowColor = UIColor.black.cgColor
        guestDetailsModal.layer.shadowOffset = CGSize(width: 0, height: 4)
        guestDetailsModal.layer.shadowRadius = 4
        guestDetailsModal.layer.shadowOpacity = 0.25
        if let selectedCruise = selectedCruise {
                    // Example: Update UI elements with selected cruise data
            cruiseName.text = selectedCruise.name
                    print("Selected Cruise Name: \(selectedCruise.name)")
                    // Update your UI elements here using selectedCruise properties
        }
        
        guestDetailsTable.delegate = self
        guestDetailsTable.dataSource = self
        guestDetailsTable.reloadData()
    }
    
    @IBAction func totalRoomsSelected(_ sender: UISlider) {
        totalRooms = "\(lroundf(sender.value))"
        totalRoomLabel.text = "Total Rooms - \(lroundf(sender.value))"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestDetailsCell", for: indexPath) as! GuestDetailsViewCell
        // Add a separator inset to the cell
        let guestDetail = guestDetails[indexPath.row]
        cell.guestName.text = guestDetail.name
        cell.GuestDetails.text = "(\(guestDetail.gender), \(guestDetail.age) yrs)"
        cell.editGuest.addTarget(self, action: #selector(editGuestButtonTapped(_:)), for: .touchUpInside)
        cell.deleteGuest.addTarget(self, action: #selector(deleteGuestButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    @objc func editGuestButtonTapped(_ sender: UIButton) {
           print("edit Guest Button Tapped")
           // Get the index path of the cell
           let buttonPosition = sender.convert(CGPoint.zero, to: self.guestDetailsTable)
           if let indexPath = self.guestDetailsTable.indexPathForRow(at: buttonPosition) {

               // Get the selected guest
               let selectedGuest = guestDetails[indexPath.row]

               // Create a UIAlertController
               let alertController = UIAlertController(title: "Edit Guest", message: nil, preferredStyle: .alert)

               // Add text fields with existing guest details
               alertController.addTextField { textField in
                   textField.placeholder = "Enter Guest Name"
                   textField.text = selectedGuest.name
               }
               alertController.addTextField { textField in
                   textField.placeholder = "Enter Gender"
                   textField.text = selectedGuest.gender
               }
               alertController.addTextField { textField in
                   textField.placeholder = "Enter Age"
                   textField.text = "\(selectedGuest.age)"
                   textField.keyboardType = .numberPad
               }

               // Create actions for OK and Cancel buttons
               let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                   // Retrieve updated guest details from text fields
                   if let name = alertController.textFields?[0].text,
                      let gender = alertController.textFields?[1].text,
                      let ageString = alertController.textFields?[2].text,
                      let age = Int(ageString) {
                       // Update the selected guest with new details
                       self.guestDetails[indexPath.row] = GuestDetail(name: name, gender: gender, age: age)
                       // Reload the table view to reflect the changes
                       self.guestDetailsTable.reloadData()
                   }
               }
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

               // Add actions to the alert controller
               alertController.addAction(okAction)
               alertController.addAction(cancelAction)

               // Present the alert controller
               present(alertController, animated: true, completion: nil)
           }
    }
    @objc func deleteGuestButtonTapped(_ sender: UIButton) {
           print("delete Guest Button Tapped")
           let buttonPosition = sender.convert(CGPoint.zero, to: self.guestDetailsTable)
                if let indexPath = self.guestDetailsTable.indexPathForRow(at: buttonPosition) {
                    // Remove the guest from the array
                    guestDetails.remove(at: indexPath.row)
                    // Reload the table view to reflect the changes
                    guestDetailsTable.reloadData()
                }

    }
    
    @IBAction func addGuestButtonTapped(_ sender: Any) {
        // Create a UIAlertController for adding
              let alertController = UIAlertController(title: "Add Guest", message: nil, preferredStyle: .alert)

              // Add text fields for guest details
              alertController.addTextField { textField in
                  textField.placeholder = "Enter Guest Name"
              }
              alertController.addTextField { textField in
                  textField.placeholder = "Enter Gender"
              }
              alertController.addTextField { textField in
                  textField.placeholder = "Enter Age"
                  textField.keyboardType = .numberPad
              }

              // Create actions for OK and Cancel buttons
              let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                  // Retrieve guest details from text fields
                  if let name = alertController.textFields?[0].text,
                      let gender = alertController.textFields?[1].text,
                      let ageString = alertController.textFields?[2].text,
                      let age = Int(ageString) {
                      // Create a new GuestDetail object
                      let newGuest = GuestDetail(name: name, gender: gender, age: age)

                      // Add the new guest to the array
                      self.guestDetails.append(newGuest)

                      // Reload the table view to reflect the changes
                      self.guestDetailsTable.reloadData()
                  }
              }

              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

              // Add actions to the alert controller
              alertController.addAction(okAction)
              alertController.addAction(cancelAction)

              // Present the alert controller
              present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        createBooking()
        
        let storyboard = UIStoryboard(name: "PaymentView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "paymentViewController") as! PaymentViewController
        
        viewController.booking = booking
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func createBooking() {
        guard let selectedCruise = selectedCruise else {
            print("Selected Cruise information is missing")
            return
        }
        
        guard let bookedBy = getUserName() else {
            print("Booked by user information is missing")
            return
        }

        let bookingDate = Date()
        let rooms = Int(totalRooms) ?? 1
        let totalTripFare = Double(guestDetails.count) * selectedCruise.avgPersonCost + Double(rooms) * (selectedCruise.avgPersonCost / 2)

        let ticketId = generateUniqueTicketNumber()

        booking = BookingDetails(
            bookedBy: bookedBy,
            bookingDate: "\(bookingDate)",
            totalRooms: rooms,
            cruiseSelected: selectedCruise,
            GuestDetails: guestDetails,
            totalTripFare: totalTripFare,
            ticketId: ticketId
        )
    }

    
    func getUserName() -> String? {
        guard let email = UserDefaults.standard.string(forKey: "userEmail") else { return nil }
        return dbManager.getUserInfo(email: email)?.userName
    }
    
    func generateUniqueTicketNumber() -> String {
        var ticketNumber = generateRandomTicketNumber()
        
        // Check if the generated ticket number already exists in the database
        while dbManager.doesTicketNumberExist(ticketNumber: ticketNumber) {
            ticketNumber = generateRandomTicketNumber() // Generate a new ticket number
        }
        
        return ticketNumber
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

}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
