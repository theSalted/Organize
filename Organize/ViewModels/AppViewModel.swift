//
//  AppViewModel.swift
//  Organize
//
//  Created by Yuhao Chen on 1/22/24.
//

import Foundation
import Observation

@Observable
class AppViewModel {
    var tabViewSelection:           TabViewTag =        .storage
    var spaceListSelectionIDs:      Set<Space.ID> =     []
    var storageListSelectionsIDs:   Set<Storage.ID> =   []
    var itemsListSelectionIDs:      Set<Item.ID> =      []
    var detailSelections:           Set<AnyHashable> =  []
    
    enum TabViewTag: String, CaseIterable {
        case storage, scan
    }
    enum DetailsViewCategory  {
        case space, storage, item
    }
    
    // Utilities
    static func getListFromSearchTerm<T: Meta>(
        _ targets: [T],
        searchText: String
    ) -> [T] {
        if searchText.isEmpty {
            return targets
        } else {
            return targets.filter { target in
                target.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
