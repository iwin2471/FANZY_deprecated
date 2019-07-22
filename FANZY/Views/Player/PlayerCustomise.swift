//
//  PlayerCustomise.swift
//  FANZY
//
//  Created by 김연준 on 16/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import SnapKit
import Then


class tableviewsnp {
  let videoCell: RelateVideoCell
  let mainScreen = UIScreen.main
  let superView: UIView
  
  init(video: RelateVideoCell, view: UIView) {
    self.videoCell = video
    self.superView = view
  }
  
  func videoCellCustomise(){
    videoCell.snp.makeConstraints{ make in
      
    }
  }
}
