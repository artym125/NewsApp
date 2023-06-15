//
//  CalendarView.swift
//  NewsApp
//
//  Created by Ostap Artym on 16.06.2023.
//

import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var searchVM: ArticleSearchViewModel
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @State private var isSearching = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("To search by date, set Start date and End Date, then click Done")
                .font(.headline)
            DatePicker("Start date", selection: nonOptionalStartDate, displayedComponents: .date)
                .datePickerStyle(DefaultDatePickerStyle())
            
            DatePicker("End date", selection: nonOptionalEndDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
            
            Spacer()
            
            Button(action: { resetDates() }) {
                Text("Reset Dates")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
            }
            
            Button(action: { dismiss() }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            isSearching = false
        }
        .onChange(of: isSearching) { newValue in
            if newValue {
                searchNews()
            }
        }
    }
    
    private var nonOptionalStartDate: Binding<Date> {
        Binding<Date>(
            get: { startDate ?? searchVM.startDate ?? searchVM.endDate ?? Date() },
            set: { startDate = $0 }
        )
    }
    
    private var nonOptionalEndDate: Binding<Date> {
        Binding<Date>(
            get: { endDate ?? searchVM.endDate ?? Date() },
            set: { endDate = $0 }
        )
    }
    
    private func resetDates() {
        startDate = nil
        endDate = nil
    }
    private func updateDates() {
        if let startDate = searchVM.startDate, let endDate = searchVM.endDate {
            self.searchVM.startDate = startDate
            self.searchVM.endDate = endDate
        }
    }

    private func dismiss() {
        if startDate != nil || endDate != nil {
            updateDates()
            isSearching = true
        }

        presentationMode.wrappedValue.dismiss()
    }

    
    private func searchNews() {
        searchVM.startDate = startDate
        searchVM.endDate = endDate
        Task {
            await searchVM.searchArticle()
        }
    }
}



struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(searchVM: ArticleSearchViewModel(), startDate: .constant(nil), endDate: .constant(nil))
    }
}
