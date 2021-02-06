//
//  HomeViewController.swift
//  Foody Eatz
//
//  Created by developer on 06/02/21.
//  Copyright © 2021 Ashwini. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var foodCategoryTableView: UITableView!
    @IBOutlet var bannerView: UIView!
    @IBOutlet var bannerCollectionView: UICollectionView!
    
 
    @IBOutlet var welcomeView: UIView!
    @IBOutlet var welcomeText: UILabel!
    
    
    var hiddenSections = Set<Int>()
    var saveSelectedID = Set<Int>()
    var bannerLoadTimer:Timer!
    
    var homeVM = HomeViewModel()
    var foodItemsList:FoodItemsList_Base?
    var selectedSection = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Registering Xib for tableview
        let foodCategoryTableViewNib = UINib.init(nibName: "FoodListTableViewCell", bundle: nil)
        foodCategoryTableView.register(foodCategoryTableViewNib, forCellReuseIdentifier: "FoodListTableViewCell")
        
        //Registering Xib for collectionview
        let bannerNib = UINib.init(nibName: "BannerCollectionViewCell", bundle: nil)
        bannerCollectionView.register(bannerNib, forCellWithReuseIdentifier: "BannerCollectionViewCell")
        
        //collectionview layout
        let domainViewWidth =  (UIScreen.main.bounds.size.width - 60)
        bannerView.backgroundColor = UIColor.black
        bannerCollectionView.backgroundColor = .black
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: domainViewWidth, height: 150)
        bannerCollectionView.collectionViewLayout = layout
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.showsVerticalScrollIndicator = false
        bannerCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)
        
        //tableview properties
        foodCategoryTableView.separatorStyle = .none
        foodCategoryTableView.backgroundColor = .black
        
        //view properties
        self.view.backgroundColor = .black
        self.navigationController?.isNavigationBarHidden = true
        
        //loading Data
        foodItemsList = homeVM.readJsonFile()
        print("FoodItems",foodItemsList ?? FoodItemsList_Base.self)
        
        self.view.addSubview(welcomeView)
        welcomeView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        welcomeText.text = "Foody Eatz"
        welcomeText.font = UIFont.boldSystemFont(ofSize: 30)
        welcomeText.textAlignment = .center
        welcomeText.textColor = UIColor.white
        welcomeView.frame = self.view.frame
        
        foodCategoryTableView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Put your code which should be executed with a delay here
            self.welcomeView.isHidden = true
            self.foodCategoryTableView.isHidden = false
            
        }
        
    }
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        //Get selected Data
        FoodDetailsViewController.callback = { getId in
            if self.saveSelectedID.contains(getId ?? 1000) {
                self.saveSelectedID.remove(getId ?? 1000)
            }else{
                self.saveSelectedID.insert(getId ?? 1000)
            }
        }
        
        DispatchQueue.main.async {
            self.foodCategoryTableView.reloadData()
            self.bannerCollectionView.reloadData()
        }
    }
    
    
    //MARK:- hideSection
    // to exapnd and collapse option
    @objc private func hideSection(sender: UIButton) {
        let section = sender.tag
        
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            if let dataOption = foodItemsList?.foodItems?[section].count {
                
                for row in 0..<dataOption {
                    indexPaths.append(IndexPath(row: row,
                                                section: section))
                }
            }
            return indexPaths
        }
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.foodCategoryTableView.insertRows(at: indexPathsForSection(),
                                                  with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.foodCategoryTableView.deleteRows(at: indexPathsForSection(),
                                                  with: .fade)
        }
        
        foodCategoryTableView.reloadData()
    }
    
    //MARK:- orderItem
    @objc func orderItem(sender:UIButton) {
        
        moveToFoodVc(indexPath: IndexPath(row: sender.tag, section: selectedSection))
        
    }
    
    //MARK:- moveToFoodVc
    func moveToFoodVc(indexPath: IndexPath) {
        let foodDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodDetailsViewController") as! FoodDetailsViewController
        foodDetailsVC.foodDetails = foodItemsList?.foodItems?[indexPath.section][indexPath.row]
        //Extensions.saveSelectedIndepath = IndexPath(row: indexPath.row, section: indexPath.section)
        if self.saveSelectedID.contains(foodItemsList?.foodItems?[indexPath.section][indexPath.row].id ?? 1000) {
            foodDetailsVC.isOrdered = true
        }else{
            foodDetailsVC.isOrdered = false
        }
        
        self.navigationController?.pushViewController(foodDetailsVC, animated: true)
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

//MARK:- UITableViewDelegate,UITableViewDataSource
extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return foodItemsList?.foodItems?.count ?? 0
    }
    
    //MARK:- numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }else{
            if self.hiddenSections.contains(section) {
                return 0
            }
            return foodItemsList?.foodItems?[section].count ?? 0
        }
    }
    
    //MARK:- cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == foodCategoryTableView {
            guard let cell = foodCategoryTableView.dequeueReusableCell(withIdentifier: "FoodListTableViewCell") as? FoodListTableViewCell else {
                return UITableViewCell()
            }
         
            cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.foodView.layer.cornerRadius = 5
            cell.selectionStyle = .none
            
            cell.foodImageView.roundTop()
            
            
            //Selection functionality
            if  saveSelectedID.contains(foodItemsList?.foodItems?[indexPath.section][indexPath.row].id ?? 10001) {
                cell.foodView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                cell.addCartBtn.setTitle("Cancel", for: .normal)
                cell.addCartBtn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            }else{
                cell.addCartBtn.setTitle("Add", for: .normal)
                cell.foodView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.addCartBtn.backgroundColor = #colorLiteral(red: 0.6771494289, green: 0.05744416533, blue: 0.06482394307, alpha: 1)
            }
            
            //Parsing data
            if let foodItems = foodItemsList?.foodItems?[indexPath.section][indexPath.row] {
                
                cell.foodNameLabel.text = foodItems.foodName
                cell.foodRateLabel.text = foodItems.price
                cell.shopName.text = foodItems.shopName
                cell.offerLabel.text = "Offer \(foodItems.offer ?? "0%")"
                
                switch  foodItems.foodImage{
                case "Neapolitan":
                    cell.foodImageView.image = UIImage(named: "pizza1")
                    break
                case "Chicago":
                    cell.foodImageView.image = UIImage(named: "pizza2")
                    break
                case "Veggie":
                    cell.foodImageView.image = UIImage(named: "burger1")
                    break
                case "Bison":
                    cell.foodImageView.image = UIImage(named: "burger2")
                    break
                default:
                    break
                }
            }
            
            //Ui parsing
            cell.foodNameLabel.setlabelProp()
            cell.foodRateLabel.setlabelProp()
            cell.shopName.setlabelProp()
            cell.offerLabel.setlabelProp()
            cell.offerLabel.textColor = #colorLiteral(red: 0, green: 0.5, blue: 0, alpha: 1)
            cell.foodImageView.contentMode = .scaleAspectFill
            
            cell.addCartBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.addCartBtn.setTitleColor(.white, for: .normal)
            cell.addCartBtn.isExclusiveTouch = true
            cell.addCartBtn.tag = indexPath.row
            selectedSection = indexPath.section
            cell.addCartBtn.addTarget(self, action: #selector(orderItem(sender:)), for: UIControl.Event.touchUpInside)
            cell.addCartBtn.roundBottom(radius: 5)
            
            return cell
        }else{
            return UITableViewCell()
        }
        
    }
    
    //MARK:- heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
    
    //MARK:- viewForHeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section != 0 {
            
            var cellLayout = [String:AnyObject]()
            
            let headerBgView = UIView.init()
            headerBgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40)
            headerBgView.backgroundColor = #colorLiteral(red: 0.6771494289, green: 0.05744416533, blue: 0.06482394307, alpha: 1)
            cellLayout["headerBgView"] = headerBgView
            
            
            let headerView = UIView.init()
            headerBgView.addSubview(headerView)
            headerView.backgroundColor = #colorLiteral(red: 0.6771494289, green: 0.05744416533, blue: 0.06482394307, alpha: 1)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            cellLayout["headerView"] = headerView
            headerBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(1)-[headerView]-(1)-|", options: [], metrics: nil, views: cellLayout))
            headerBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(1)-[headerView]-(1)-|", options: [], metrics: nil, views: cellLayout))
            
            headerView.layer.cornerRadius = 5
            
            //HeaderTitle
            let headerTitle = UILabel.init()
            headerTitle.setCenterlabelProp()
            headerTitle.numberOfLines = 0
            headerView.addSubview(headerTitle)
            headerTitle.translatesAutoresizingMaskIntoConstraints = false
            //Title allocation
            headerTitle.text = "\(foodItemsList?.categoryList?[section] ?? "")"
            
            //disclosureButton
            let disclosureBtn: UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
            headerView.addSubview(disclosureBtn)
            disclosureBtn.contentMode = .right
            disclosureBtn.translatesAutoresizingMaskIntoConstraints  = false
            disclosureBtn.tag = section
            if self.hiddenSections.contains(section) {
                disclosureBtn.setImage(UIImage (named:"darrow") , for: UIControl.State())
            }else{
                disclosureBtn.setImage(UIImage (named:"uparrow") , for: UIControl.State())
            }
            disclosureBtn.addTarget(self,action: #selector(self.hideSection(sender:)),for: .touchUpInside)
            
            
            headerTitle.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: disclosureBtn.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15), size: CGSize(width: 0, height: 0))
            
            
            disclosureBtn.anchor(top: headerView.topAnchor, leading: nil, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5), size: CGSize(width: 15, height: 0))
            
            
            return headerBgView
            
        }else{
            
            let headerBgView = UIView.init()
            headerBgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 150)
            headerBgView.backgroundColor = .black
            
            headerBgView.addSubview(bannerView)
            bannerView.frame = headerBgView.frame
            
            return headerBgView
        }
        
    }
    
    //MARK:- heightForFooterInSection
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    //MARK:- viewForFooterInSection
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerBgView = UIView.init()
        headerBgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 10)
        headerBgView.backgroundColor = .black
        
        return headerBgView
    }
    
    //MARK:- heightForHeaderInSection
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 150 : 30
    }
    
    //MARK:- didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        moveToFoodVc(indexPath: IndexPath(row: indexPath.row, section: indexPath.section))
    }
    
}

//MARK:- UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK:- numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK:- numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodItemsList?.bannerData?.count ?? 0
    }
    
    //MARK:- cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == bannerCollectionView {
            
            let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
            
            cell.backgroundColor = .black
            cell.bannerView.backgroundColor = .black
            cell.bannerView.layer.cornerRadius = 5
            cell.bannerImage.backgroundColor = .black
            cell.bannerImage.layer.cornerRadius = 10
            cell.bannerImage.contentMode = .scaleToFill
            
            switch  foodItemsList?.bannerData?[indexPath.item]{
            case "image1":
                cell.bannerImage.image = UIImage(named: "banner1")
                break
            case "image2":
                cell.bannerImage.image = UIImage(named: "banner2")
                break
            case "image3":
                cell.bannerImage.image = UIImage(named: "banner3")
                break
            case "image4":
                cell.bannerImage.image = UIImage(named: "banner4")
                break
            default:
                break
            }
            
            return cell
        }else {
            return UICollectionViewCell()
        }
    }  
}

