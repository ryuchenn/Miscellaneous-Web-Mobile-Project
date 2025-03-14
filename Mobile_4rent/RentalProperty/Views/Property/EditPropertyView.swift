//
//  EditPropertyView.swift
//  RentalProperty
//
//  Created by admin on 2025-03-07.
//
//
import SwiftUI
import FirebaseFirestore
import CoreLocation

struct EditPropertyView: View {
    var action: UserAction
    var property: Property?
    
    init(action: UserAction, property: Property? = nil) {
        self.action = action
        self.property = (action == .Create) ? Property.initValue : (property ?? Property.initValue)
    }
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var accountController: AccountController
    @EnvironmentObject var propertyController: PropertyController
    
    @State private var isMandatoryExpanded = true
    @State private var isOptionalExpanded = false
    
    // Required
    @State private var address1 = ""
    @State private var address2 = ""
    @State private var city = ""
    @State private var province = ""
    @State private var country = ""
    @State private var postalCode = ""
    @State private var startDate = Date()
    @State private var minRentMonth = 1
    @State private var price = ""
    @State private var type: RentType = .Rent

    @State private var propertyType: PropertyType = .Apartment
    @State private var bedroom = 1
    @State private var den = 0
    @State private var bathroom = 1
    @State private var parking = 0
    @State private var sqft = ""
    
    // Optional
    @State private var pictureURLs: [String] = []
    @State private var newPictureURL: String = ""
    @State private var communityName = ""
    @State private var description = ""
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var area = ""
    @State private var amenities: Set<String> = []
    @State private var exposure = ""
    @State private var included: Set<String> = []
    @State private var prohibited: Set<String> = []
    @State private var gender = "None"
    
    @State private var createAt: Date = Date()
    @State private var contactID: String = ""

    @StateObject private var isLoading: useToggle = useToggle()
    @StateObject private var alert = useAlert()
        
    private let geocoder = CLGeocoder()
    
    func notLoggedInView() -> some View {
        LoginRequiredView().environmentObject(accountController)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if accountController.isLoggedIn() {
                    Form {
                        Section("Property Address") {
                            List {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Address")
    
                                    TextField("Required", text: $address1)
                                }
    
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Unit Number")
    
                                    TextField("Required", text: $address2)
                                }
    
                                Picker("City", selection: $city) {
                                    ForEach(["", "Toronto", "Vancouver", "Montreal", "Calgary"], id: \.self) { city in
                                        Text(city).tag(city)
                                    }
                                }
    
                                Picker("Province", selection: $province) {
                                    ForEach(["", "Ontario", "Quebec", "British Columbia", "Alberta", "Manitoba"], id: \.self) { province in
                                        Text(province).tag(province)
                                    }
                                }
    
                                Picker("Country", selection: $country) {
                                    ForEach(["", "Canada", "United States", "Mexico"], id: \.self) { country in
                                        Text(country).tag(country)
                                    }
                                }
    
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Postal Code")
    
                                    TextField("Required", text: $postalCode)
                                }
                            }
                        }
    
