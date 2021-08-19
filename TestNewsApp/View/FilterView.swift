//
//  FilterView.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-17.
//

import SwiftUI

struct FilterView: View {
    @State var openToDate = false
    @State var openFromDate = false
    @State var popoverSize = CGSize(width: 320, height: 300)
    @State var dateFrom: Date = Calendar.current.date(byAdding: DateComponents(month: -6), to: Date()) ?? Date()
    @State var dateTo = Date() 
    @EnvironmentObject var filterSettings: FilterSettingsViewModel
    
    var header: some View { Text("Date").modifier(LabelTextSm()) }
    
    private var dateToProxy:Binding<Date> {
        Binding<Date>(get: {self.dateTo }, set: {
            self.dateTo = $0
            filterSettings.setDateTo($0)
        })
    }
    
    private var dateFromProxy:Binding<Date> {
            Binding<Date>(get: {self.dateFrom }, set: {
                self.dateFrom = $0
                filterSettings.setDateFrom($0)
            })
        }
    
    init() {
        let now = Date()
        self._dateTo = State<Date>(initialValue: now)
        UIDatePicker.appearance().tintColor = UIColor(Color("Primary"))
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle().fill(Color.white)
            VStack(alignment: .leading) {
                Text("Filter").modifier(LabelText())
                Section(header: header) {
                    Text("From").modifier(LabelTextXs())
                    HStack {
                        Text("\(dateFrom.formatStringFromDate())").modifier(LabelTextSm()).frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        PopoverDatepicker(showPopover: $openFromDate, popoverSize: popoverSize) {
                            Image(systemName: "calendar").foregroundColor(Color("Primary"))
                            
                        } popoverContent: {
                            DatePicker("", selection: dateFromProxy, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding(.bottom, -40)
                                .onChange(of: dateFrom) { value in
                                    filterSettings.setDateFrom(dateFrom)
                                }
                        }
                    }.onTapGesture {
                        openFromDate.toggle()
                    }
                    Divider().background(Color("Primary"))
                    Text("To").modifier(LabelTextXs())
                    HStack {
                        Text("\(dateTo.formatStringFromDate())").modifier(LabelTextSm()).frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        PopoverDatepicker(showPopover: $openToDate, popoverSize: popoverSize) {
                            Image(systemName: "calendar").foregroundColor(Color("Primary"))
                        } popoverContent: {
                            DatePicker("", selection: dateToProxy, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding(.bottom, -40)
                                .onChange(of: dateTo) { value in
                                    filterSettings.setDateTo(dateTo)
                                }
                        }
                    }.onTapGesture {
                        openToDate.toggle()
                    }
                    Divider().background(Color("Primary"))
                    NavigationLink(destination: SearchInView().environmentObject(filterSettings), label: {
                        HStack {
                            Text("Search in").modifier(LabelTextSm()).frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            Text(filterSettings.createSearchInLabel()).modifier(LabelTextSmGray())
                        }.frame(maxWidth: .infinity)
                    })
                    Divider().background(Color("BackgroundColor"))
                }
            }.padding(.horizontal, 15)
        }
        .onAppear() {
            dateTo = filterSettings.dateTo
            dateFrom = filterSettings.dateFrom
        }
        .modifier(TopBar())
        .toolbar {
            Button {
                clear()
            } label: {
                HStack {
                    Text("Clear").offset(x: 5)
                    Image(systemName: "trash")
                }
            }
        }
    }
    
    func clear() {
        filterSettings.clear()
    }
    
}


