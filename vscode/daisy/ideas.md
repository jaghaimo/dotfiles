# Ideas for gp_core

## Inspect solution

New entry point, load agent or population pkl and using debugger play with the solution.

## Dynamic population size

* Min and max valid agents of population (fraction of total population)
* Initial population is generated until it reaches min valid agents
* Evolution advances up to max valid (randomly) and rest of invalid (randomly)
* Lower minimal generation count (try 10 instead of 15)
