# bmicalculator_assignment

BMI Calculator – Flutter App

A modern, user-friendly BMI (Body Mass Index) Calculator built with Flutter.
Supports multiple units, smart conversions, category color badges, and beautiful Material 3 UI.

**Features
Input Units**

Weight

Kilograms (kg)

Pounds (lb)

Height

Meters (m)

Centimeters (cm)

Feet + Inches (ft + in)

**Unit Conversions**
Conversion	Formula
kg from lb	kg = lb × 0.45359237
BMI Formula
BMI = weight_kg / (height_m)^2
m from cm	m = cm / 100
m from ft+in	m = (feet × 12 + inches) × 0.0254

**Color-Coded Categories
BMI Range	Category	Color**
< 18.5	Underweight	Blue
18.5 – 24.9	Normal	Green
25.0 – 29.9	Overweight	Orange
≥ 30.0	Obese	Red
