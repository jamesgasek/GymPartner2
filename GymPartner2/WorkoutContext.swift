//
//  WorkoutContext.swift
//  GymPartner2
//
//  Created by James Gasek on 6/2/23.
//

import Foundation

enum WorkoutType{
    
    case timed
    case distance
    case repetitions
    
}

struct Set{
    
    var type: WorkoutType
    var weight: UInt16
    var delay: UInt16
    
    init(weight: UInt16, delay: UInt16, type: WorkoutType = .repetitions) {
        self.weight = weight
        self.delay = delay
        self.type = type
    }
}

struct Exercise{
    
    var sets: [Set]
    var delay: UInt16
    
    init(sets: [Set], delay: UInt16){
        self.sets = sets
        self.delay = delay
    }
}

struct Workout{
        
    var name: String
    var Exercises: [Exercise]
    
    init(name: String, Exercises: [Exercise]){
        self.name = name
        self.Exercises = Exercises
    }
}

struct Rotation{
    
    var workouts: [Workout]
    
    init(workouts: [Workout]) {
        self.workouts = workouts
    }
}
