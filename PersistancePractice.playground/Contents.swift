import UIKit

struct Note: Codable {
    
    let title: String
    let text: String
    let timestamp: Date
}

let note1 = Note(title: "Note One", text: "This is a sample note.", timestamp: Date())
let note2 = Note(title: "Note Two", text: "This is another sample note.", timestamp: Date())
let note3 = Note(title: "Note Three", text: "This is yet another sample note.", timestamp: Date())

let notes = [note1, note2, note3]

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = documentsDirectory.appendingPathComponent("notes_test").appendingPathExtension("plist")

let propertyListEncoder = PropertyListEncoder()

let encodedNotes = try? propertyListEncoder.encode(notes)
try? encodedNotes?.write(to: archiveURL, options: .noFileProtection)

let propertyListDecoder = PropertyListDecoder()

if let retrievedData = try? Data(contentsOf: archiveURL),
   let decodedNotes = try? propertyListDecoder.decode([Note].self, from: retrievedData) {
    
    print(decodedNotes)
}
