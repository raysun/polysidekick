//
//  Calc.swift
//  Polytopia Sidekick
//
//  Created by Karen and Ray Sun on 6/30/20.
//  Copyright © 2020 Ray Sun. All rights reserved.
//

import Foundation


private func sumHealth(_ x: Double, _ y: Troop) -> Double {
    return x + y.workingHP
}

class Calc {
    static func calculate(defender: Troop, attackers: [Troop]) -> OptimizationValue {
        var tmpDefender = defender
        tmpDefender.workingHP = defender.hp
        var tmpAttackers = [Troop]()
        for var troop in attackers {
            troop.workingHP = troop.hp
            troop.didAttack = false
            tmpAttackers.append(troop)
        }
        return optim(defender: tmpDefender, attackers: tmpAttackers, sequence: [], remaining: tmpAttackers, defenderHealth: tmpDefender.workingHP)
    }

    private static func optim(defender: Troop, attackers: [Troop], sequence: [Troop], remaining: [Troop], defenderHealth: Double) -> OptimizationValue {
        if remaining.count == 0 || defenderHealth <= 0 {
            return OptimizationValue(defenderHealth: defenderHealth, sequence: sequence + remaining)
        } else {
            var returnedValues = [OptimizationValue]()
            for var troop in remaining {
                troop.didAttack = true
                let damageToDefender = round(4.5 * troop.attack * troop.scaledAttack/(troop.scaledAttack + defender.scaledDefense))
                print("Troop: \(troop.imageURL), HP: \(troop.workingHP) Defender: \(defender.imageURL), Damage to defender: \(damageToDefender)")
                let localDefenderHealth = max(0, defenderHealth - damageToDefender)
                var defenderCopy = defender
                defenderCopy.workingHP = localDefenderHealth
                var localSequence = sequence
                if (localDefenderHealth > 0 && troop.takesDamageFromOpponent) {
                    let damageToAttacker = round(4.5 * defender.defense * defender.scaledDefense/(defender.scaledDefense + troop.scaledAttack))
                    print("Damage to attacker: \(damageToAttacker)")
                    troop.workingHP = max(0, troop.workingHP - damageToAttacker)
                }
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
                returnedValues.append(optim(defender: defenderCopy, attackers: attackers, sequence: localSequence, remaining: localRemaining, defenderHealth: localDefenderHealth))
            }
            returnedValues = returnedValues.sorted {
                $0.defenderHealth < $1.defenderHealth
                    || ($0.defenderHealth == $1.defenderHealth && $0.sequence.reduce(0, sumHealth) > $1.sequence.reduce(0, sumHealth))
            }
            return returnedValues[0]
        }
    }
}
