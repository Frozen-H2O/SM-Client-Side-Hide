# Client-Side Texture Hide Sourcemod Plugin
A plugin designed to allow players to hide textures (usually of playermodels) for their own client without using a laggy SetTransmit plugin on the server

## Installation
All .vmt material files that are to be affected by the plugin must have the contents of [client_side_hide.vmt](https://github.com/Frozen-H2O/SM-Client-Side-Hide/blob/master/materials/client_side_hide.vmt) pasted into them (and potentially merged with any existing proxies in the existing vmt)

If your server uses bot_ ConVars for whatever reason, you will need to change the ConVar proxies in the vmt to ConVars your server does not use and make the relevant plugin ConVars mirror those used in the vmt

## Commands
**sm_hide** \<*value*\> - Sets the approximate distance to fully hide textures at (begin fade in). Leave value blank to toggle hide on/off

## ConVars
**sm_CS_hide_mode_cvar** \<*ConVar*\> (default: *bot_dont_shoot*) - Which cvar to fake to clients for hide mode. Should mirror the vmt's convar proxy for $hide

**sm_CS_hide_dist_cvar** \<*ConVar*\> (default: *bot_difficulty*)  - Which cvar to fake to clients for hide distance. Should mirror the vmt's convar proxy for $hide_dist

s**m_CS_hide_scale** \<*Value*\> (default: *0.007*) - Scale at which textures fade out. Should mirror the vmt's PlayerProximity proxy's scale value

## Fade In/Out Scale
The speed at which a texture fades in and out is hard coded into the vmt and cannot be changed in-game via reading a ConVar. To change this, edit the "scale" value of the PlayerProximity proxy in the vmt (higher numbers fade in quicker) and then make sm_CS_hide_scale mirror the value