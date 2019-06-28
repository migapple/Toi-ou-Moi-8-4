//
//  CalculDates.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 05/06/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import Foundation

// Retourne la date de debut et la date de fin du mois en cours
func DateDebutDateFin(moisEncours: Int) -> (Date, Date) {
    let calendar = Calendar.current
    let dateDebutDeMois = startOfMonth()
    let dateFinDeMois = endOfMonth()
    
    let dateDebutMoisPrécédent = calendar.date(byAdding: .month, value: moisEncours, to: dateDebutDeMois)!
    let dateDefinMoisPrécédent = calendar.date(byAdding: .month, value: moisEncours, to: dateFinDeMois)!
//    print("\(dateDebutMoisPrécédent)")
//    print("\(dateDefinMoisPrécédent)")
    return (dateDebut: dateDebutMoisPrécédent, dateFin: dateDefinMoisPrécédent)
}


func startOfMonth() -> Date {
    let date = Date()
    let calendar = Calendar.current
    let currentDateComponents = calendar.dateComponents([.year, .month], from: date)
    let startOfMonth = calendar.date(from: currentDateComponents)!.addingTimeInterval(1)
    //let startOfMonth = calendar.date(from: currentDateComponents)!.addingTimeInterval(60*60*24)
    return startOfMonth
}

func dateByAddingMonths(_ monthsToAdd: Int) -> Date {
    let date = Date()
    let calendar = Calendar.current
    var months = DateComponents()
    months.month = monthsToAdd
    return calendar.date(byAdding: months, to: date)!
}

func dateBySubtractMonths(_ monthsToAdd: Int) -> Date {
    let date = Date()
    let calendar = Calendar.current
    var months = DateComponents()
    months.month = monthsToAdd
    return calendar.date(byAdding: .month, value: -1, to: date)!
}

func endOfMonth() -> Date {
    // guard let plusOneMonthDate = dateByAddingMonths(1) else { return nil }
    let plusOneMonthDate = dateByAddingMonths(1)
    let calendar = Calendar.current
    let plusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: plusOneMonthDate)
    //let endOfMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1)
    let endOfMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(0)
    return endOfMonth!
}
