# cc-vcs
A version control system for ComputerCraft / CCTweaked. Please pay attention to the *limitations* section for usage hints.
## Installation:
Two components are required.
### server.lua (host)
Contains the files of all applications that are to be provided. Ideally hosted on a computer with an [Ender Modem](https://tweaked.cc/peripheral/modem.html).
A certain folder structure is expected for the server architecture:

```
vcs
 | <program name...>
    | <version>
       | <files>
 | <program name...>
     | <version>
       | <files>
 | <program name...>
     | <version>
       | <files>
 | server.lua
```
### vcs.lua (client)
Usage: `vcs [program] <version>`
`version` is optional. If no version is provided, it will default to `latest`.

## Limitations
There are a few notable reasons this software might not fully work as expected. Currently, this is just a preliminary, quick-and-dirty solution to a distribution platform.
 - No folder traversal, only sending files within the `/version` folder
 - Server requires chunkloading
 - `latest` means "alphabetically last" - as such, version your files using [Semantic Versioning](https://semver.org) to keep alphanumeric consistency

 ## Roadmap
 - [ ] Recursive folder traversal
 - [ ] Auto-update client
 - [ ] API / import for other applications
 - [ ] Protocol optimization
 - [ ] Dependency management
 - [ ] Client GUI
 - [ ] Package management features