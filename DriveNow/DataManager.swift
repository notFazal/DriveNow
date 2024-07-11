import SwiftUI
import Firebase
import FirebaseFirestore

struct Car: Identifiable {
    var id: String
    var title: String
    var year: Int
    var make: String
    var model: String
    var color: String
    var drive: String
    var engine: String
    var imageUrl: String
    var listing: String
    var price: Int
    var mileage: Int
    var stock: String
    var trans: String
    var trim: String
    var vin: String
}

class DataManager: ObservableObject {
    @Published var cars: [Car] = []
    
    func fetchCars() {
        cars.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("cars")
        ref.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            DispatchQueue.main.async {
                self.cars = snapshot.documents.compactMap { document in
                    let data = document.data()
                    let id = document.documentID
                    let title = data["title"] as? String ?? "Unknown"
                    let year = data["year"] as? Int ?? 0
                    let make = data["make"] as? String ?? ""
                    let model = data["model"] as? String ?? ""
                    let color = data["color"] as? String ?? ""
                    let drive = data["drive"] as? String ?? ""
                    let engine = data["engine"] as? String ?? ""
                    let imageUrl = data["imageUrl"] as? String ?? ""
                    let listing = data["listing"] as? String ?? ""
                    let price = data["price"] as? Int ?? 0
                    let mileage = data["mileage"] as? Int ?? 0
                    let stock = data["stock"] as? String ?? ""
                    let trans = data["trans"] as? String ?? ""
                    let trim = data["trim"] as? String ?? ""
                    let vin = data["vin"] as? String ?? ""
                                        
                    return Car(id: id, title: title, year: year, make: make, model: model, color: color, drive: drive, engine: engine, imageUrl: imageUrl, listing: listing, price: price, mileage: mileage, stock: stock, trans: trans, trim: trim, vin: vin)
                }
            }
        }
    }

}

