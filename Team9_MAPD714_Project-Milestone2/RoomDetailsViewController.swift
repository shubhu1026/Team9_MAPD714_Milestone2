//
//  RoomDetailsViewController.swift
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
//  The current file contains code to enter amount of rooms required and code to proceed to add guest details.
//

import UIKit

class RoomDetailsViewController: UIViewController {
    @IBOutlet weak var cruiseName: UILabel!
    var cruise: Cruise?
    @IBOutlet weak var cardView: UIStackView!
    @IBOutlet weak var totalRooms: UILabel!
    @IBOutlet weak var continueButton: UIButton!
//    @IBOutlet weak var continueButton: UIButton!
//    @IBOutlet weak var cardView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let cruise = cruise {
            cruiseName.text = cruise.name
        }
        setupCardView()
        setupButton()
        // Do any additional setup after loading the view.
    }
    func setupCardView()
    {   
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 2
        cardView.layer.masksToBounds = false
        
//        titleLabel.textColor = UIColor.white
    }
    @IBAction func onRoomSliderChange(_ sender: UISlider) {
        totalRooms.text = "\(lroundf(sender.value))"
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
    func setupBackButton()
        {
            let backButton = UIBarButtonItem()
            backButton.title = "Back"
            backButton.tintColor = UIColor.black

            // Set the custom back button for this view controller
            self.navigationItem.backBarButtonItem = backButton
    }
    
    @IBAction func continueButtonFunction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "PassengerDetails", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "PassengerDetailsViewController") as!
        PassengerDetailsViewController
                    viewController.totalRooms = totalRooms.text
        viewController.cruise = cruise
        setupBackButton()
                self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
//    class Cruise {
//        var name: String
//        var nights: Int
//        var departurePort: String
//        var cost: Double
//        var imageName: String
//        var numPorts: Int
//        
//        init(name: String, nights: Int, departurePort: String, cost: Double, imageName: String, numPorts: Int) {
//            self.name = name
//            self.nights = nights
//            self.departurePort = departurePort
//            self.cost = cost
//            self.imageName = imageName
//            self.numPorts = numPorts
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}

