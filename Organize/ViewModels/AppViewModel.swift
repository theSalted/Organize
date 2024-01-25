//
//  AppViewModel.swift
//  Organize
//
//  Created by Yuhao Chen on 1/22/24.
//

import Foundation
import SwiftUI

@Observable
class AppViewModel {
    var tabViewSelection : TabViewTag = .storage
    var spaceListSelections : Set<Space.ID> = []
    var storageListSelections : Set<Storage.ID> = []
    var itemsListSelections : Set<Item.ID> = []
    var detailSelections : Set<AnyHashable> = []
    
//    private var _detailPath : NavigationPath = NavigationPath()
//    var detailPathHistory : [UUID] = []
//    var detailPath : NavigationPath {
//        get { _detailPath }
//        @available(*, deprecated, renamed: "appendDetailPath",
//                    message: "This setter does not record routing history. Please use appendDetailPath or define new APIs and points to _detailPath")
//        set { _detailPath = newValue }
//    }
//    var lastVisitedPathId : UUID? {
//        detailPathHistory.last
//    }
//    func appendDetailPath(_ meta : any Meta) {
//        if meta.id != lastVisitedPathId {
//            self._detailPath.append(meta)
//            detailPathHistory.append(meta.id)
//        }
//    }
    enum TabViewTag : String, CaseIterable {
        case storage, scan
    }
    enum DetailsViewCategory  {
        case space, storage, item
    }
}
