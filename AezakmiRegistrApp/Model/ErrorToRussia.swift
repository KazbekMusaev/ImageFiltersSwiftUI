//
//  ErrorToRussia.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 14.05.2024.
//

import Foundation

struct ErrorToRussia {
    let errorDict: [Int: String] = [
        17010: "Слишком много попыток входа, повторите через 30 секунд",
        17004: "Неверный пароль или почта",
        17008: "Невернно введена почта",
        17009: "Неверный ввод пароля",
        0: "Ошибка входа",
        404: "Поля password confirm и password должны совпадать!"
    ]
}
