//
//  saveNrestore.swift
//  Snake
//
//  Created by Echo on 18.01.21.
//
//  used source to learn about how to store and fetch data on mobile device:
//  https://stackoverflow.com/questions/25586593/coredata-swift-how-to-save-and-load-data

import CoreData

//___FUNCTION_FOR_SAVING_SETTINGS___

func saveSettings(_ context : NSManagedObjectContext!) {
    let entity = NSEntityDescription.entity(forEntityName: "Settings", in: context)
    let actualSettings = NSManagedObject(entity: entity!, insertInto: context)
    actualSettings.setValue(global.boardSize, forKey: "boardSize")
    actualSettings.setValue(global.gameSpeed, forKey: "gameSpeed")
    actualSettings.setValue(global.sound, forKey: "sound")
    
    print("Storing Data..")
    do {
        try context.save()
    } catch {
        print("Storing Data Failed")
    }
}

//___FUNCTIONS_FOR_SAVING_HIGHSCORES___
    
fileprivate func saveHighscores(_ data: NSManagedObject){
    for idx in 0..<10 {
        data.setValue(globalHighScores[idx], forKey: "score\(idx+1)")
    }
}

fileprivate func saveHighscoreNames(_ data: NSManagedObject){
    for idx in 0..<10 {
        data.setValue(globalHighScoreNames[idx], forKey: "name\(idx+1)")
    }
}

fileprivate func saveDataInModel(entityName: String,
                                 saveFunction: (NSManagedObject) -> Void,
                                 _ context : NSManagedObjectContext!)
{
    let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
    let data = NSManagedObject(entity: entity!, insertInto: context)
    saveFunction(data)
    do {
        try context.save()
    } catch {
        print("Storing Data Failed!")
    }
}

func saveHighscoreData(_ context : NSManagedObjectContext!) {
    print("Storing Data..")
    saveDataInModel(entityName: "Highscores", saveFunction: saveHighscores(_:), context)
    saveDataInModel(entityName: "HighscoreUsers", saveFunction: saveHighscoreNames(_:), context)
}

//___FUNCTIONS_FOR_LOADING_OLD_HIGHSCORES_AND_SETTINGS___

fileprivate func getSettings (_ data: NSManagedObject) {
    global.boardSize = data.value(forKey: "boardSize") as! Int
    global.gameSpeed = data.value(forKey: "gameSpeed") as! Float
    global.sound = data.value(forKey: "sound") as! Bool
}

fileprivate func getHighscores(_ data: NSManagedObject) {
    for idx in 0..<10 {
        globalHighScores[idx] = data.value(forKey: "score\(idx+1)") as! Int
    }
}

fileprivate func getHighscoreNames(_ data: NSManagedObject) {
    for idx in 0..<10 {
        globalHighScoreNames[idx] = data.value(forKey: "name\(idx+1)") as! String
    }
}

fileprivate func getDataFromModel(entityName: String,
                                  getFunction: (NSManagedObject) -> Void,
                                  _ context : NSManagedObjectContext!)
{
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
            getFunction(data)
        }
    } catch {
        print("Fetching data Failed!")
    }
}

func fetchData(_ context : NSManagedObjectContext!) {
    print("Fetching Data..")
    getDataFromModel(entityName: "Settings", getFunction: getSettings(_:), context)
    getDataFromModel(entityName: "Highscores", getFunction: getHighscores(_:), context)
    getDataFromModel(entityName: "HighscoreUsers", getFunction: getHighscoreNames(_:), context)
}
