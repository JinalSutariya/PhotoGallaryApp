//
//  SaveImageData.swift
//  Unsplash
//
//  Created by CubezyTech on 16/01/24.
//

import Foundation
import SQLite

class SaveDatabaseHelper {
    static let shared = SaveDatabaseHelper()
    private let db: Connection?

    
    private let saveImages = Table("saveImages")
    private let iid = Expression<Int>("iid")
    private let saveData = Expression<Data>("saveData")

    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!

            db = try Connection("\(path)/db.sqlite3")

            createTable2()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
   
    
  
    
    private func createTable2() {
        do {
            try db!.run(saveImages.create { table in
                table.column(iid, primaryKey: true)
                table.column(saveData)
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }
    
    func isImageInSave(imageData: Data) -> Bool {
           do {
               let query = saveImages.filter(self.saveData == imageData)
               let count = try db!.scalar(query.count)

               return count > 0
           } catch {
               print("Query failed: \(error)")
               return false
           }
       }

    func saveImage(imageData: Data) {
        do {
            let insert = saveImages.insert(self.saveData <- imageData)
            try db!.run(insert)
        } catch {
            print("Insertion failed: \(error)")
        }
    }


    func getAllSaveImages() -> [Data] {
        var imageArray = [Data]()
        do {
            for image in try db!.prepare(saveImages) {
                imageArray.append(image[saveData])
            }
        } catch {
            print("Query failed: \(error)")
        }
        return imageArray
    }
}
