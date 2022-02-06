//
//  PatientDetailsView.swift
//  TodoList
//
//  Created by Selcuk Baki on 6/2/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct PatientDetailsView: View {
    
    let patient : PatientDetails
    let db = Firestore.firestore()
    @State var name = String()
    
    private func updateData(){
    }
    
    
    var body: some View {
        
        VStack{
            TextField(patient.patientName, text: $name, prompt: Text("Prompt"))
            Text(patient.patientName)
            Text(patient.id)
            Button {
                db.collection("Saved Patients").document(patient.id).updateData(["name" : name])
            } label: {
                Text("Update")
            }


        }
    }
}

struct PatientDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PatientDetailsView(patient: PatientDetails(id: String(), patientName: String(), patientSurname: String(), patientAge: String()))
    }
}
