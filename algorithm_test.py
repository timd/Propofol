import pylab

def newpatient(age, weight, height, male):
  if male:
    LBM = 1.1 * weight - 128 * (weight / height) ** 2
  else:
    LBM = 1.07 * weight - 148 * (weight / height) ** 2
  V1 = 4.27
  V2 = 18.9 - 0.391 * (age - 53)
  V3 = 238
  k10 = 0.443 + 0.0107 * (weight - 77) - 0.0159 * (LBM -59) + 0.0062 * (height - 177)
  k12 = 0.302 - 0.0056 * (age - 53)
  k13 = 0.196
  k21 = (1.29 - 0.024 * (age - 53)) / (18.9 - 0.391 * (age - 53))
  k31 = 0.0035
  keo = 0.456
  TTPE = 1.69
  return {"X1": 0, "X2": 0, "X3": 0,
          "V1": V1, "V2": V2, "V3": V3,
          "k10": k10, "k12": k12, "k13": k13,
          "k21": k21, "k31": k31,
          "keo": keo}

def givedrug(x, state):
    state["X1"] = state["X1"] + x
    return state

def waittime(t, state):
    X1, X2, X3 = state["X1"], state["X2"], state["X3"]
    state["X1"] = X1 + \
                  ( state["k21"] * X2 + \
                   -state["k12"] * X1 + \
                    state["k31"] * X3 + \
                   -state["k13"] * X1 - \
                    state["keo"] * X1) * t
    state["X2"] = X2 + \
                  (-state["k21"] * X2 + \
                    state["k12"] * X1) * t
    state["X3"] = X3 + \
                  (-state["k31"] * X3 + \
                    state["k13"] * X1) * t
    return state

t = []
X1 = []
X2 = []
X3 = []

state = newpatient(30, 80, 1.90, True)
print "newpatient 30, 80, 1.90, male"
print repr(state)
state = givedrug(50, state) #initial
print "give drug: 50"
print repr(state)
state = waittime(0.1, state)
print "wait time: 0.1"
print repr(state)
state = givedrug(50, state)
print "give drug: 50"
print repr(state)

