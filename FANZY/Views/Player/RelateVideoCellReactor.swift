//
//  RelateVideoCellReactor.swift
//  FANZY
//
//  Created by 김연준 on 21/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class RelateVideoCellReactor: Reactor {
  typealias Action = NoAction
  
  let initialState: Video
  
  init(video: Video) {
    self.initialState = video
  }
}
