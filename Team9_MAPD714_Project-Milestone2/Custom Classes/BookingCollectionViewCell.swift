//
//  BookingCollectionViewCell.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-12-11.
//

import UIKit

class BookingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cruiseImage: UIImageView!
    @IBOutlet weak var ticketId: UILabel!
    @IBOutlet weak var cruiseName: UILabel!
    @IBOutlet weak var cruiseFrom: UILabel!
    @IBOutlet weak var cruiseTo: UILabel!
    @IBOutlet weak var totalFare: UILabel!
    @IBOutlet weak var guests: UILabel!
    @IBOutlet weak var bookingDate: UILabel!
    @IBOutlet weak var bookedBy: UILabel!
    @IBOutlet weak var roomCount: UILabel!
    
    func setup(with booking: BookingDetails){
        cruiseImage.image = UIImage(named: booking.cruiseSelected.cruiseImageName)
        ticketId.text = "#\(booking.ticketId)"
        cruiseName.text = booking.cruiseSelected.name
        cruiseFrom.text = booking.cruiseSelected.tripFrom
        cruiseTo.text = booking.cruiseSelected.tripTo
        totalFare.text = "$\(booking.totalTripFare)"
        bookingDate.text = booking.bookingDate
        bookedBy.text = booking.bookedBy
        roomCount.text = "\(booking.totalRooms)"
        
    
        let (seniors, adults, children) = calculatePassengerCounts(booking: booking)
        
        var guestText = ""
        if seniors > 0 {
            guestText += "\(seniors) Seniors "
        }
        if adults > 0 {
            guestText += "\(adults) Adults "
        }
        if children > 0 {
            guestText += "\(children) Children "
        }
    
        guests.text = guestText.isEmpty ? "No guests" : guestText.trimmingCharacters(in: .whitespaces)
    }
    
    private func calculatePassengerCounts(booking: BookingDetails) -> (seniors: Int, adults: Int, children: Int) {

        let seniorAgeThreshold = 60
        let adultAgeThreshold = 18

        let seniorCount = booking.GuestDetails.filter { $0.age > seniorAgeThreshold }.count
        let adultCount = booking.GuestDetails.filter { $0.age >= adultAgeThreshold && $0.age <= seniorAgeThreshold }.count
        let childCount = booking.GuestDetails.filter { $0.age < adultAgeThreshold }.count

        return (seniorCount, adultCount, childCount)
    }

}
