//
//  GroupInfo+Extensions.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 05.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

extension GroupInfo {
    /** Fetch request fith default sort by order attribute */
    @nonobjc public class func fetchRequestWithSort(
        _ sortDescriptors: [NSSortDescriptor] =
        [NSSortDescriptor(keyPath: \GroupInfo.order, ascending: true)]
    ) -> NSFetchRequest<GroupInfo> {
        let fetchRequest: NSFetchRequest<GroupInfo> = GroupInfo.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest
    }
}
