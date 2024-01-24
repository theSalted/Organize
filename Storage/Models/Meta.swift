//
//  Meta.swift
//  Storage
//
//  Created by Yuhao Chen on 1/24/24.
//

import Foundation

protocol Meta : Identifiable, Hashable where ID == UUID {
    var id : UUID { get set }
    var name : String? { get set }
    var storedIn : String? { get }
    var createdAt : Date? { get set }
}
