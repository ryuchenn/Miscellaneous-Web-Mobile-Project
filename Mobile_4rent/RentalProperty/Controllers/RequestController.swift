//
//  RequestController.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/11.
//

import Foundation
import FirebaseFirestore

class RequestController: ObservableObject {
    private static var shared : RequestController?
    private var db = Firestore.firestore()
    
    init(db: Firestore) {
        self.db = db
    }
    
    static func getInstance() -> RequestController {
        if (shared == nil) {
            shared = RequestController(db: Firestore.firestore())
        }
        
        return shared!
    }
    
    func sendRequest(property: Property, tenantID: String, completion: @escaping (Bool) -> Void) {
        guard let propertyID = property.id else { return }
        
        let requestData: [String: Any] = [
            "LandlordID": property.contactID,
            "TenantID": tenantID,
            "PropertyID": propertyID,
            "Status": RequestStatus.pending.rawValue,
            "AppointmentDate": NSNull(),
            "createAt": Timestamp(date: Date())
        ]
        
        db.collection("request").document("\(tenantID)_\(propertyID)").setData(requestData) { error in
            completion(error == nil)
        }
    }
    
    func cancelRequest(property: String, tenantID: String,  completion: @escaping (Bool) -> Void) {
        db.collection("request").document("\(tenantID)_\(property)").delete { error in
            completion(error == nil)
        }
    }

    func checkIfRequested(tenantID: String, propertyID: String, completion: @escaping (Bool) -> Void) {
        db.collection("request").document("\(tenantID)_\(propertyID)").getDocument { document, error in
            completion(document?.exists ?? false)
        }
    }

    func approveRequest(requestID: String, appointmentDate: Date, completion: @escaping (Bool) -> Void) {
        let requestRef = db.collection("request").document(requestID)

        requestRef.updateData([
            "Status": RequestStatus.approved.rawValue,
            "AppointmentDate": Timestamp(date: appointmentDate)
        ]) { error in
            completion(error == nil)
        }
    }
    
    func rejectRequest(requestID: String, completion: @escaping (Bool) -> Void) {
        let requestRef = db.collection("request").document(requestID)
        
        requestRef.updateData([
            "Status": RequestStatus.rejected.rawValue
        ]) { error in
            completion(error == nil)
        }
    }

    func fetchDataByLandlordID(landlordID: String, completion: @escaping ([TenantRequest]) -> Void) {
        db.collection("request")
            .whereField("LandlordID", isEqualTo: landlordID)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let requests = documents.compactMap { try? $0.data(as: TenantRequest.self) }
                completion(requests)
            }
    }

    func fetchDataByTenantID(tenantID: String, completion: @escaping (Result<[TenantRequest], Error>) -> Void) {
        db.collection("request")
            .whereField("TenantID", isEqualTo: tenantID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print(#function, "Error fetching requests: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let requests = documents.compactMap { try? $0.data(as: TenantRequest.self) }
                completion(.success(requests))
            }
    }

    /**
     select a.*, b.*, d.displayName as LandlordName,  d.phoneNumber as LandlordPhone, c.displayName as TenantName,  c.phoneNumber as TenantPhone
           from request a
            join  property b on a.PropertyID=b.id
            join profile c on a.TenantID=c.id
            join profile d on a.LandlordID=d.id
          where a.LandlordID = accountHelper.id()
     */
    func fetchTenantRequestsWithDetails(landlordID: String, completion: @escaping ([TenantRequestDetail]) -> Void) {
        db.collection("request")
            .whereField("LandlordID", isEqualTo: landlordID)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let requests = documents.compactMap { try? $0.data(as: TenantRequest.self) }
                var requestDetails: [TenantRequestDetail] = []
                let dispatchGroup = DispatchGroup()
                
                for request in requests {
                    dispatchGroup.enter()
                    
                    self.fetchPropertyDetails(propertyID: request.PropertyID) { property in
                        self.fetchUserInfo(userID: request.TenantID) { tenant in
                            self.fetchUserInfo(userID: request.LandlordID) { landlord in
                                let detailedRequest = TenantRequestDetail(
                                    request: request,
                                    property: property,
                                    tenant: tenant,
                                    landlord: landlord
                                )
                                requestDetails.append(detailedRequest)
                                dispatchGroup.leave()
                            }
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(requestDetails)
                }
            }
    }
    
    /**
     select a.*, b.*, d.displayName as LandlordName,  d.phoneNumber as LandlordPhone, c.displayName as TenantName,  c.phoneNumber as TenantPhone
           from request a
            join  property b on a.PropertyID=b.id
            join profile c on a.TenantID=c.id
            join profile d on a.LandlordID=d.id
          where a.TenantID = accountHelper.id()
     */
    func fetchLandlordApproveOrRejectWithDetails(tentantID: String, completion: @escaping ([TenantRequestDetail]) -> Void) {
        db.collection("request")
            .whereField("TenantID", isEqualTo: tentantID)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let requests = documents.compactMap { try? $0.data(as: TenantRequest.self) }
                var requestDetails: [TenantRequestDetail] = []
                let dispatchGroup = DispatchGroup()
                
                for request in requests {
                    dispatchGroup.enter()
                    
                    self.fetchPropertyDetails(propertyID: request.PropertyID) { property in
                        self.fetchUserInfo(userID: request.TenantID) { tenant in
                            self.fetchUserInfo(userID: request.LandlordID) { landlord in
                                let detailedRequest = TenantRequestDetail(
                                    request: request,
                                    property: property,
                                    tenant: tenant,
                                    landlord: landlord
                                )
                                requestDetails.append(detailedRequest)
                                dispatchGroup.leave()
                            }
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(requestDetails)
                }
            }
    }

    private func fetchPropertyDetails(propertyID: String, completion: @escaping (Property?) -> Void) {
        db.collection("property").document(propertyID).getDocument { document, error in
            guard let document = document, document.exists, let property = try? document.data(as: Property.self) else {
                completion(nil)
                return
            }
            completion(property)
        }
    }

    private func fetchUserInfo(userID: String, completion: @escaping (UserProfile?) -> Void) {
        db.collection("profile").document(userID).getDocument { document, error in
            guard let document = document, document.exists, let user = try? document.data(as: UserProfile.self) else {
                completion(nil)
                return
            }
            completion(user)
        }
    }
    
    func fetchDataByPropertyID(propertyID: String, completion: @escaping (Result<[TenantRequest], Error>) -> Void) {
        db.collection("request")
            .whereField("PropertyID", isEqualTo: propertyID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print(#function, "Error fetching requests: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let requests = documents.compactMap { try? $0.data(as: TenantRequest.self) }
                completion(.success(requests))
            }
    }
    
    func fetchDataByRequestID(requestID: String, completion: @escaping (Result<TenantRequest, Error>) -> Void) {
        let requestRef = db.collection("request").document(requestID)
        
        requestRef.getDocument { document, error in
            if let error = error {
                print(#function, "Error fetching request: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Request not found"])))
                return
            }

            do {
                let request = try document.data(as: TenantRequest.self)
                completion(.success(request))
            } catch {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to decode request"])))
            }
        }
    }
}