                        Section("Rental Terms & Pricing") {
                            List {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Monthly Rent")
    
                                    TextField("Required", text: $price)
                                        .keyboardType(.decimalPad)
                                }
    
                                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
    
                                Picker("Minimum Rent Month", selection: $minRentMonth) {
                                    ForEach(1...12, id: \.self) { Text("\($0)") }
                                }
    
                                Picker("Type", selection: $type) {
                                    ForEach(RentType.allCases, id: \.self) { rentType in
                                        Text(rentType.rawValue).tag(rentType)
                                    }
                                }
    
                                Picker("Property Type", selection: $propertyType) {
                                    ForEach(PropertyType.allCases, id: \.self) { propertyType in
                                        Text(propertyType.rawValue).tag(propertyType)
                                    }
                                }
                            }
                        }
    
                        Section("Property Size") {
                            List {
                                Stepper("Bedroom: \(bedroom)", value: $bedroom, in: 1...5)
    
                                Stepper("Den: \(den)", value: $den, in: 0...5)
    
                                Stepper("Bathroom: \(bathroom)", value: $bathroom, in: 1...5)
    
                                Stepper("Parking Spaces: \(parking)", value: $parking, in: 0...5)
    
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Total Square Footage")
    
                                    TextField("Required", text: $sqft)
                                        .keyboardType(.decimalPad)
                                }
                            }
                        }
    
                        Section(header: Text("Property Photos")) {
                            ForEach(pictureURLs, id: \.self) { url in
                                HStack {
                                    Text(url)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
    
                                    Spacer()
    
                                    Button(action: { removePicture(url) }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
    
                            HStack {
                                TextField("Enter Picture URL", text: $newPictureURL)
    
                                Button(action: addPicture) {
                                    Image(systemName: "plus.circle.fill")
                                }
                            }
                        }
    
                        Section(header: Text("Additional Details")) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Community Name")
    
                                TextField("Optional", text: $communityName)
                            }
    
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Description")
    
                                TextField("Optional", text: $description)
                            }
    
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Latitude")
    
                                TextField(
                                    "Optional",
                                    text: Binding(
                                        get: { latitude != nil ? String(latitude!) : "" },
                                        set: { latitude = Double($0) }
                                    ))
                                .keyboardType(.decimalPad)
                            }
    
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Longitude")
    
                                TextField(
                                    "Optional",
                                    text: Binding(
                                        get: { longitude != nil ? String(longitude!) : "" },
                                        set: { longitude = Double($0) }
                                    ))
                                .keyboardType(.decimalPad)
                            }
    
                            Picker("Area", selection: $area) {
                                ForEach(areas, id: \.self) { Text($0) }
                            }
    
                            Picker("Exposure", selection: $exposure) {
                                ForEach(exposures, id: \.self) { Text($0) }
                            }
                        }
    
                        Section(header: Text("Prohibited")) {
                            ForEach(prohibitedOptions, id: \.self) { option in
                                Toggle(option, isOn: Binding(
                                    get: { prohibited.contains(option) },
                                    set: { isChecked in
                                        if isChecked { prohibited.insert(option) } else { prohibited.remove(option) }
                                    }
                                ))
                            }
    
                            Picker("Gender Limitation", selection: $gender) {
                                ForEach(genderOptions, id: \.self) { Text($0) }
                            }
                        }
    
                        Section(header: Text("Amenities")) {
                            ForEach(amenitiesOptions, id: \.self) { option in
                                Toggle(option, isOn: Binding(
                                    get: { amenities.contains(option) },
                                    set: { isChecked in
                                        if isChecked { amenities.insert(option) }
                                        else { amenities.remove(option) }
                                    }
                                ))
                            }
                        }
    
                        Section(header: Text("Included")) {
                            ForEach(includedOptions, id: \.self) { option in
                                Toggle(option, isOn: Binding(
                                    get: { included.contains(option) },
                                    set: { isChecked in
                                        if isChecked { included.insert(option) }
                                        else { included.remove(option) }
                                    }
                                ))
                            }
                        }
    
                    }
                    .navigationBarItems(trailing:
                        Button(action: saveProperty) {
                        if isLoading.state {
                                ProgressView()
                            } else {
                                Text(action == .Create ? "Save" : "Update")
                            }
                        }
                        .foregroundStyle(.white)
                        .disabled(isLoading.state)
                    )
