Reports:
- I timing report si trovano in timingReports/ e quelli utili sono
  - IIRFilter_postRoute.slk
  - IIRFilter_postRoute_hold.slk
  Dall'osservazione dei timing report si nota come il timing sia corretto e non ci siano violazioni.
  Lo slack e' concorde con quanto osservato su Synopsys

- Connectivity: no problems
- Geometry: 0 violations
- Gates=1143 Cells=459 Area=912.4 um^2

Place & Route:

- open a shell
- type "source /software/scripts/init_innovus17.11"
- type "innovus -nowin"
- once innovus is opened (can require a very long time) type "source place_and_route.do"
- once finished type "exit"
