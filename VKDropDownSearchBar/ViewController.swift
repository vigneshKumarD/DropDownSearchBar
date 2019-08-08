//
//  ViewController.swift
//  VKDropDownSearchBar
//
//  Created by vignesh on 24/07/2019.
//  Copyright © 2019 VK. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDropDownDelegate {
  
  @IBOutlet private weak var dropDownView: DropDownSearchTextField!
  
  
  var data: [ResultData] = [ResultData("Thor", subTitle: "Carpenter"),
                            ResultData("Captain America", subTitle: "Captain for Avengers"),
                            ResultData("Iron Man", subTitle: "I'm iron man" ),
                            ResultData("Hawk eye", subTitle: "kaa kaai" ),
                            ResultData("Hawk eye", subTitle: "kaa kaai" ),
                            ResultData("Haw", subTitle: "kaak kaai" ),
                            ResultData("kaa kaai", subTitle: "kaa kaai" ),
                            ResultData("Natasha Romanoff", subTitle: "Black widow" )]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dropDownView.dropDownDelegate = self
    dropDownView.dataContext = data
    dropDownView.isSearchBothAttributes = true
  }
  
  //MARK: UIDropdown Delegates
//  func numberOfRowsInDropDown() -> Int {
//    return data.count
//  }
//
//  func dropDownCellForRowAt(_ indexPath: IndexPath) -> ResultData {
//    return data[indexPath.row]
//  }
  
  func dropDownDidSelectHandler(_ selectedContext: ResultData) {
    print(selectedContext)
  }
  
  func dataContext() -> [ResultData] {
    return data
  }
}

