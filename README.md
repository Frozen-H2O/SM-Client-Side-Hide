# Client-Side Hide Sourcemod Plugin
A plugin designed to allow players to hide other playermodels for their own client without using a laggy SetTransmit plugin on the server

## Installation
All .vmt material files for playermodels that are to be affected by the plugin must have the contents of [client_side_hide.vmt](https://github.com/Frozen-H2O/SM-Client-Side-Hide/blob/master/materials/client_side_hide.vmt) pasted into them (and potentially merged with any existing proxies in the existing vmt).

## Commands
sm_hide <0|1> - Sets the hide mode to 0 (disabled) or 1 (enabled). Leave arguement empty to toggle current mode.

sm_hidedist <value> - Sets the approximate distance in units to begin to fade out the model. Negative values given will be reset to 0.

## ConVars
sm_CS_hide_mode_cvar - Cvar to fake to clients for vmt proxy's hide mode. Should be mirrored by the ConVar proxy in the vmt that feeds into $hide.

sm_CS_hide_dist_cvar - Cvar to fake to clients for vmt proxy's hide distance. Should be mirrored by the ConVar proxy in the vmt that feeds into $hide_dist.

## Fade In/Out Scale
The speed at which a model fades in and out is hard coded into the vmt and cannot be changed in-game via reading a ConVar. To change this, edit the "scale" value of the PlayerProximity proxy (higher numbers fade in quicker)