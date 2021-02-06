//
//  FoodDetailsViewController.swift
//  Foody Eatz
//
//  Created by developer on 06/02/21.
//  Copyright © 2021 Ashwini. All rights reserved.
//

import UIKit

class FoodDetailsViewController: UIViewController,UITextViewDelegate{
    
    @IBOutlet var foodDetailsMainView: UIView!
    
    @IBOutlet var foodImage: UIImageView!
    @IBOutlet var foodName: UILabel!
    @IBOutlet var foodDescriptionTextView: UITextView!
    
    @IBOutlet var foodDescriptionView: UIView!
    @IBOutlet var foodOrderBtn: UIButton!
    
    @IBOutlet var locationImg: UIImageView!
    @IBOutlet var locationName: UILabel!
    
    var foodDetails:FoodItems?
    var isOrdered = Bool()
    
    static var callback: ((Int?)->())?
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        //BackButton
        let backBtn = UIButton()
        self.view.addSubview(backBtn)
        backBtn.backgroundColor = UIColor.clear
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.setImage(UIImage(named:"backImage"), for: .normal)
        backBtn.contentHorizontalAlignment = .left
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        NSLayoutConstraint.activate([
            backBtn.heightAnchor.constraint(equalToConstant: 25),
            backBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            backBtn.widthAnchor.constraint(equalToConstant: 40),
            backBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20)
        ])
        
        foodDescriptionView.roundTop(radius: 20)
        foodDescriptionView.backgroundColor = .black
        
        //Parsing Image
        switch  foodDetails?.foodImage{
        case "Neapolitan":
            self.foodImage.image = UIImage(named: "pizza1")
            break
        case "Chicago":
            self.foodImage.image = UIImage(named: "pizza2")
            break
        case "Veggie":
            self.foodImage.image = UIImage(named: "burger1")
            break
        case "Bison":
            self.foodImage.image = UIImage(named: "burger2")
            break
        default:
            break
        }
        
        foodName.setCenterlabelProp()
        //foodName.textColor  = UIColor.black
        foodName.text = foodDetails?.foodName
        
        locationImg.image = UIImage(named: "location")
        locationName.text = foodDetails?.location
        locationName.setleftlabelProp()

        
        
        if isOrdered {
            foodOrderBtn.setTitle("Cancel Item", for: .normal)
        }else{
            foodOrderBtn.setTitle("Order Item", for: .normal)
        }
        
        
        foodOrderBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        foodOrderBtn.backgroundColor = #colorLiteral(red: 0.6771494289, green: 0.05744416533, blue: 0.06482394307, alpha: 1)
        foodOrderBtn.setTitleColor(.white, for: .normal)
        foodOrderBtn.isExclusiveTouch = true
        foodOrderBtn.addTarget(self, action: #selector(orderItem), for: UIControl.Event.touchUpInside)
        foodOrderBtn.layer.cornerRadius = 5
        
        foodDescriptionTextView.text = foodDetails?.info
        foodDescriptionTextView.backgroundColor = .black
        foodDescriptionTextView.textColor = UIColor.white
        foodDescriptionTextView.textContainer.lineFragmentPadding = 0
        foodDescriptionTextView.textContainerInset = .zero
        foodDescriptionTextView.setContentOffset(.zero, animated: false)
        foodDescriptionTextView.isUserInteractionEnabled = true
        foodDescriptionTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        foodDescriptionTextView.font = UIFont.systemFont(ofSize: 12)
        foodDescriptionTextView.showsVerticalScrollIndicator = true
        foodDescriptionTextView.showsHorizontalScrollIndicator = false
        
        
    }
    
    //MARK:- backBtnAction
    @objc func backBtnAction(){
        self.view.endEditing(true)
        //Moving back to previous page
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- orderItem
    @objc func orderItem() {
        
        FoodDetailsViewController.callback?(foodDetails?.id )
        backBtnAction()
        
    }
    
    //MARK:- textViewShouldBeginEditing
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return false
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
