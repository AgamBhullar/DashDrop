//
//  OrdersView.swift
//  DashDrop
//
//  Created by Harpreet Basota on 3/12/24.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var viewModel: OrdersViewModel // This view model will handle fetching orders from Firestore
    let order: Order

    var body: some View {
        Text("Order Details")
                    .font(.largeTitle) // Customize as needed
                    .bold()
                    .padding()
        Section(order.dropoffLocationName) {
            List(viewModel.orders) { order in
                VStack(alignment: .leading, spacing: 10) {
//                    Text(order.dropoffLocationName)
//                        .font(.headline)
//                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Divider()
                    Text("Order #: \(order.orderId ?? "")")
                    Text("Customer Name: \(order.customerName)")
                    Text("Driver Name: \(order.driverName)")
                    Text("Order Status: \(order.state)")
                    Button{
                        order.receiptImageUrl
                    } label: {
                        Text("View receipt")
                    }
                    
                    
                    // Add more details as needed
                }
                
                
            }
        }
        .onAppear {
            viewModel.fetchOrders()
        }
    }
}

//import SwiftUI
//
//struct OrdersView: View {
//    @ObservedObject var viewModel: OrdersViewModel // This view model will handle fetching orders from Firestore
//
//    var body: some View {
//        VStack {
//            Text("Order Details")
//                .font(.largeTitle) // Customize as needed
//                .bold()
//                .padding()
//
//            List(viewModel.orders) { order in
//                VStack(alignment: .leading, spacing: 10) {
//                    Text(order.dropoffLocationName)
//                        .font(.headline)
//                        .fontWeight(.bold)
//                    Divider()
//
//                    // Now using HStack to separate label from value
//                    HStack {
//                        Text("Order #:").bold()
//                        Spacer()
//                        Text(order.orderId ?? "")
//                    }
//                    HStack {
//                        Text("Customer Name:").bold()
//                        Spacer()
//                        Text(order.customerName)
//                    }
//                    HStack {
//                        Text("Driver Name:").bold()
//                        Spacer()
//                        Text(order.driverName)
//                    }
//                    HStack {
//                        Text("Order Status:").bold()
//                        Spacer()
//                        Text(order.state.description) // Make sure OrderState conforms to CustomStringConvertible
//                    }
//                    Button(action: {
//                        // Action for button
//                    }) {
//                        Text("View Receipt")
//                    }
//                }
//                .padding()
//                Divider().background(Color.gray) // Optional: Make divider more noticeable
//            }
//            .onAppear {
//                viewModel.fetchOrders()
//            }
//        }
//    }
//}












//import SwiftUI
//import FirebaseFirestoreSwift
//import Firebase
//
//struct OrderRowView: View {
//    var order: Order
//
//    enum OrderState: Int, Codable, CustomStringConvertible {
//        case requested = 0
//        case rejected
//        case accepted
//        case delivered
//
//        var description: String {
//            switch self {
//            case .requested: return "Requested"
//            case .rejected: return "Rejected"
//            case .accepted: return "Accepted"
//            case .delivered: return "Delivered"
//            }
//        }
//    }
//
//    
////    enum OrderState: CustomStringConvertible {
////        case requested, accepted
////        // other cases
////
////        var description: String {
////            switch self {
////            case .requested: return "Requested"
////            case .accepted: return "Accepted"
////            // handle other cases
////            }
////        }
////    }
//
//    // Use .description to get the custom string representation
//    //informationBox(title: "Order Status: ", value: order.state.description)
//
//    
//    struct CustomDivider: View {
//        var color: Color = .red // Customize the color as needed
//        var thickness: CGFloat = 2 // Customize the thickness as needed
//
//        var body: some View {
//            Rectangle()
//                .fill(color)
//                .frame(height: thickness)
//                .edgesIgnoringSafeArea(.horizontal)
//        }
//    }
//
//    var body: some View {
//       
//       // Divider() // Visual separator
//        VStack {
//            
//            
//            // Order Number
//            informationBox(title: "Order #:", value: order.orderId ?? "N/A")
//                
//            
//            // Customer Name
//            informationBox(title: "Customer Name:", value: order.customerName)
//            
//            informationBox(title: "Driver Name:", value: order.driverName)
//            
//            // Delivery Address
//            informationBox(title: "Delivery Address:", value: order.dropoffLocationName)
//            
//            // Prepaid Label Option
//            informationBox(title: "Prepaid Label Option:", value: order.selectedLabelOption)
//            
//            informationBox(title: "Customer Receipt: ", value: order.receiptImageUrl ?? "No image URL")
//
//            
//            informationBox(title: "Order Status: ", value: order.state.description)
//
//            //informationBox(title: "Some Integer Title: ", value: String(order.state))
//            //Text("Order Status: \(order.state)")
//        }
//        .padding() // Padding around the entire VStack
//        CustomDivider(color: .black, thickness: 3) // Custom divider
//    }
//    
//    // Function to create a stylized box for each piece of information
//    @ViewBuilder
//    func informationBox(title: String, value: String, backgroundColor: Color = Color.white, titleFont: Font = .headline, valueFont: Font = .body, titleColor: Color = .black, valueColor: Color = .black) -> some View {
//        HStack {
//            // title
//            Text("\(title)")
//                .bold()
//                .lineLimit(2)
//            Spacer()
//            Text(value)
//                .foregroundColor(.black)
//                .bold()
//                .lineLimit(4)
//        }
//        // for each box
//        .padding()
//        //.background(Color.red.opacity(0.3)) // Change background color as needed
//        .frame(minWidth: 0, maxWidth: .infinity)
//        .cornerRadius(8)
//        .shadow(radius: 2) // Optional: adds slight shadow for depth
//        .padding(.horizontal, -10)
//        .padding(.bottom, 7)
//    }
//}
//
//
//struct OrdersView: View {
//    @ObservedObject var viewModel: OrdersViewModel
//
//    var body: some View {
//        Text("Order Details")
//            .font(.largeTitle) // Customize as needed
//            .bold()
//            .padding()
//        List(viewModel.orders) { order in
//            OrderRowView(order: order)
//                // Optionally add modifiers or actions specific to the row
//        }
//        .onAppear {
//            viewModel.fetchOrders()
//        }
//    }
//}


//struct OrdersView_Previews: PreviewProvider {
//    static var previews: some View {
//        //OrdersView(viewModel: MockOrdersViewModel())
//        OrdersView(viewModel: OrdersViewModel(order: order))
//    }
//}
