//
//  TenantRequest.swift
//  RentalProperty
//
//  Created by admin on 2025-03-09.
//

import Foundation
import FirebaseFirestore

struct TenantRequest: Identifiable, Codable {
    @DocumentID var id: String?
    var LandlordID: String
    var TenantID: String
    var PropertyID: String
    var Status: RequestStatus
    var AppointmentDate: Date?
    var createAt: Date
}
