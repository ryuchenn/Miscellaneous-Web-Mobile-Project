//
//  TenantRequestDetailView.swift
//  RentalProperty
//
//  Created by admin on 2025-03-09.
//

import SwiftUI

struct TenantRequestDetailView: View {
    @EnvironmentObject var accountController: AccountController
    @EnvironmentObject var requestController: RequestController
    
    @State var requestDetail: TenantRequestDetail
    @State private var appointmentDate = Date()
    @State private var isUpdating = false
    @State private var showDatePicker = false

    var isLandlord: Bool {
        return requestDetail.request.LandlordID == accountController.user?.uid
    }

    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Tenant Request")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    Image(systemName: statusIcon(for: requestDetail.request.Status))
                        .foregroundColor(statusColor(for: requestDetail.request.Status))
                    Text("Status: ")
                        .font(.headline)
                        .foregroundColor(statusColor(for: requestDetail.request.Status))
                    Text("\(requestDetail.request.Status.rawValue.capitalized)")
                        .font(.headline)
                        .foregroundColor(statusColor(for: requestDetail.request.Status))
                        .underline()
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "house.fill")
                        .foregroundColor(Color("TealBlueColor"))
                    Text("\(requestDetail.property?.address2 ?? "") - \(requestDetail.property?.address1 ?? "N/A")")
                        .font(.headline)
                        .bold()
                }
                
                if let communityName = requestDetail.property?.communityName, !communityName.isEmpty {
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(Color("TealBlueColor"))
                        Text(communityName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                if let displayName = requestDetail.tenant?.displayName, !displayName.isEmpty {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("TealBlueColor"))
                        Text("\(displayName)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                if let date = requestDetail.request.AppointmentDate {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color("TealBlueColor"))
                        Text("\(date.formatted(date: .long, time: .shortened))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .underline()
                    }
                } else {
                    HStack {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .foregroundColor(Color("TealBlueColor"))
                        Text("No Appointment Date Set")
                            .foregroundColor(.gray)
                            .underline()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)


            if isLandlord {
                if showDatePicker {
                    VStack(spacing: 15) {
                        Text("Select Appointment Date & Time:")
                            .font(.headline)

                        DatePicker("", selection: $appointmentDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(WheelDatePickerStyle())
                            .padding()

                        HStack {
                            Button(action: { showDatePicker = false }) {
                                Label("Cancel", systemImage: "xmark.circle.fill")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }

                            Button(action: updateAppointmentDate) {
                                if isUpdating {
                                    ProgressView()
                                } else {
                                    Label("Confirm", systemImage: "checkmark.circle.fill")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .disabled(isUpdating)
                        }
                        .padding()
                    }
                } else {
                    VStack(spacing: 10) {
                        if requestDetail.request.Status == .pending || requestDetail.request.Status == .rejected {
                            Button(action: { showDatePicker = true }) {
                                Label("Approve Request", systemImage: "checkmark.circle.fill")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("TealBlueColor"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }

                        if requestDetail.request.Status == .pending || requestDetail.request.Status == .approved {
                            Button(action: rejectRequest) {
                                Label("Reject Request", systemImage: "xmark.circle.fill")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()

                }
            } else {
                if let landlordPhone = requestDetail.landlord?.phoneNumber {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                        Text("Landlord: \(landlordPhone)")
                            .font(.subheadline)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Request Detail")
        .background(Color(.systemGroupedBackground))
    }

    private func updateAppointmentDate() {
        guard let requestID = requestDetail.request.id else { return }
        isUpdating = true

        requestController.approveRequest(requestID: requestID, appointmentDate: appointmentDate) { success in
            isUpdating = false
            if success {
                showDatePicker = false
                refresh()
            }
        }
    }

    private func rejectRequest() {
        guard let requestID = requestDetail.request.id else { return }
        isUpdating = true

        requestController.rejectRequest(requestID: requestID) { success in
            isUpdating = false
            refresh()
        }
    }
    
    private func refresh() {
        requestController.fetchDataByRequestID(requestID: requestDetail.request.id ?? "") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedRequest):
                    self.requestDetail.request = updatedRequest
                case .failure(let error):
                    print("Failed to fetch request: \(error.localizedDescription)")
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

