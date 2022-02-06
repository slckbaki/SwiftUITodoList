//
//  ContentView.swift
//  TodoList
//
//  Created by Selcuk Baki on 25/1/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct ContentView: View {
    
    
    let db = Firestore.firestore()
    
    @State var userName = ""
    @State var surname = ""
    @State var age = ""
    @State var ref : DocumentReference? = nil
    @State var buttonChange = false
    @State var detailsPatients : [PatientDetails] = []
    
    
    
    private func fetchAllData(){
        detailsPatients.removeAll(keepingCapacity: true)
        db.collection("Saved Patients").getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                for document in snapshot!.documents{
                    let patient = PatientDetails(id: document.documentID, patientName: document.get("name") as! String, patientSurname: document.get("surname") as! String, patientAge: document.get("age") as! String)
                    
                    detailsPatients.append(patient)
                }
            }
        }
        
    }
    
    
    
    private func saveData(){
        
        //IF Control Needed
        let patients = PatientDetails(id: String(), patientName: userName, patientSurname: surname, patientAge: age)
        detailsPatients.append(patients)
        let patientData = ["name" : patients.patientName, "surname" : patients.patientSurname, "age" : patients.patientAge]
        db.collection("Saved Patients").addDocument(data: patientData)
        fetchAllData()
        
    }
    
    private func deletePatient(at indexSet: IndexSet){
        indexSet.forEach { index in
            let task = detailsPatients[index]
            db.collection("Saved Patients").document(task.id).delete { err in
                if err != nil {
                    print(err?.localizedDescription)
                } else {
                    fetchAllData()
                }
            }
        }
    }
    
    var body: some View {
        
        NavigationView {
        VStack {
            TextField("Please enter your name", text: $userName, prompt: Text("Please enter your name"))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("your surname", text: $surname, prompt: Text("Please enter your surname"))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("age", text: $age, prompt: Text("Please enter your age"))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button {
                saveData()
                
            }
        label: {
            Text("Save Data")
        }
                List{
                    ForEach(detailsPatients, id: \.id){ patient in
                        NavigationLink {
                            PatientDetailsView(patient: patient)
                        } label: {
                            Text(patient.patientName)

                        }

                        
                    }.onDelete(perform: deletePatient(at:))
                }.listStyle(PlainListStyle())
            
            
            Spacer()
                .onAppear(perform: fetchAllData)
            
            Button {
                fetchAllData()
            } label: {
                Text("Fetch Data")
            }
        }
        }
        .alert(isPresented: $buttonChange) {
            return Alert(title: Text("Hata"), message: Text("bos yer var"), primaryButton: Alert.Button.cancel(), secondaryButton: Alert.Button.default(Text("OK"), action: {
                //ok button action
            }))
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( buttonChange: false)
    }
}

