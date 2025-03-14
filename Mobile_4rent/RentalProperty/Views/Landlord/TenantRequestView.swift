//
//  TenantRequestView.swift
//  RentalProperty
//
//  Created by admin on 2025-03-09.
//

import SwiftUI

struct TenantRequestView: View {
    @EnvironmentObject var accountController: AccountController
    @EnvironmentObject var requestController: RequestController
    
    @State private var requestsDetail: [TenantRequestDetail] = []
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView("Loading Requests...")
                } else if requestsDetail.isEmpty {
                    Text("No Tenant Requests Found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(requestsDetail, id: \.request.id) { detail in
                        NavigationLink(destination: TenantRequestDetailView(requestDetail: detail)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    // Property Address
                                    HStack {
                                        Image(systemName: "house.fill")
                                            .foregroundColor(Color("TealBlueColor"))
                                        Text("\(detail.property?.address2 ?? "N/A") - \(detail.property?.address1 ?? "N/A")")
                                            .font(.headline)
                                            .bold()
                                    }
                                    
                                    // Community Name
                                    if let community = detail.property?.communityName, !community.isEmpty {
                                        HStack {
                                            Image(systemName: "building.2.fill")
                                                .foregroundColor(Color("TealBlueColor"))
                                            Text(community)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    // Name
                                    if let displayName = detail.tenant?.displayName, !displayName.isEmpty {
                                        HStack {
                                            Image(systemName: "person.fill")
                                                .foregroundColor(Color("TealBlueColor"))
                                            Text("\(displayName)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    // Appointment Date
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(Color("TealBlueColor"))
                                        Text(detail.request.AppointmentDate?.formatted(date: .abbreviated, time: .shortened) ?? "No Appointment Date Set")
                                            .foregroundColor(.gray)
                                            .underline()
                                    }
                                    
                                    // Status
                                    HStack {
                                        Image(systemName: statusIcon(for: detail.request.Status))
                                            .foregroundColor(statusColor(for: detail.request.Status))
                                        Text(" \(detail.request.Status.rawValue.capitalized)")
                                            .font(.headline)
                                            .foregroundColor(statusColor(for: detail.request.Status))
                                            .underline()
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tenant Requests")
            .onAppear(perform: fetchTenantRequests)
        }
    }

    private func fetchTenantRequests() {
        isLoading = true
        
        if let userID = accountController.user?.uid {
            requestController.fetchTenantRequestsWithDetails(landlordID: userID) { fetchedDetails in
                DispatchQueue.main.async {
                    self.requestsDetail = fetchedDetails
                    self.isLoading = false
                }
            }
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
