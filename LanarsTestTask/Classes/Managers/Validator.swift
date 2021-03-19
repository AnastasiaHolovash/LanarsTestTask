//
//  Validator.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 19.03.2021.
//

import Foundation

// MARK: - ValidationCriterion Protocol

public protocol ValidationCriterion {
    
    /// string for description of criterion
    var errorDescription: String { get }
    
    /// Check if value conform to criteria
    ///
    /// - Parameter value: value to be checked
    /// - Returns: return true if conform
    func isConform(to value: String) -> Bool
}

// MARK: - Validator

class Validator  {
    
    static let timeCriteria: [ValidationCriterion] = [IsTimeCriteria()]
    
    private let criterions: [ValidationCriterion]
    
    public init(of type: ValidatorType) {
        
        switch type {
        case .time:
            self.criterions = Self.timeCriteria
        }
    }
    
    /// validate redictors to comform
    ///
    /// - Parameters:
    ///   - value: string than must be validate
    ///   - forceExit: if true -> stop process when first validation fail. else create array of fail criterias
    ///   - result: result of validating
    public func isValid(_ value: String, forceExit: Bool, result: @escaping (ValidatorResult) -> ()) {
        
        var notPassedCriterions: [ValidationCriterion] = []
        
        for criteria in criterions {
            if !criteria.isConform(to: value) {
                if forceExit {
                    result(.notValid(criteria: criteria))
                    return
                }
                notPassedCriterions.append(criteria)
            }
        }
        
        notPassedCriterions.isEmpty ? result(.valid) : result (.notValides(criterias: notPassedCriterions))
    }
    
    /// Type of data that will be validating
    public enum ValidatorType {
        case time
    }
    
    /// Validator result object
    ///
    /// - valid: everething if ok
    /// - notValid: find not valid criteria
    /// - notValide: not valid  array of criterias
    public enum ValidatorResult {
        
        case valid
        case notValid(criteria: ValidationCriterion)
        case notValides(criterias: [ValidationCriterion])
    }
}

// MARK: - IsTimeCriteria

public struct IsTimeCriteria: ValidationCriterion {
    
    public var errorDescription: String = "Is Not a time."
    
    public func isConform(to value: String) -> Bool {
        
        let array  = value.components(separatedBy: ":")
        
        if array.count == 2,
           let first = UInt(array[0].trimmingCharacters(in: .whitespacesAndNewlines)),
           let second = UInt(array[1].trimmingCharacters(in: .whitespacesAndNewlines)),
           first < 24,
           second < 60 {
            
            return true
        }
        
        return false
    }
}
