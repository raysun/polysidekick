//
//  Calc.swift
//  Polytopia Sidekick
//
//  Created by Karen and Ray Sun on 6/30/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Foundation

class Calc {
    static func calculate(troops: [Troop]) -> OptimizationValue {
        let defender = troops[0]
        var attackers = troops
        attackers.remove(at: 0)
        let attackerHPs = [Double]()
        return optim(defender: defender, attackers: attackers, sequence: [], remaining: attackers, defenderHealth: defender.hp, attackerHPs: attackerHPs)
    }

    private static func optim(defender: Troop, attackers: [Troop], sequence: [Troop], remaining: [Troop], defenderHealth: Double, attackerHPs: [Double]) -> OptimizationValue {
        if remaining.count == 0 || defenderHealth <= 0 {
            return OptimizationValue(defenderHealth: defenderHealth, sequence: sequence, attackerHPs: attackerHPs)
        } else {
            var returnedValues = [OptimizationValue]()
            for troop in remaining {
                let localDefenderHealth = defenderHealth - round(4.5 * troop.attack * troop.attack/(troop.attack + defender.defense))
                var localAttackerHPs = attackerHPs
                if (localDefenderHealth > 0) {
                    let localAttackerHP = troop.hp - round(4.5 * defender.defense * defender.defense/(defender.defense + troop.attack))
                    localAttackerHPs.append(localAttackerHP)
                } else {
                    localAttackerHPs.append(troop.hp)
                }
                var localSequence = sequence
                localSequence.append(troop)
                var i: Int = 0
                var localRemaining = remaining
                for remainingTroop in remaining {
                    if (remainingTroop.id == troop.id) {
                        localRemaining.remove(at: i)
                        break
                    }
                    i += 1
                }
                returnedValues.append(optim(defender: defender, attackers: attackers, sequence: localSequence, remaining: localRemaining, defenderHealth: localDefenderHealth, attackerHPs: localAttackerHPs))
            }
            returnedValues = returnedValues.sorted {
                $0.defenderHealth < $1.defenderHealth || ($0.defenderHealth == $1.defenderHealth && $0.attackerHPs.reduce(0,+) > $1.attackerHPs.reduce(0,+))
            }
            return returnedValues[0]
        }
    }
}
