//
//  WorkoutContext.swift
//  GymPartner2
//
//  Created by James Gasek on 6/2/23.
//

import Foundation

struct Exercise{
    
    var name: String
    var weights: [UInt8]
    var delay: UInt8
    
    init(name: String, weights: [UInt8], delay: UInt8){
        self.name = name
        self.weights = weights
        self.delay = delay
    }
}

struct WorkoutDay{
        
    var name: String
    var workouts: [Exercise]
    
    init(name: String, workouts: [Exercise]){
        self.name = name
        self.workouts = workouts
    }
}

class WorkoutContext {
    
    var days: UInt8
    var split: [WorkoutDay]
    
    init(days: UInt8, split: [WorkoutDay]){
        self.days = days
        self.split = split
    }
    
    //we will add member functions here
}
