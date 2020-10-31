# Vertools - verification tools
Quick syntax:
  $ vertools --config vertools.config <command> [arguments ...]
NOTE: FOR SIMPLICITY '--config vertools.config' WILL BE OMITTED BUT IT SHOULD 
ALWAYS BE SPECIFIED

Add '--help' at any point of the command for specific help, as in:
  $ vertools --help                        # Will describe vertools command
  $ vertools generate-inputs --help        # Will describe generate-inputs 
                                           # parameters
  $ vertools generate-inputs sine --help   # Will describe sine wave parameters

Most parameters are read by default from vertools.config file, but you can 
specify your own with the appropriate flags in each command

Verification is divided in steps, here are some examples:
- Input generation
  $ vertools generate-inputs sine 64 2.5kHz 0.0 
- Simulation
  $ vertools simulate
- Reference
  $ vertools reference
- Output comparison
  $ vertools compare

You can also run an automated verification process that does all of
the above, EXCEPT FOR INPUT GENERATION that is always done manually
  $ vertools verify

