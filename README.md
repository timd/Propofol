# Propofol

This is a small iPhone app to visualise the effective concentration of Propofol based on the three-compartment Schnider model.  It was created in 24 hours at the NHS Hackday in Liverpool.

This is a very rough alpha version and should not be used in a clinical scenario unless you have a deathwish on behalf of your patient.

# App details

* Objective-C
* iOS 6.0 and above

## Third-party libraries

* CorePlot

# App structure

## Parent classes

* App delegate
* `CMBaseNavController` - subclassed `UINavigationController`
* `CMBaseViewController` - subclassed `UIViewController`

## UI classes

* `CMVitalsViewController` - subclass of `CMBaseViewController`. Captures patient vitals (height, weight, age, gender)
* `CMConcentrationViewController` - subclass of `CMBaseViewController`. Captures desired Propofol Ce value
* `CMGraphViewController` - subclass of `CMBaseViewController`. Displays main graph.

## Model classes

* `CMCalculator` - implements calculation methods:
** newPatientWithAge:andWeight:andHeight:andMale: - creates new patient
** giveDrugWithQuantity:withState: - adds drug to current patient
** waitTime:withState: - models Ce concentration based on time interval

# To do

* Implement CMCalculator as a singleton
* Store the current `state` in the CMCalculator singleton
* Reimplement automagic scrolling of the graph
* Implement user-controlled scrolling through graph history
* Link user-supplied patient vitals into calculation
* Overhaul UI so that user can set desired Ce value
* Implement alerts and reminders etc
* Etc
* Etc
* Etc
