//
//  UserProfile.swift
//  RentalProperty
//
//  Created by admin on 2025-03-09.
//
import Foundation
import FirebaseFirestore

struct UserProfile: Identifiable, Codable {
    @DocumentID var id: String?
    var displayName: String
    var phoneNumber: String
    var photoURL: String?
    var avatar: URL?
}
