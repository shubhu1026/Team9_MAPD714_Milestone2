//
//  CheckoutViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-13.
//

import UIKit

class CheckoutViewController: UIViewController {

    @IBOutlet weak var ticketTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setupCardView()
        setupBackground()
        // Do any additional setup after loading the view.
    }
    
    func setupBackground() {
        let background = UIImage(named: "bgTicket")
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.layer.cornerRadius = 10
        imageView.center = view.center
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: ticketTitle.bottomAnchor, constant: 30).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22).isActive = true
        
        self.view.sendSubviewToBack(imageView)
    }
      
    /*
    func setupCardView()
    {
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 2
        cardView.layer.masksToBounds = false
        
        self.view.sendSubviewToBack(cardView)
    }
     */
}
