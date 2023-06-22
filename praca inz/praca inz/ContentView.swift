//
//  ContentView.swift
//  praca inz
//
//  Created by Agnieszka Szczepanska on 08/06/2023.
//
import SwiftUI

struct ContentView: View {
    @State private var showDatePicker = false
    @State private var showForm = false
    @State private var showBadaniaList = false
    @State private var selectedDate = Date()
    @State private var name = ""
    @State private var result = ""
    @State private var badania: [Badanie] = []
    
    // Zapisywanie danych przy użyciu User Defaults
    @AppStorage("savedBadania") var savedBadania: Data = Data()
    
    var body: some View {
        VStack {
            if !showDatePicker && !showForm {
                Button("Dodaj nowe badania") {
                    showDatePicker = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 4, x: 0, y: 2)
                
                Button("Lista badań") {
                    showBadaniaList = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 4, x: 0, y: 2)
            }
            
            if showDatePicker {
                DatePicker("Data badania", selection: $selectedDate, displayedComponents: .date)
                    .padding()
                
                Button("Dalej") {
                    showDatePicker = false
                    showForm = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 4, x: 0, y: 2)
            }
            
            if showForm {
                TextField("Nazwa badania", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Wynik", text: $result)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button("Dodaj następne badanie") {
                        addBadanie()
                        clearFields()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    
                    Button("Zakończ") {
                        addBadanie()
                        clearFields()
                        showForm = false
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
                }
            }
        }
        .padding()
        .sheet(isPresented: $showBadaniaList) {
            BadaniaListView(badania: badania)
        }
        .onAppear {
            loadSavedBadania()
        }
        .onDisappear {
            saveBadania()
        }
    }
    
    private func addBadanie() {
        let newBadanie = Badanie(date: selectedDate, name: name, result: result)
        badania.append(newBadanie)
    }
    
    private func clearFields() {
        name = ""
        result = ""
    }
    
    private func loadSavedBadania() {
        if let decodedBadania = try? JSONDecoder().decode([Badanie].self, from: savedBadania) {
            badania = decodedBadania
        }
    }
    
    private func saveBadania() {
        if let encodedBadania = try? JSONEncoder().encode(badania) {
            savedBadania = encodedBadania
        }
    }
}

struct Badanie: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let name: String
    let result: String
}

struct BadaniaListView: View {
    var badania: [Badanie]
    
    var body: some View {
        NavigationView {
            List(badania) { badanie in
                VStack(alignment: .leading) {
                    Text("Data: \(formattedDate(badanie.date))")
                    Text("Nazwa: \(badanie.name)")
                    Text("Wynik: \(badanie.result)")
                }
            }
            .navigationBarTitle("Wszystkie badania")
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
