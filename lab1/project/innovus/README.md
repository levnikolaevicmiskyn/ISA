## Place & Route:

**Synthesis is mandatory first**

open a shell and do the following:
- `$ source /software/scripts/init_innovus17.11`
- `$ innovus -nowin`
- once innovus is opened (can require a very long time)  `$ source place_and_route.do`
- once finished `$ exit`

## Verification and Power back-annotation
**Place and Route is mandatory first**

open a shell and do the following
- go in folder sim and perform a complete simulation with **post_place_route_simulate.do** as .do file
- go back in this folder
- `$ source /software/scripts/init_innovus17.11`
- `$ innovus -nowin`
- once innovus is opened (can require a very long time) type `$ source pwr_back_ann.do`
- once finished `$ exit`
