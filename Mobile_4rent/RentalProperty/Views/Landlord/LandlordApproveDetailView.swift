//
//  LandlordApproveDetailView.swift
//  RentalProperty
//
//  Created by admin on 2025-03-09.
//
//
import SwiftUI

struct LandlordApproveDetailView: View {
    let requestDetail: TenantRequestDetail

    @State private var propertyAddress = "Loading..."
    @State private var landlordName = "N/A"
    @State private var landlordPhone = "N/A"

    @EnvironmentObject var accountController: AccountController

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Property Section
                sectionView(icon: "house.fill", title: "Property Address") {
                    Text(propertyAddress)
                        .font(.body)
                        .foregroundColor(.gray)
                        .underline()
                        .padding(.bottom, 10)
                }
                
                // Status Section
                sectionView(icon: statusIcon(for: requestDetail.request.Status),
                            title: "Status",
                            color: statusColor(for: requestDetail.request.Status)) {
                    Text(requestDetail.request.Status.rawValue.capitalized)
                        .font(.headline)
                        .foregroundColor(statusColor(for: requestDetail.request.Status))
                        .padding(.bottom, 10)
                        .underline()
                }
                
                // Appointment Section
                sectionView(icon: "calendar", title: "Appointment Date", color: .orange) {
                    if let date = requestDetail.request.AppointmentDate {
                        Text(date.formatted(date: .long, time: .shortened))
                            .font(.body)
                            .foregroundColor(.gray)
                            .underline()
                    } else {
                        Text("No Appointment Date Set")
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                            .underline()
                    }
                }

                // Landlord Contact Section
                sectionView(icon: "person.fill", title: "Landlord Contact", color: .purple) {
                    VStack(alignment: .leading, spacing: 8) {
                        contactInfo(icon: "person.crop.circle", label: "Name", value: landlordName)
                        contactInfo(icon: "phone.fill", label: "Phone", value: landlordPhone)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Request Details")
        .onAppear(perform: fetchLandlordInfo)
        .background(Color(.systemGroupedBackground))
    }

    private func sectionView(icon: String, title: String, color: Color = .blue, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color("TealBlueColor"))
                Text(title)
                    .font(.title3)
                    .bold()
            }
            .padding(.bottom, 4)

            content()
                .font(.body)

        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }

    private func contactInfo(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 8){
//            Image(systemName: icon)
//                .foregroundColor(Color("TealBlueColor"))
            VStack(alignment: .leading, spacing: 2) {
                Text("\(label):")
                    .bold()

                Text(value)
                    .font(.body)
                    .foregroundColor(.gray)
                    .underline()
            }
        }
        .padding(.bottom, 10)
    }

    private func fetchLandlordInfo() {
        if let property = requestDetail.property {
            propertyAddress = "\(property.address2) - \(property.address1), \(property.city), \(property.province), \(property.country)"
        } else {
            propertyAddress = "Address not found"
        }

        if let landlord = requestDetail.landlord {
            landlordName = landlord.displayName
            landlordPhone = landlord.phoneNumber
        }
    }

    private func statusIcon(for status: RequestStatus) -> String {
        switch status {
        case .pending: return "clock.fill"
        case .approved: return "checkmark.circle.fill"
        case .rejected: return "xmark.circle.fill"
        }
    }

    private func statusColor(for status: RequestStatus) -> Color {
        switch status {
        case .pending: return .orange
        case .approved: return .green
        case .rejected: return .red
        }
    }
}