//                    .alert(isPresented: $showAlert) {
//                        Alert(
//                            title: Text(alertTitle),
//                            message: Text(alertMsg.joined(separator: "\n")),
//                            dismissButton: .default(Text("OK"))
//                        )
//                    }
                    .onAppear(perform: fetchData)
                    .background(Color("LightGrayColor"))
                } else {
                    notLoggedInView()
                }
            }
            .navigationTitle(action == .Create ? "New Property" : "Edit Property")
            .alert(isPresented: $alert.state) {
                Alert(
                    title: Text(alert.title.rawValue),
                    message: Text(alert.messages.joined(separator: "\n"))
                )
            }
        }
    }
    
    private func fetchData() {
        if action == .Edit, let property = property {
            address1 = property.address1
            address2 = property.address2
            city = property.city
            province = property.province
            country = property.country
            postalCode = property.postalCode
            startDate = property.startDate
            minRentMonth = property.minRentMonth
            price = "\(property.price)"
            type = RentType(rawValue: property.type) ?? .Rent
            propertyType = PropertyType(rawValue: property.propertyType) ?? .Apartment
            bedroom = property.bedroom
            den = property.den
            bathroom = property.bathroom
            parking = property.parking
            sqft = "\(property.sqft)"
            pictureURLs = property.pictureURL ?? []
            communityName = property.communityName ?? ""
            description = property.description ?? ""
            latitude = property.latitude
            longitude = property.longitude
            area = property.area ?? ""
            amenities = Set(property.amenities ?? [])
            exposure = property.exposure ?? ""
            included = Set(property.included ?? [])
            prohibited = Set(property.prohibited ?? [])
            gender = property.gender ?? "None"
            createAt = property.createAt
            contactID = property.contactID
        }
    }

    private func saveProperty() {
        alert.reset()
        
        for (name, value) in [
            ("Address", self.address1),
            ("City", self.city),
            ("Province", self.province),
            ("Country", self.country),
            ("Postal Code", self.postalCode),
            ("Monthly Rent", self.price),
            ("Total Square Footage", self.sqft)
        ] {
            if let errorMessage = ValidationHelper.check(name: name, value: value) {
                alert.append(errorMessage)
            }
        }
        
        if !alert.messages.isEmpty {
            return alert.show(AlertType.Error)
        }
        
        let fullAddress = "\(address2), \(address1), \(city), \(province), \(country), \(postalCode)"
        
        geocodeAddress(address: fullAddress) { location in
            self.latitude = location?.latitude
            self.longitude = location?.longitude
            
            let newProperty: [String: Any] = [
                "address1": address1,
                "address2": address2,
                "city": city,
                "province": province,
                "country": country,
                "postalCode": postalCode,
                "startDate": startDate,
                "minRentMonth": minRentMonth,
                "price": Double(price) ?? 0.0,
                "type": type.rawValue,
                "propertyType": propertyType.rawValue,
                "bedroom": bedroom,
                "den": den,
                "bathroom": bathroom,
                "parking": parking,
                "sqft": Double(sqft) ?? 0.0,
                "pictureURL": pictureURLs,
                "communityName": communityName.isEmpty ? address1 : communityName,
                "description": description,
                "latitude": self.latitude ?? NSNull(),
                "longitude": self.longitude ?? NSNull(),
                "area": area,
                "amenities": Array(amenities),
                "exposure": exposure,
                "included": Array(included),
                "prohibited": Array(prohibited),
                "gender": gender,
                "contactID": (action == .Create) ? accountController.user?.uid : contactID, // Landlord, Agent, etc.
                "createAt": (action == .Create) ? FieldValue.serverTimestamp() : createAt,
                "logUser": accountController.user?.uid,
                "logDate": Date(),
            ]
            
            let completionHandler: (Result<Void, Error>) -> Void = { result in
                isLoading.off()
                switch result {
                    case .success:
                        let action = action == .Delete ? "deleted" : action == .Create ? "added" : "updated"
                        resetField()
                        alert.append("Your property has been successfully \(action).")
                        alert.show(AlertType.Success)
                        dismiss()
                    case .failure(let error):
                        let action = action == .Delete ? "delete" : action == .Create ? "add" : "update"
                        alert.append("Failed to \(action) property: \(error.localizedDescription)")
                        alert.show(AlertType.Error)
                }
            }
            
            let propertyID = property?.id ?? ""
            isLoading.on()
            
            switch action {
                case .Create:
                    propertyController.addProperty(propertyData: newProperty, completion: completionHandler)
                case .Edit:
                    propertyController.updateProperty(propertyID: propertyID, propertyData: newProperty, completion: completionHandler)
                case .Delete:
                    propertyController.deleteProperty(propertyID: propertyID, completion: completionHandler)
                case .Fetch:
                    return
                case .None:
                    return
             }
        }
    }
    
    private func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let location = placemarks?.first?.location?.coordinate {
                print("Geocoded location: \(location.latitude), \(location.longitude)")
                completion(location)
            } else {
                print("No valid location found")
                completion(nil)
            }
        }
    }
    
    private func resetField(){
        if action == .Create{
            // Required
            address1 = ""
            address2 = ""
            city = ""
            province = ""
            country = ""
            postalCode = ""
            price = ""
            startDate = Date()
            minRentMonth = 1
            type = .Rent
            propertyType = .Apartment
            bedroom = 1
            den = 0
            bathroom = 1
            parking = 0
            sqft = ""
            
            // Optional
            pictureURLs.removeAll()
            newPictureURL = ""
            communityName = ""
            description = ""
            latitude = nil
            longitude = nil
            amenities.removeAll()
            area = ""
            exposure = ""
            gender = "None"
            included.removeAll()
            prohibited.removeAll()
        }
        alert.reset()
    }
    
    private func addPicture() {
        guard !newPictureURL.isEmpty else { return }
        pictureURLs.append(newPictureURL)
        newPictureURL = ""
    }
    
    private func removePicture(_ url: String) {
        pictureURLs.removeAll { $0 == url }
    }
}

#Preview {
    var selectedTab: Int = 0
    
    EditPropertyView(action: .Create)
        .environmentObject(AccountController.getInstance())
        .environmentObject(PropertyController.getInstance())
        .environmentObject(FavoriteController.getInstance())
}
