//
//  FavMovie+CoreDataProperties.swift
//  MovieDBApp
//
//  Created by Faiq on 1.02.2021.
//  Copyright © 2021 Faig Garazade. All rights reserved.
//
//

import Foundation
import CoreData


extension FavMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavMovie> {
        return NSFetchRequest<FavMovie>(entityName: "FavMovie")
    }

    @NSManaged public var db_id: Int64

}

extension FavMovie : Identifiable {

}
