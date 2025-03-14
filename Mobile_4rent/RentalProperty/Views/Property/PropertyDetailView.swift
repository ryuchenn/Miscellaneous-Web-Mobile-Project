//
//  PropertyDetailView.swift
//  RentalProperty
//
//  Created by admin on 2025-03-07.
//

import SwiftUI

struct PropertyDetailView: View {
    @EnvironmentObject var accountController: AccountController
    @EnvironmentObject var requestController: RequestController
    @EnvironmentObject var favoriteController: FavoriteController
    
    let property: Property
    @State private var isLiked: Bool = false
    @State private var hasRequested = false
    @State private var showUpdateView = false
    @State private var errorMsg: [String] = []
    
    @State private var navigateToMapView = false
    @State private var landlordName: String?
    @State private var landlordPhone: String?
    @State private var showContactAlert = false
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false)  {
                VStack {
                    if let pictures = property.pictureURL, !pictures.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(pictures, id: \.self) { url in
                                    AsyncImage(url: URL(string: url)) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 250, height: 250)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .padding(.top, 5)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                VStack{
                    Spacer()
                    
                    HStack {
                        VStack(spacing: 15) {
                            VStack(spacing: 3) {
                                Text("\(property.address2) - \(property.address1)")
                                    .font(.title3)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                
                                Text("\(property.city), \(property.province), \(property.postalCode)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack(spacing: 6) {
                                    HStack {
                                        Image(systemName: "bed.double.fill")
                                            .font(.system(size: 12))
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(Color("DarkBlueColor"))
                                        
                                        Text(IntegerFormatter(Double(property.bedroom)))
                                            .font(.system(size: 13))
                                    }
                                    
                                    HStack {
                                        Image(systemName: "shower.fill")
                                            .font(.system(size: 14))
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(Color("DarkBlueColor"))
                                        
                                        Text(IntegerFormatter(Double(property.bathroom)))
                                            .font(.system(size: 13))
                                    }
                                    
                                    HStack {
                                        Image(systemName: "car.fill")
                                            .font(.system(size: 14))
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(Color("DarkBlueColor"))
                                        
                                        Text(IntegerFormatter(Double(property.parking)))
                                            .font(.system(size: 13))
                                    }
                                    
                                    Text("| \(String(format: "%.2f", property.sqft)) sqft")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                VStack(spacing: 15){
                                    Text("$\(String(format: "%.2f", property.price)) CAD")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color("OrangeColor"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding(.bottom, 20)
                                
                                HStack {
                                    if property.contactID == accountController.user?.uid {
                                        Button(action: {
                                            showUpdateView = true
                                        }) {
                                            HStack {
                                                VStack(spacing: 4) {
                                                    Image(systemName: "square.and.pencil")
                                                        .imageScale(.small)
                                                    Text("Update")
                                                        .font(.system(size: 12))
                                                }
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .background(Color("TealBlueColor"))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 6)
                                    } else {
                                        HStack(spacing: 12) {
                                            // Request Button
                                            Button(action: {
                                                if hasRequested {
                                                    requestController.cancelRequest(property: property.id ?? "", tenantID: accountController.user?.uid ?? "") { success in
                                                        if success { hasRequested = false }
                                                    }
                                                } else {
                                                    requestController.sendRequest(property: property, tenantID: accountController.user?.uid ?? "") { success in
                                                        if success { hasRequested = true }
                                                    }
                                                }
                                            }) {
                                                VStack(spacing: 4) {
                                                    Image(systemName: hasRequested ? "xmark.circle.fill" : "paperplane")
                                                        .imageScale(.small)
                                                        .foregroundColor(.white)
                                                    Text(hasRequested ? "Cancel" : "Request")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 44)
                                            .padding(8)
                                            .background(hasRequested ? Color.red : Color("TealBlueColor"))
                                            .cornerRadius(8)
                                            .disabled(accountController.isLoggedIn() == false) // Like

                                            // Map Button
                                            Button(action: {
                                                if property.latitude != nil && property.longitude != nil {
                                                    navigateToMapView = true
                                                }
                                            }) {
                                                VStack(spacing: 4) {
                                                    Image(systemName: "map.fill")
                                                        .imageScale(.small)
                                                        .foregroundColor(.white)
                                                    Text("Map")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 44)
                                            .padding(8)
                                            .background(property.latitude != nil && property.longitude != nil ? Color("TealBlueColor") : Color.gray)
                                            .cornerRadius(8)
                                            .disabled(property.latitude == nil || property.longitude == nil)

                                            // Contact Button
                                            Button(action: {
                                                fetchLandlordContact()
                                            }) {
                                                VStack(spacing: 4) {
                                                    Image(systemName: "phone.fill")
                                                        .imageScale(.small)
                                                        .foregroundColor(.white)
                                                    Text("Contact")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 44)
                                            .padding(8)
                                            .background(Color("TealBlueColor"))
                                            .cornerRadius(8)
                                        }
                                        .frame(maxWidth: .infinity)

                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 15)
                                
                                NavigationLink(
                                    destination: MapView(navigateProperty: property)
                                    .environmentObject(PropertyController.getInstance()),
                                    isActive: $navigateToMapView
                                ) {
                                    EmptyView()
                                }
                                .hidden()
                                .frame(width: 0, height: 0)
                                
                                Divider()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("TealBlueHoverColor"))
                            }
                            .padding()
                            
                            Spacer()
                                .frame(height: 1)
                                .background(Color.gray.opacity(0.3))
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color("TealBlueColor"))

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Start Date")
                                            .font(.headline)

                                        Text(property.startDate.formatted(date: .abbreviated, time: .omitted))
                                            .font(.body)
                                            .foregroundColor(.gray)
                                            .underline()
                                    }
                                }
                                .padding(.bottom, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)

                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "clock")
                                        .foregroundColor(Color("TealBlueColor"))

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Min Rent Month")
                                            .font(.headline)

                                        Text("\(property.minRentMonth) months")
                                            .font(.body)
                                            .foregroundColor(.gray)
                                            .underline()
                                    }
                                }
                                .padding(.bottom, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if let prohibitedItems = property.prohibited, !prohibitedItems.isEmpty {
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "nosign")
                                            .foregroundColor(Color("TealBlueColor"))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Prohibited")
                                                .font(.headline)
                                            Text(prohibitedItems.joined(separator: ", "))
                                                .font(.body)
                                                .foregroundColor(.gray)
                                                .underline()
                                        }
                                    }
                                    .padding(.bottom, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                if let genderLimit = property.gender, genderLimit != "None" {
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(Color("TealBlueColor"))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Gender Limitation")
                                                .font(.headline)

                                            Text(genderLimit)
                                                .font(.body)
                                                .foregroundColor(.gray)
                                                .underline()
                                        }
                                    }
                                    .padding(.bottom, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                if let amenities = property.amenities, !amenities.isEmpty {
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "building.2.fill")
                                            .foregroundColor(Color("TealBlueColor"))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Amenities")
                                                .font(.headline)
                                            Text(amenities.joined(separator: ", "))
                                                .font(.body)
                                                .foregroundColor(.gray)
                                                .underline()
                                        }
                                    }
                                    .padding(.bottom, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                if let includedItems = property.included, !includedItems.isEmpty {
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "shippingbox.fill")
                                            .foregroundColor(Color("TealBlueColor"))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Included")
                                                .font(.headline)
                                            Text(includedItems.joined(separator: ", "))
                                                .font(.body)
                                                .foregroundColor(.gray)
                                                .underline()
                                        }
                                    }
                                    .padding(.bottom, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "sun.max.fill")
                                        .foregroundColor(Color("TealBlueColor"))

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Exposure")
                                            .font(.headline)

                                        Text(property.exposure?.isEmpty == false ? property.exposure! : "N/A")
                                            .font(.body)
                                            .foregroundColor(.gray)
                                            .underline()
                                    }
                                }
                                .padding(.bottom, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)

                                if let description = property.description, !description.isEmpty {
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "text.bubble")
                                            .foregroundColor(Color("TealBlueColor"))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Description")
                                                .font(.headline)

                                            Text(description)
                                                .font(.body)
                                                .foregroundColor(.gray)
                                                .underline()
                                        }
                                    }
                                    .padding(.bottom, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal)

                        }
                        .padding(.bottom, 30)
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width, alignment: .top)
            }
        }
        .navigationBarItems(trailing:
                                HStack(spacing: 3) {
            Button(action: {
                if let userID = accountController.user?.uid {
                    favoriteController.toggle(userID: userID, propertyID: self.property.id ?? "") { Like in
                        print("toggle: \(Like)")
                    }
                    isLiked.toggle()
                }
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(isLiked ? .red.opacity(0.8) : .secondary)
                    .padding(12)
                    .background(.white.opacity(0.88))
                    .clipShape(Circle())
                    .frame(width: 42, height: 42)
            }
            .disabled(accountController.isLoggedIn() == false) // Like
            
            ShareLink(
                items: [
                    "I would like to share this house with you! ",
                    "https://www.4rent.com/sharelink/\(property.id ?? "")"
                ]
            ) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.black)
                    .padding(12)
                    .background(.white.opacity(0.88))
                    .clipShape(Circle())
                    .frame(width: 42, height: 42)
            }
        }
        )
        .navigationDestination(isPresented: $showUpdateView) {
            EditPropertyView(action: .Edit, property: property)
        }
        .onAppear {
            fetchData()
            isLiked = favoriteController.favoriteIDs.contains(property.id ?? "")
        }
        .sheet(isPresented: Binding(
            get: { showContactAlert && landlordName != nil && landlordPhone != nil },
            set: { newValue in
                if !newValue {
                    showContactAlert = false
                }
            }
        )) {
            if let name = landlordName, let phone = landlordPhone {
                VStack(spacing: 20) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color("TealBlueColor"))

                    Text("Contact")
                        .font(.title2)
                        .bold()

                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(Color("TealBlueColor"))

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Name")
                                .font(.headline)
                            Text(name)
                                .font(.body)
                                .foregroundColor(.gray)
                                .underline()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)

                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(Color("TealBlueColor"))

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Phone")
                                .font(.headline)
                            Text(phone)
                                .font(.body)
                                .foregroundColor(.gray)
                                .underline()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)

                    Button(action: { showContactAlert = false }) {
                        Text("OK")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal)

            } else {
                ProgressView("Loading...")
                    .onAppear {
                        fetchLandlordContact()
                    }
            }
        }


    }
    
    private func fetchData(){
        if let userID = accountController.user?.uid {
            requestController.checkIfRequested(tenantID: userID, propertyID: property.id ?? "") { requested in
                hasRequested = requested
            }
        }
    }
    
    private func fetchLandlordContact() {
        AccountController.getInstance().fetchUserByUID(uid: property.contactID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    if let user2 = user {
                        landlordName = user2.displayName
                        landlordPhone = user2.phoneNumber
                        self.showContactAlert = true
                    } else {
                        self.landlordName = "N/A"
                        self.landlordPhone = "N/A"
                    }
                case .failure(let error):
                    print("Failed to fetch landlord contact: \(error.localizedDescription)")
                    self.landlordName = "N/A"
                    self.landlordPhone = "N/A"
                }
            }
        }
    }
}
