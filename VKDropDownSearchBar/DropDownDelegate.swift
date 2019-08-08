//
//  DropDownDelegate.swift
//  VKDropDownSearchBar
//
//  Created by vignesh on 25/07/2019.
//  Copyright © 2019 VK. All rights reserved.
//

import Foundation

protocol ResultDataInterface {
  var title: String { get }
  var subTitle: String? { get }
}

struct ResultData: ResultDataInterface {
  var title: String
  var subTitle: String?
  internal var resultantText: String = ""
  
  init(_ title: String, subTitle: String?) {
    self.title = title
    self.subTitle = subTitle
    self.resultantText = "\(title)  \(subTitle ?? "")"
  }
}

protocol UIDropDownDelegate {
  func dataContext() -> [ResultData]
  func dropDownDidSelectHandler(_ selectedContext: ResultData)
}
