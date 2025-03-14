//
//  TenantRequestDetail.swift
//  RentalProperty
//
//  Created by admin on 2025-03-11.
//
import Foundation

struct TenantRequestDetail: Identifiable {
    var id: String { request.id ?? UUID().uuidString }
    var request: TenantRequest
    var property: Property?
    var tenant: UserProfile?
    var landlord: UserProfile?
}
