//
//  HomeViewModel.swift
//  Foody Eatz
//
//  Created by developer on 06/02/21.
//  Copyright © 2021 Ashwini. All rights reserved.
//

import Foundation
import UIKit


class HomeViewModel {
    
    //Original Array from Core Data
    var foodItemsDataArray: FoodItemsList_Base?
    
    //MARK:- readJsonFile
    //to get data from the raw json file
    func readJsonFile() -> FoodItemsList_Base{
        
        if let path = Bundle.main.path(forResource: "FoodDetails", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    let decoder = JSONDecoder()
                    let valueData = try decoder.decode(FoodItemsList_Base.self, from: data)
                    self.foodItemsDataArray = valueData
                   
                } catch {
                    print(error)
                }
            } catch {
                // handle error
            }
        }
        return foodItemsDataArray!
    }
    
}
