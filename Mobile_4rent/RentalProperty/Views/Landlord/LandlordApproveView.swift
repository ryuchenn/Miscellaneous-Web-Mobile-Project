//
//  LandlordApproveView.swift
//  RentalProperty
//
//  Created by admin on 2025-03-09.
//
//

import SwiftUI

struct LandlordApproveView: View {
    @EnvironmentObject var requestController: RequestController
    @EnvironmentObject var accountController: AccountController
    @EnvironmentObject var propertyController: PropertyController
    @EnvironmentObject var favoriteController: FavoriteController
    
    @State private var requestsDetail: [TenantRequestDetail] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                } else if !requestsDetail.isEmpty {
                    List(requestsDetail) { detail in
                        NavigationLink(destination: LandlordApproveDetailView(requestDetail: detail)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Image(systemName: "house.fill")
                                            .foregroundColor(Color("TealBlueColor"))
                                        Text("\(detail.property?.address2 ?? "N/A") - \(detail.property?.address1 ?? "N/A")")
                                            .font(.headline)
                                            .bold()
                                    }
                                    
                                    if let communityName = detail.property?.communityName, !communityName.isEmpty {
                                        HStack {
                                            Image(systemName: "building.2.fill")
                                                .foregroundColor(Color("TealBlueColor"))
                                            Text(communityName)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }

                                    if let date = detail.request.AppointmentDate {
                                        HStack {
                                            Image(systemName: "calendar")
                                                .foregroundColor(Color("TealBlueColor"))
                                            Text("\(date.formatted(date: .long, time: .shortened))")
                                                .font(.subheadline)
                                                .underline()
                                                .foregroundColor(.gray)
                                        }
                                    } else {
                                        HStack {
                                            Image(systemName: "calendar.badge.exclamationmark")
                                                .foregroundColor(Color("TealBlueColor"))
                                            Text("No Appointment Date Set")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .underline()
                                        }
                                    }
                                    
                                    // Status Display with Icon
                                    HStack {
                                        Image(systemName: statusIcon(for: detail.request.Status))
                                            .foregroundColor(statusColor(for: detail.request.Status))
                                        Text("\(detail.request.Status.rawValue.capitalized)")
                                            .font(.subheadline)
                                            .foregroundColor(statusColor(for: detail.request.Status))
                                            .underline()
                                    }
                                }
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                    }
                } else {
                    Text("No approved requests found.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationTitle("Approved Requests")
            .onAppear(perform: fetchApprovedRequests)
        }
    }
    
    private func fetchApprovedRequests() {
        guard accountController.isLoggedIn() else { return }

        isLoading = true
        errorMessage = nil
        
        if let userID = accountController.user?.uid {
            requestController.fetchLandlordApproveOrRejectWithDetails(tentantID: userID) { fetchedDetails in
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
