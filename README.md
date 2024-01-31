# cc-vcs
A version control system for ComputerCraft / CCTweaked. Currently very limited in its implementation, please note the **Limitations** section.
## Installation
Two components are required.
### server.lua (host)
`wget https://raw.githubusercontent.com/ActualLily/cc-vcs/main/server.lua /vcs/server.lua`
### vcs.lua (client)
`wget https://raw.githubusercontent.com/ActualLily/cc-vcs/main/vcs.lua /vcs/vcs.lua`

## Usage
### Server
`/vcs/server.lua`

Contains the files of all applications that are to be provided. Ideally hosted on a computer with an [Ender Modem](https://tweaked.cc/peripheral/modem.html).
A certain folder structure is expected for the server architecture:

```
vcs
 | <application...>
    | <version>
       | <files>
 | <application...>
     | <version>
       | <files>
 | <application...>
     | <version>
       | <files>
 | server.lua
 ```
It is recommended to host the client in `/vcs/vcs/1.0/vcs.lua` to allow the client to pull itself and eventual latest versions.

### Client
`vcs/vcs.lua [application] (version)`
`version` is optional. If no version is provided, it will default to `latest`.

## Limitations
There are a few notable reasons this software might not fully work as expected. Currently, this is just a preliminary, quick-and-dirty solution to a distribution platform.
 - No folder traversal, only sending files within the `/version` folder
 - Server requires chunkloading
 - `latest` means "alphabetically last" - as such, version your files using [Semantic Versioning](https://semver.org) to keep alphanumeric consistency
 - Client-downloaded applications automatically are stored in system root 

 ## Roadmap
 - [ ] Recursive folder traversal
 - [ ] Auto-update client
 - [ ] API / import for other applications
 - [ ] Protocol optimization
 - [ ] Dependency management
 - [ ] Client GUI
 - [ ] Package management features
 - [ ] Configurable download directories