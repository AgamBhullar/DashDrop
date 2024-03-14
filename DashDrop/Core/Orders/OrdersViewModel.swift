//
//  OrdersViewModel.swift
//  DashDrop
//
//  Created by Harpreet Basota on 3/12/24.
//

import SwiftUI
import Firebase

class OrdersViewModel: ObservableObject {  // was ObservableObject
    @Published var orders: [Order] = []
    
    
    func fetchOrders() {
        // Fetch orders for the current user from Firestore
       
        let uid = Auth.auth().currentUser?.uid ?? ""
        Firestore.firestore().collection("orders")
            .whereField("customerUid", isEqualTo: uid)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching orders: \(error)")
                    return
                }
                self.orders = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Order.self)
                } ?? []
            }
    }
}


