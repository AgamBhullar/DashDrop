


//import SwiftUI
//
//struct OrderInformationView: View {
//    @ObservedObject var orderDetails: OrderDetails // Now it is non-optional
//    
//    var orderNumber: String {
//        let randomNumber = Int.random(in: 1000...9999)
//        return "DD\(randomNumber)"
//    }
//    
//    var body: some View {
//        ScrollView {
//            
//            VStack(alignment: .leading, spacing: 20) {
//                
////                Text("Order Information")
////                    .font(.largeTitle)
////                    .foregroundColor(.gray)
////                    .fontWeight(.semibold)
////                    .padding(.vertical)
//                
//                Rectangle()
//                    .fill(Color.black)
//                    .frame(height: 6)
//                    .padding(.horizontal)
//                HStack {
//                        Text("Order Number: ")
//                            .bold()
//                            .foregroundColor(.black) // Title in grey
//                            .font(.system(size: 29))
//                        Text(orderNumber)
//                            .bold()
//                            .foregroundColor(.cyan) // Assuming you have Navy defined or use a different color
//                            .font(.system(size: 29))
//                    }
//                    
//                
//                // Directly use the properties of orderDetails without optional binding
//                Group {
//                    DetailRow(label: "Address", value: orderDetails.fullAddress ?? "Not Available")
//                    DetailRow(label: "Package Type", value: orderDetails.packageType ?? "Not Available")
//                    DetailRow(label: "Store", value: orderDetails.store ?? "Not Available")
//                    DetailRow(label: "Pre-Paid Label", value: orderDetails.prePaidLabelChosen ? "Yes" : "No")
//                    DetailRow(label: "Quantity", value: String(orderDetails.quantity))
//                    
//                    // Check for and safely handle the case where qrCodeImageURL is nil
//                    if let qrCodeURL = orderDetails.qrCodeImageURL, let url = URL(string: qrCodeURL) {
//                        Link("QR Code", destination: url)
//                    }
//                }
//                .padding(.bottom, 5)
//               // .font(.system(size: 25))
//                
//                Rectangle()
//                        .fill(Color.black)
//                        .frame(height: 6)
//                        .padding(.horizontal)
//                
//                Text("Order Status :")
//                    .font(.largeTitle)
//                    .bold()
//                    .foregroundColor(.black)
//                Text("Order Processing....")
//                    .bold()
//                    .padding(.top)
//                    .font(.system(size: 29))
//                    .foregroundColor(.cyan)
//            }
//            .padding()
//        }
//        .navigationTitle("Order Details")
////        .background {
////            Image("Background2")
////                .overlay(Color("CustomColor1").opacity(0.4))
////        }
//    }
//}
//
//// Other structs like DetailRow remain unchanged
//
//struct DetailRow: View {
//    var label: String
//    var value: String
//    
//    var body: some View {
//        HStack {
//            Text("\(label):")
//                //.fontWeight(.bold)
//                .foregroundColor(.black)
//                .font(.system(size: 25))
//            Text(value)
//                .fontWeight(.bold)
//                .foregroundColor(.black)
//                .font(.system(size: 20))
//            Spacer()
//        }
//    }
//}
//
//struct OrderInformationView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Create a sample OrderDetails object for preview purposes
//        let sampleOrderDetails = OrderDetails()
//        // Optionally set some properties for the sample object if needed
//        sampleOrderDetails.fullAddress = "123 Main St"
//        sampleOrderDetails.packageType = "Box"
//        sampleOrderDetails.store = "UPS"
//        sampleOrderDetails.quantity = 1
//        sampleOrderDetails.prePaidLabelChosen = true
//        sampleOrderDetails.qrCodeImageURL = "https://example.com/qr-code"
//        
//        return OrderInformationView(orderDetails: sampleOrderDetails)
//    }
//}

import SwiftUI

struct OrderInformationView: View {
    @ObservedObject var orderDetails: OrderDetails
    
    
    var orderNumber: String {
        let randomNumber = Int.random(in: 1000...9999)
        return "DD\(randomNumber)"
    }
    
    var body: some View {
        
        List {
            
            Section(header: Text("").font(.largeTitle).bold()) {
                HStack {
                    Text("Order Number: ")
                        .bold()
                        .foregroundColor(.gray) // Title in grey
                        .font(.system(size: 22))
                    Spacer()
                    Text(orderNumber)
                        .bold()
                        .foregroundColor(.black) // Value in black
                        .font(.system(size: 22))
                }
                
                DetailRow(label: "Address", value: orderDetails.fullAddress ?? "Not Available")
                DetailRow(label: "Package Type", value: orderDetails.packageType ?? "Not Available")
                DetailRow(label: "Store", value: orderDetails.store ?? "Not Available")
                DetailRow(label: "Pre-Paid Label", value: orderDetails.prePaidLabelChosen ? "Yes" : "No")
                DetailRow(label: "Quantity", value: String(orderDetails.quantity))
                
                if let qrCodeURL = orderDetails.qrCodeImageURL, let url = URL(string: qrCodeURL) {
                    Link("QR Code", destination: url)
                }
            }
            
            Section(header: Text("Order Status").font(.largeTitle).bold().foregroundColor(.black)) {
                HStack {
                    Text("Order Processing...")
                        .bold()
                        .foregroundColor(.cyan) // Status color
                        .font(.system(size: 22))
                    Spacer()
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Order Details")
        //.foregroundColor(.black)
    }
}

struct DetailRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text("\(label):")
                .foregroundColor(.gray) // Label in grey
                .font(.system(size: 20))
                .bold()
            Spacer()
            Text(value)
                .foregroundColor(.black) // Value in black
                .font(.system(size: 20))
        }
    }
}

struct OrderInformationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderInformationView(orderDetails: OrderDetails())
        }
    }
}
