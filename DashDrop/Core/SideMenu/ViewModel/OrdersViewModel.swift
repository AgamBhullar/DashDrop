//
//  OrdersViewModel.swift
//  DashDrop
//
//  Created by Harpreet Basota on 3/12/24.
//

import SwiftUI
import Firebase

class OrdersViewModel: ObservableObject {
    @Published var completedOrders: [Order] = []
    @Published var selectedReceipt: Receipt? = nil

    private var db = Firestore.firestore()

    // Assuming `currentUser` is available and correctly set
    func fetchCompletedOrders(forUser user: User) {
        let completedField = user.accountType == .customer ? "isCompletedForCustomer" : "isCompletedForDriver"
        var query = db.collection("orders")
                        .whereField(completedField, isEqualTo: true)

        if user.accountType == .customer {
            query = query.whereField("customerUid", isEqualTo: user.uid)
        } else {
            query = query.whereField("driverUid", isEqualTo: user.uid)
        }

        query.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching completed orders: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.completedOrders = documents.compactMap { document -> Order? in
                try? document.data(as: Order.self)
            }
        }
    }


    func fetchReceipt(forOrder orderId: String) {
        Firestore.firestore().collection("receipts").document(orderId)
            .getDocument { documentSnapshot, error in
                guard let snapshot = documentSnapshot, snapshot.exists, let receipt = try? snapshot.data(as: Receipt.self) else {
                    print("Error fetching receipt: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                DispatchQueue.main.async {
                    self.selectedReceipt = receipt
                }
            }
    }
}


