
//
//  searchView.swift
//  FANZY
//
//  Created by 김연준 on 12/06/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ReusableKit
import RxCocoa
import RxSwift

class SearchView: BaseView, UITextFieldDelegate {
  
  struct Reusable {
    static let searchCell = ReusableCell<SearchCell>()
  }
  
  //MARK: Properties
  let headerWrapper = UIView()
  let backButton = UIButton().then {
    $0.setImage(UIImage(named: "back")?.resized(newSize: CGSize(width: 28, height: 28)), for: .normal)
  }
  
  let searchButton = UIButton().then {
    $0.setImage(UIImage(named: "navSearch")?.resized(newSize: CGSize(width: 24, height: 24)), for: .normal)
  }
  
  var inputField = TextField(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 40))
  var tableView = UITableView().then {
    $0.register(Reusable.searchCell)
    $0.backgroundColor = .clear
  }
  var suggestions = [String]()
  
  //MARK: Methods
  
  func hideSearchView() {
    self.inputField.text = ""
    self.suggestions.removeAll()
    self.tableView.isHidden = true
    self.inputField.resignFirstResponder()
    UIView.animate(withDuration: 0.2, animations: {
      self.alpha = 0
    }) { _ in
      self.isHidden = true
    }
  }
  
  override func initialize() {
    super.initialize()
    addSubview(headerWrapper)
    addSubview(tableView)
    headerWrapper.addSubview(backButton)
    headerWrapper.addSubview(inputField)
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    inputField.rightView = view
    view.addSubview(searchButton)
    view.isUserInteractionEnabled = true
    view.left = inputField.left + 18
    
    inputField.rightViewMode = .always
    setEvent()
  }
  
  override func customise() {
    self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    self.backgroundColor = .init(rgb: 0x212121)
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.inputField.delegate = self
    
    self.tableView.isHidden = true
    
    tableView.separatorStyle = .none
    
    self.headerWrapper.then {
      $0.backgroundColor = .init(rgb: 0x282828)
      $0.width = UIScreen.main.bounds.width
      $0.height = 50
    }
    
    self.inputField.then {
      $0.backgroundColor = .init(rgb: 0x171717)
      $0.width = UIScreen.main.bounds.width - 50
      $0.height = 34
      
      $0.attributedPlaceholder = NSAttributedString(string: "검색...",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
      $0.textColor = .white
      $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
      $0.borderStyle = UITextField.BorderStyle.roundedRect
      $0.autocorrectionType = .no
      $0.keyboardType = .default
      $0.returnKeyType = .done
      $0.clearButtonMode = UITextField.ViewMode.whileEditing
      $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
  }
  
  override func setupConstraints() {
    headerWrapper.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(20)
      make.height.equalTo(inputField.height + 20)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
    
    inputField.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(50)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    backButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(10)
    }
    
    searchButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-10)
    }
    
    tableView.snp.makeConstraints { (make) in
      make.top.equalTo(headerWrapper.snp.bottom)
      make.height.equalTo(UIScreen.main.bounds.height - headerWrapper.height)
      make.width.equalTo(self.width)
    }
  }
  
  //MARK: Delegates
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if(inputField.returnKeyType == UIReturnKeyType.go){
      print("test")
    }
    
    searchEvent()
    return true
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = self.inputField.text else {
      self.suggestions.removeAll()
      self.tableView.isHidden = true
      return true
    }
    let netText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet())!
    let url = URL.init(string: "https://api.bing.com/osjson.aspx?query=\(netText)")!
    
    let _  = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
      guard let weakSelf = self else {
        return
      }
      if error == nil {
        if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
          let data = json as! [Any]
          DispatchQueue.main.async {
            weakSelf.suggestions = data[1] as! [String]
            if weakSelf.suggestions.count > 0 {
              weakSelf.tableView.reloadData()
              weakSelf.tableView.isHidden = false
            } else {
              weakSelf.tableView.isHidden = true
            }
          }
        }
      }
    }).resume()
    return true
  }
}

extension SearchView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.suggestions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(Reusable.searchCell, for: indexPath)
    cell.resultLabel.text = self.suggestions[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.inputField.text = self.suggestions[indexPath.row]
    let cell = tableView.cellForRow(at: indexPath)
    cell?.isSelected = false
  }
}

extension SearchView {
  func setEvent(){
    backButton.rx.tap.subscribe(onNext: {
      self.hideSearchView()
    }).disposed(by: self.disposeBag)
  }
  
  func searchEvent() {
    let searchQuery = self.inputField.text!
    var videos = [Video]()
    
    let url = "\(TestFanzyURL)/video/search/api?search_query=\(searchQuery)&page=index&lang=kr"
    let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    Alamofire.request(encodedUrl!).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [[String: Any]] {
          json.map { do { videos.append(try Video(JSON: $0))} catch {} }
          NotificationCenter.default.post(name: Notification.Name.init(rawValue: "reloadVideoListWithArray"), object: videos)
        }
      case .failure(let error):
        print(error)
      }
    }
    
    self.hideSearchView()
  }
}

class SearchCell: BaseTableViewCell {
  var resultLabel = UILabel()
  var resultSearchImg = UIImageView(image: UIImage(named: "navSearch")?.resized(newSize: CGSize(width: 24, height: 24)))
  var resultArrowImg = UIImageView(image: UIImage(named: "arrow_right")?.resized(newSize: CGSize(width: 24, height: 24)))
  
  override func initialize() {
    backgroundColor = .clear
    
    resultLabel.textColor = .white
    resultSearchImg.alpha = 0.5
    resultArrowImg.alpha = 0.5
    
    addSubview(resultLabel)
    addSubview(resultSearchImg)
    addSubview(resultArrowImg)
    super.initialize()
  }
  
  override func customise() {
    resultLabel.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().offset(50)
      make.trailing.equalToSuperview().offset(50)
      make.centerY.equalToSuperview()
    }
    
    resultSearchImg.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().offset(15)
      make.centerY.equalToSuperview()
      make.width.equalTo(26)
      make.height.equalTo(26)
    }
    
    resultArrowImg.snp.makeConstraints { (make) in
      make.trailing.equalToSuperview().offset(-15)
      make.centerY.equalToSuperview()
      make.width.equalTo(26)
      make.height.equalTo(26)
    }
  }
}



