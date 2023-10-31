//
//  CruiseDetailsViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-10-30.
//

import UIKit

class CruiseDetailsViewController: UIViewController {

    var cruise: Cruise?
    
    @IBOutlet weak var cruiseName: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        if let cruise = cruise {
                    // Update your UI elements with the details from the 'cruise' property
                    // For example, you can set labels or image views with cruise.name, cruise.nights, etc.
            cruiseName.text = cruise.name
        }
        setupButton()
    }
    
    func setupBackground() {
        let background = UIImage(named: "bgShip")
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    func setupButton()
    {
        let customColor = UIColor(red: 5/255, green: 29/255, blue: 31/255, alpha: 0.7)
        bookButton.tintColor = customColor
        
        bookButton.layer.shadowColor = UIColor.black.cgColor
        bookButton.layer.shadowOffset = CGSize(width: 4, height: 8)
        bookButton.layer.shadowRadius = 4
        bookButton.layer.shadowOpacity = 0.25
    }
    
}
