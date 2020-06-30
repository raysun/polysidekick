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
        return optim(defender: defender, attackers: attackers, sequence: [], remaining: attackers, defenderHealth: defender.hp)
    }

    private static func optim(defender: Troop, attackers: [Troop], sequence: [Troop], remaining: [Troop], defenderHealth: Double) -> OptimizationValue {
        if remaining.count == 0 || defenderHealth <= 0 {
            return OptimizationValue(defenderHealth: defenderHealth, sequence: sequence)
        } else {
            var returnedValues = [OptimizationValue]()
            for var troop in remaining {
                let damageToDefender = round(4.5 * troop.attack * troop.scaledAttack/(troop.scaledAttack + defender.scaledDefense))
                print("Troop: \(troop.imageURL), Defender: \(defender.imageURL), Damage to defender: \(damageToDefender)")
                let localDefenderHealth = defenderHealth - damageToDefender
                var localSequence = sequence
                if (localDefenderHealth > 0) {
                    let damageToAttacker = round(4.5 * defender.defense * defender.scaledDefense/(defender.scaledDefense + troop.scaledAttack))
                    print("Damage to attacker: \(damageToAttacker)")
                    troop.hp = troop.hp - damageToAttacker
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
                returnedValues.append(optim(defender: defender, attackers: attackers, sequence: localSequence, remaining: localRemaining, defenderHealth: localDefenderHealth))
            }
            returnedValues = returnedValues.sorted {
                $0.defenderHealth < $1.defenderHealth
//                    || ($0.defenderHealth == $1.defenderHealth && $0.attackerHPs.reduce(0,+) > $1.attackerHPs.reduce(0,+))
            }
            return returnedValues[0]
        }
    }
}
