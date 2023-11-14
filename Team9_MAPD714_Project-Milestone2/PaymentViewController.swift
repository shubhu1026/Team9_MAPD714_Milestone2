//
//  PaymentViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-13.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    
    @IBOutlet weak var applePayButton: UIButton!
    @IBOutlet weak var creditDebitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBackground()
        setupButtons()
        setupCardView()
        // Do any additional setup after loading the view.
    }
    
    func setupBackground() {
        let background = UIImage(named: "bgPayment")
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)

        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        self.view.sendSubviewToBack(imageView)
    }

    func setupButtons()
    {
        let customColor = UIColor(red: 5/255, green: 29/255, blue: 31/255, alpha: 0.7)
        payButton.tintColor = customColor
        
        payButton.layer.shadowColor = UIColor.black.cgColor
        payButton.layer.shadowOffset = CGSize(width: 4, height: 8)
        payButton.layer.shadowRadius = 4
        payButton.layer.shadowOpacity = 0.25
        
        let transparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        applePayButton.backgroundColor = transparent
        applePayButton.tintColor = transparent
        
        creditDebitButton.backgroundColor = transparent
        creditDebitButton.tintColor = transparent
        
        applePayButton.imageView?.contentMode = .scaleAspectFit
        creditDebitButton.imageView?.contentMode = .scaleAspectFit
    }

    func setupCardView()
    {
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        
        //cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 2
        cardView.layer.masksToBounds = false
    }
  
    
    @IBAction func applePayClicked(_ sender: Any) {
        print("apple tapped")
        applePayButton.setImage(UIImage(named: "Apple Pay Selected"), for: .normal)
        creditDebitButton.setImage(UIImage(named: "CD"), for: .normal)
    }
    
    @IBAction func creditDebutClicked(_ sender: Any) {
        applePayButton.setImage(UIImage(named: "Apple Pay"), for: .normal)
        creditDebitButton.setImage(UIImage(named: "CD Selected"), for: .normal)
    }
    
    @IBAction func payButtonClicked(_ sender: Any){
        let storyboard = UIStoryboard(name: "CheckoutScreen", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "checkoutViewController") as! CheckoutViewController
        
        setupBackButton()
        viewController.loadViewIfNeeded()
        
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
