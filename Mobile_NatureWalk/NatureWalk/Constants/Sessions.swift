//
//  Sessions.swift
//  NatureWalk
//
//  Created by joeyin on 2025/2/7.
//

import Foundation

let sessions: [Session] = [
    Session(
        id: 1,
        name: "Hiking in Banff National Park",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 20, hour: 5, minute: 30, second: 0))!,
        address: "Banff National Park, Alberta, Canada",
        description: "Explore the breathtaking trails of Banff National Park, surrounded by majestic mountains and pristine lakes.",
        rating: 4.8,
        hosting: "Adventure Canada Tours",
        photos: ["banff1", "banff2"],
        price: 50.0,
        phone: "123456789"
    ),
    Session(
        id: 2,
        name: "Niagara Falls Sightseeing Tour",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 12, hour: 8, minute: 30, second: 0))!,
        address: "Niagara Falls, Ontario, Canada",
        description: "Experience the power and beauty of Niagara Falls on a guided tour with boat rides and scenic viewpoints.",
        rating: 4.9,
        hosting: "Great Canadian Tours",
        photos: ["niagara1", "niagara2"],
        price: 100.0,
        phone: "123456789"
    ),
    Session(
        id: 3,
        name: "Grouse Mountain Adventure",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 25, hour: 6, minute: 0, second: 0))!,
        address: "Grouse Mountain, Vancouver, British Columbia, Canada",
        description: "Take a gondola ride up Grouse Mountain and enjoy hiking, wildlife, and spectacular views of Vancouver.",
        rating: 2.7,
        hosting: "West Coast Expeditions",
        photos: ["grouseMountain1", "grouseMountain2"],
        price: 75.0,
        phone: "123456789"
    ),
    Session(
        id: 4,
        name: "Aurora Borealis Viewing in Yellowknife",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 15, hour: 8, minute: 0, second: 0))!,
        address: "Yellowknife, Northwest Territories, Canada",
        description: "Witness the mesmerizing Northern Lights in one of the best locations for aurora viewing.",
        rating: 3.9,
        hosting: "Northern Lights Tours Canada",
        photos: ["aurora1", "aurora2"],
        price: 200.0,
        phone: "123456789"
    ),
    Session(
        id: 5,
        name: "Glacier Hiking in Jasper National Park",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 15, hour: 8, minute: 0, second: 0))!,
        address: "Jasper National Park, Alberta, Canada",
        description: "Embark on an unforgettable glacier hiking adventure in Jasper National Park, where you will explore the stunning icefields and breathtaking landscapes. Embark on an unforgettable glacier hiking adventure in Jasper National Park, where you will explore the stunning icefields and breathtaking landscapes. Embark on an unforgettable glacier hiking adventure in Jasper National Park, where you will explore the stunning icefields and breathtaking landscapes. Embark on an unforgettable glacier hiking adventure in Jasper National Park, where you will explore the stunning icefields and breathtaking landscapes.",
        rating: 4.8,
        hosting: "Rocky Mountain Adventures",
        photos: ["glacier1", "glacier2"],
        price: 120.0,
        phone: "123456789"
    )
]
