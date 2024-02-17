//
//  AppViewModel.swift
//  Organize
//
//  Created by Yuhao Chen on 1/22/24.
//

import Foundation
import Observation
import SwiftUI

@Observable
class AppViewModel {
    var tabViewSelection:           TabViewTag =        .organize
    
    // MARK: Selection IDs for lists
    private var _spaceListSelectionIDs: Set<Space.ID> = []
    var spaceListSelectionIDs: Set<Space.ID> {
        get { _spaceListSelectionIDs }
        set { 
            _spaceListSelectionIDs = newValue
            withAnimation {
                storageListSelectionsIDs = []
                itemsListSelectionIDs = []
            }
        }
    }
    
    private var _storageListSelectionsIDs: Set<Storage.ID> = []
    var storageListSelectionsIDs: Set<Storage.ID> {
        get { _storageListSelectionsIDs }
        set { 
            _storageListSelectionsIDs = newValue
            withAnimation {
                itemsListSelectionIDs = []
            }
        }
    }
    
    private var _itemsListSelectionIDs: Set<Item.ID> = []
    var itemsListSelectionIDs: Set<Item.ID> {
        get { _itemsListSelectionIDs }
        set { _itemsListSelectionIDs = newValue }
    }
    
    var detailSelections:           Set<AnyHashable> =  []
    
    enum TabViewTag: String, CaseIterable {
        case organize, scan
    }
    enum DetailsViewCategory  {
        case space, storage, item
    }
}
