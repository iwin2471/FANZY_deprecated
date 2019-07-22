//
//  MessageInputBar.swift
//  FANZY
//
//  Created by 김연준 on 30/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import UIKit

import CGFloatLiteral
import RxCocoa
import RxSwift
import RxKeyboard
import UITextView_Placeholder

final class MessageInputBar: UIView {
  
  // MARK: Properties
  
  private let disposeBag = DisposeBag()
  let txtDateHasFocused: Bool = false
  
  
  // MARK: UI
  let toolbar = UIToolbar().then {
    $0.backgroundColor = .init(rgb: 0x282828)
  }
  let textView = UITextView().then {
    
    $0.attributedPlaceholder = NSAttributedString(string: "메시지 보내기...",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8)])
    $0.isEditable = true
    $0.showsVerticalScrollIndicator = false
    $0.textColor = .white
    $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    $0.backgroundColor = .init(rgb: 0x282828)
  }
  let sendButton = UIButton(type: .system).then {
    $0.titleLabel?.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
    $0.backgroundColor = .init(rgb: 0x282828)
  }
  let sendImg = UIImageView(image: UIImage(named: "send")?.resized(newSize: CGSize(width: 25, height: 25)))
  
  
  // MARK: Initializing
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.toolbar)
    self.addSubview(self.textView)
    self.addSubview(self.sendButton)
    sendButton.addSubview(self.sendImg)
    
    self.toolbar.snp.makeConstraints { make in
      make.edges.equalTo(0)
    }
    
    self.textView.snp.makeConstraints { make in
      make.top.left.equalToSuperview()
      make.right.equalTo(self.sendButton.snp.left)
      make.bottom.equalToSuperview()
    }
    
    self.sendButton.snp.makeConstraints { make in
      make.width.equalTo(50)
      make.top.bottom.trailing.equalToSuperview()
    }
    
    self.sendImg.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    self.textView.rx.text
      .map { text in text?.isEmpty == false }
      .bind(to: self.sendButton.rx.isEnabled)
      .disposed(by: self.disposeBag)
    
    RxKeyboard.instance.visibleHeight
      .map { $0 > 0 }
      .distinctUntilChanged()
      .drive(onNext: { [weak self] (visible) in
        guard let `self` = self else {
          return
        }

        var bottomInset = 0.f
        bottomInset = self.bottom
        
        self.toolbar.snp.remakeConstraints({ (make) in
          make.left.right.top.equalTo(0)
          make.bottom.equalTo(bottomInset)
        })
      })
      .disposed(by: self.disposeBag)
  }
  
  
  override func safeAreaInsetsDidChange() {
    super.safeAreaInsetsDidChange()
    guard let bottomInset = self.superview?.safeAreaInsets.bottom else {
      return
    }
    
    self.toolbar.snp.remakeConstraints { make in
      make.top.left.right.equalTo(0)
      make.bottom.equalTo(bottomInset)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: Size
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.width, height: 44)
  }
  
}


// MARK: - Reactive

extension Reactive where Base: MessageInputBar {
  
  var sendButtonTap: ControlEvent<String> {
    let source: Observable<String> = self.base.sendButton.rx.tap
      .withLatestFrom(self.base.textView.rx.text.asObservable())
      .flatMap { text -> Observable<String> in
        if let text = text, !text.isEmpty {
          return .just(text)
        } else {
          return .empty()
        }
      }
      .do(onNext: { [weak base = self.base] _ in
        base?.textView.text = nil
      })
    return ControlEvent(events: source)
  }
  
}

