//
//  Receipt.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/13/24.
//

import FirebaseFirestoreSwift
import Firebase

struct Receipt: Identifiable, Codable {
    @DocumentID var orderId: String?
    var receiptImageUrl: String?
    
    var id: String {
        return orderId ?? ""
    }
}

