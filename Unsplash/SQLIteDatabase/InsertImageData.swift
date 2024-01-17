//
//  SQLiteDatabse.swift
//  Unsplash
//
//  Created by CubezyTech on 11/01/24.
//

import Foundation
import SQLite

class InsertDatabaseHelper {
    static let shared = InsertDatabaseHelper()
    private let db: Connection?

    private let images = Table("images")
    private let id = Expression<Int>("id")
    private let imageData = Expression<Data>("imageData")
    
   

    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!

            db = try Connection("\(path)/db.sqlite3")

            createTable()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
   
    
    private func createTable(){
        do {
            try db!.run(images.create { table in
                table.column(id, primaryKey: true)
                table.column(imageData)
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }
    
    
    func isImageInFavorites(imageData: Data) -> Bool {
           do {
               let query = images.filter(self.imageData == imageData)
               let count = try db!.scalar(query.count)

               return count > 0
           } catch {
               print("Query failed: \(error)")
               return false
           }
       }

    func insertImage(imageData: Data) {
        do {
            let insert = images.insert(self.imageData <- imageData)
            try db!.run(insert)
        } catch {
            print("Insertion failed: \(error)")
        }
    }


    func getAllImages() -> [Data] {
        var imageArray = [Data]()
        do {
            for image in try db!.prepare(images) {
                imageArray.append(image[imageData])
            }
        } catch {
            print("Query failed: \(error)")
        }
        return imageArray
    }
    
    func removeImageFromFavorites(imageData: Data) {
            do {
                let query = images.filter(self.imageData == imageData)
                try db!.run(query.delete())
            } catch {
                print("Deletion failed: \(error)")
            }
        }
   
}
