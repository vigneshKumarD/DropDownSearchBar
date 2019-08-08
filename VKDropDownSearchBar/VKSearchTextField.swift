//
//  VKSearchTextField.swift
//  VKDropDownSearchBar
//
//  Created by vignesh on 24/07/2019.
//  Copyright © 2019 VK. All rights reserved.
//

import UIKit


fileprivate let KLeading: CGFloat = 15.0
fileprivate let KTrailing: CGFloat = 30.0

@IBDesignable
class DropDownSearchTextField: UITextField {
  
  fileprivate let searchCellIdentifier = "PASearchFieldTableCellTableViewCell"
  private let kHeight = CGFloat(300)
  private let KCornerRadius = CGFloat(6.0)
  
  private let kTableViewHeight = CGFloat(6.0)
  
  private var tableView: UITableView!
  public var dropDownDelegate: UIDropDownDelegate!
  
  private var shadowView: UIView = UIView.init(frame: CGRect.zero)
  private let searchImage = UIButton.init(frame: CGRect.zero)
  
  private var tableBackgroundColor: UIColor?
  private var tableCornerRadius: CGFloat = 0.0
  private var tableTitleColor: UIColor = .black
  private var tableSubtitleColor: UIColor = .darkGray
  
  private var filteredData: [ResultData] = []
  
  //MARK: Public variables
  public var dataContext: [ResultData]!
  public var isSearchBothAttributes: Bool = false
  
