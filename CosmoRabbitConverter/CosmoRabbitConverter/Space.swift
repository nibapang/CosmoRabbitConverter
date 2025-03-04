//
//  Space.swift
//  CosmoRabbitConverter
//
//  Created by CosmoRabbit Converter on 2025/3/4.
//


var CosmoRabbitSpace: [CosmoRabbitConverterData] = [
    // 1. Weight Converter
    CosmoRabbitConverterData(title: "Weight Converter – How Heavy Are You in Space?", space: [
        CosmoRabbitSpaceTitle(name: "Moon", value: 0.166, valueName: "1/6th of Earth's gravity", convertFrom: "kg (Earth)", convertTo: "kg (Moon)"),
        CosmoRabbitSpaceTitle(name: "Mars", value: 0.38, valueName: "0.38 times Earth's gravity", convertFrom: "kg (Earth)", convertTo: "kg (Mars)"),
        CosmoRabbitSpaceTitle(name: "Jupiter", value: 2.34, valueName: "2.34 times Earth's gravity", convertFrom: "kg (Earth)", convertTo: "kg (Jupiter)"),
        CosmoRabbitSpaceTitle(name: "Pluto", value: 0.06, valueName: "0.06 times Earth's gravity", convertFrom: "kg (Earth)", convertTo: "kg (Pluto)")
    ]),

    // 2. Distance Converter
    CosmoRabbitConverterData(title: "Distance Converter – Measuring Cosmic Journeys", space: [
        CosmoRabbitSpaceTitle(name: "1 km to AU", value: 6.68e-9, valueName: "1 km = 6.68 × 10⁻⁹ AU", convertFrom: "Kilometers (km)", convertTo: "Astronomical Units (AU)"),
        CosmoRabbitSpaceTitle(name: "1 AU in km", value: 149600000, valueName: "1 AU = 149.6 million km", convertFrom: "Astronomical Units (AU)", convertTo: "Kilometers (km)"),
        CosmoRabbitSpaceTitle(name: "1 Light-year in km", value: 9.46e12, valueName: "1 light-year = 9.46 trillion km", convertFrom: "Light-years", convertTo: "Kilometers (km)")
    ]),

    // 3. Time Converter
    CosmoRabbitConverterData(title: "Time Converter – Time Dilation Across Planets", space: [
        CosmoRabbitSpaceTitle(name: "Moon Day", value: 29.5, valueName: "1 Moon day = 29.5 Earth days", convertFrom: "Earth Days", convertTo: "Moon Days"),
        CosmoRabbitSpaceTitle(name: "Mars Day", value: 1.027, valueName: "1 Mars day = 24 hours 39 minutes", convertFrom: "Earth Days", convertTo: "Mars Days"),
        CosmoRabbitSpaceTitle(name: "Jupiter Day", value: 0.41, valueName: "1 Jupiter day = 9.93 hours", convertFrom: "Earth Days", convertTo: "Jupiter Days"),
        CosmoRabbitSpaceTitle(name: "Venus Day", value: 243, valueName: "1 Venus day = 243 Earth days", convertFrom: "Earth Days", convertTo: "Venus Days")
    ]),

    // 4. Temperature Converter
    CosmoRabbitConverterData(title: "Temperature Converter – How Cold/Hot is Space?", space: [
        CosmoRabbitSpaceTitle(name: "Sun Surface", value: 5500, valueName: "Sun's surface temperature", convertFrom: "Celsius (°C)", convertTo: "Kelvin (K)"),
        CosmoRabbitSpaceTitle(name: "Earth Avg", value: 15, valueName: "Earth’s average temperature", convertFrom: "Celsius (°C)", convertTo: "Fahrenheit (°F)"),
        CosmoRabbitSpaceTitle(name: "Pluto", value: -229, valueName: "Pluto’s average temperature", convertFrom: "Celsius (°C)", convertTo: "Kelvin (K)")
    ]),

    // 5. Speed Converter
    CosmoRabbitConverterData(title: "Speed Converter – Warp Speed Comparisons", space: [
        CosmoRabbitSpaceTitle(name: "Human Running", value: 1e-10, valueName: "10 km/h is 0.00000000003% speed of light", convertFrom: "km/h", convertTo: "Speed of Light (%)"),
        CosmoRabbitSpaceTitle(name: "ISS Speed", value: 28000, valueName: "International Space Station speed", convertFrom: "km/h", convertTo: "m/s"),
        CosmoRabbitSpaceTitle(name: "Earth Orbit Speed", value: 107000, valueName: "Earth orbits the Sun at 107,000 km/h", convertFrom: "km/h", convertTo: "miles/h"),
        CosmoRabbitSpaceTitle(name: "Speed of Light", value: 299792, valueName: "Speed of light in km/s", convertFrom: "km/s", convertTo: "miles/s")
    ]),

    // 6. Gravity Converter
    CosmoRabbitConverterData(title: "Gravity Converter – Falling in Different Worlds", space: [
        CosmoRabbitSpaceTitle(name: "Earth", value: 9.81, valueName: "Earth's gravity", convertFrom: "m/s²", convertTo: "g"),
        CosmoRabbitSpaceTitle(name: "Moon", value: 1.62, valueName: "Moon’s weaker gravity", convertFrom: "m/s²", convertTo: "g"),
        CosmoRabbitSpaceTitle(name: "Jupiter", value: 24.79, valueName: "Jupiter's strong gravity", convertFrom: "m/s²", convertTo: "g"),
        CosmoRabbitSpaceTitle(name: "Pluto", value: 0.62, valueName: "Pluto’s tiny gravity", convertFrom: "m/s²", convertTo: "g")
    ]),

    // 7. Fuel Consumption Converter
    CosmoRabbitConverterData(title: "Fuel Consumption Converter – Energy Needed for Space Travel", space: [
        CosmoRabbitSpaceTitle(name: "Gasoline Energy", value: 34.2, valueName: "1 liter of gasoline = 34.2 MJ energy", convertFrom: "Liters (L)", convertTo: "MegaJoules (MJ)"),
        CosmoRabbitSpaceTitle(name: "Saturn V Fuel Use", value: 770000, valueName: "Saturn V rocket used 770,000 liters per minute", convertFrom: "Liters/min", convertTo: "Gallons/min"),
        CosmoRabbitSpaceTitle(name: "Ion Thruster Efficiency", value: 0.9, valueName: "Ion thrusters use solar energy efficiently", convertFrom: "Electricity", convertTo: "Thrust (N)")
    ])
]