  // SearchField Inspectable components
  @IBInspectable var borderWidth: CGFloat = 2.0 {
    didSet {
      self.layer.borderWidth = borderWidth
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat = 2.0 {
    didSet {
      self.layer.cornerRadius = cornerRadius
    }
  }
  
  @IBInspectable var searchIcon: UIImage = #imageLiteral(resourceName: "searchIcon") {
    didSet {
      self.searchImage.setImage(searchIcon, for: .normal)
    }
  }
  
  @IBInspectable var searchTextColor: UIColor = .black {
    didSet {
      self.textColor = textColor
    }
  }
  
  
  //TableView Inspectable components
  @IBInspectable var listCornerRadius: CGFloat = 1.0 {
    didSet {
      self.tableCornerRadius = listCornerRadius
    }
  }
  
  @IBInspectable var listBackgroundColor: UIColor = .clear {
    didSet {
      self.tableBackgroundColor = listBackgroundColor
    }
  }
  
  @IBInspectable var listTitleColor: UIColor = .black {
    didSet {
      self.tableTitleColor = listTitleColor
    }
  }
  
  @IBInspectable var listSubtitleColor: UIColor = .black {
    didSet {
      self.tableSubtitleColor = listSubtitleColor
    }
  }
  
  
  //MARK: Initialization
  override init(frame: CGRect) {
    super.init(frame:frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
 
  //MARK: Setup
  
  private func setup() {
    self.autocorrectionType = .no
    self.textColor = UIColor.black
    self.delegate = self
    self.font = UIFont.boldSystemFont(ofSize: 18)
    self.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [
      .foregroundColor: UIColor.gray,
      .font: UIFont.boldSystemFont(ofSize: 16)
      ])
    addSearchIcon()
    self.addTarget(self, action: #selector(DropDownSearchTextField.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
  }
  
  
  private func addSearchIcon() {
    searchImage.addTarget(self, action: #selector(searchIconClickAction), for: .touchUpInside)
    self.addSubview(searchImage)
    searchImage.translatesAutoresizingMaskIntoConstraints = false
    
    let trailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: searchImage, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 18)
    let centreY = NSLayoutConstraint(item: searchImage, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
    let widthConstraint = NSLayoutConstraint(item: searchImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 24)
    let heightConstraint = NSLayoutConstraint(item: searchImage, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 24)
    self.addConstraints([trailingConstraint,widthConstraint,heightConstraint,centreY])
  }
  
  @objc func searchIconClickAction() {
    print("Buton clicked ")
  }
}
  

extension DropDownSearchTextField: UITextFieldDelegate {
  // MARK: UITextField Delegate
  @objc func textFieldDidChange(_ textField: UITextField) {
    if let text = textField.text, text.count > 0 {
      showTableView(with: text)
    } else {
      changeKeyboardTypeToDefault()
      hideTableView()
    }
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    hideTableView()
    clearText()
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = textField.text, text.count > 0 {
      endEditing(true)
      return true
    }
    hideTableView()
    endEditing(true)
    clearText()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField.text?.count == 0 {
      changeKeyboardTypeToDefault()
    }
  }
  
  func changeKeyboardTypeToDefault() {
    returnKeyType = .default
    reloadInputViews()
  }
  
}


extension DropDownSearchTextField {
  
  //MARK: UITextField properties
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
  }

  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
  }
}

extension DropDownSearchTextField {
  
private func setupTableView() {
  
  let textField = super.frame
  
  tableView = UITableView.init(frame: CGRect.init(x: textField.origin.x, y: textField.origin.y+textField.size.height+5, width: textField.size.width, height: 300))
  tableView.delegate = self
  tableView.dataSource = self
  let bundle = Bundle(for: self.classForCoder)
  tableView.register(UINib(nibName: searchCellIdentifier, bundle: bundle), forCellReuseIdentifier: searchCellIdentifier)
  guard let window = UIApplication.shared.keyWindow else { return }
  let frame = tableView.frame
  let newFrame = window.convert(frame, from: self.superview!)
  tableView.clipsToBounds = true
  tableView.layer.masksToBounds = true
  tableView.separatorStyle = .none
  tableView.bounces = false
  tableView.rowHeight = UITableView.automaticDimension
  tableView.estimatedRowHeight = UITableView.automaticDimension
  tableView.reloadSections([0], with: .fade)
  tableView.layer.cornerRadius = tableCornerRadius
  tableView.backgroundColor = tableBackgroundColor
  tableView.frame.size.height = tableView.contentSize.height  > kHeight ? kHeight : tableView.contentSize.height
  shadowView = createShadowView()
  shadowView.frame = newFrame
  tableView.frame = CGRect.init(x: 0, y: 0, width: shadowView.frame.size.width, height: shadowView.frame.size.height - (2*kTableViewHeight))
  shadowView.alpha = 0.0
  shadowView.addSubview(tableView)
  window.addSubview(shadowView)
  UIView.animate(withDuration: 0.4) {
    self.shadowView.alpha = 1.0
  }
}

private func createShadowView() -> UIView {
  let shadowView = UIView.init(frame: CGRect.zero)
  shadowView.backgroundColor = UIColor.clear
  shadowView.clipsToBounds = false
  shadowView.layer.masksToBounds = false
  shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
  shadowView.layer.shadowColor = UIColor(red:0.2, green:0.2, blue:0.36, alpha:0.1).cgColor
  shadowView.layer.shadowOpacity = 1
  shadowView.layer.shadowRadius = 12.0
  return shadowView
}

private func hideTableView() {
  guard let _ = tableView else { return }
  UIView.animate(withDuration: 0.4, animations: {
    self.shadowView.alpha = 0.0
  }) { (value) in
    self.shadowView.removeFromSuperview()
  }
  tableView = nil
}
  
  private func showTableView(with searchText: String) {
    if tableView == nil {
      setupTableView()
      returnKeyType = .search
      reloadInputViews()
    } else {
      searchTextOnAttribute(with: searchText)
      tableView.reloadSections([0], with: .fade)
      tableView.layoutSubviews()
      tableView.frame.size.height = tableView.contentSize.height  > kHeight ? kHeight : tableView.contentSize.height
      shadowView.frame.size.height = tableView.frame.size.height - (2*KCornerRadius)
    }
  }
  
  private func clearText() {
    self.text = nil
  }
  
  private func searchTextOnAttribute(with searchText: String) {
    var filteredResult: [ResultData]!
    if isSearchBothAttributes {
      filteredResult = dataContext.filter({$0.resultantText.lowercased().contains(searchText.lowercased())})
    } else {
      filteredResult = dataContext.filter({ $0.title.lowercased().contains(searchText.lowercased())})
    }
    filteredData = searchText.isEmpty ? dataContext : filteredResult
  }
  
}

//MARK: UITableView Delegates

extension DropDownSearchTextField: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: searchCellIdentifier) as! PASearchFieldTableCellTableViewCell
    let result = filteredData[indexPath.row]
    cell.titleLabel.text = result.title // "Title: Hola Amigo"
    cell.descriptionLabel.text = result.subTitle //"Description: 
  
    cell.titleLabel.textColor = self.listTitleColor
    cell.descriptionLabel.textColor = self.tableSubtitleColor
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let selectedObject = filteredData[indexPath.row]
      dropDownDelegate.dropDownDidSelectHandler(selectedObject)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
}
