#include <sourcemod>
#include <clientprefs>
#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
	name = "Client Side Texture Hide",
	author = "Ice",
	description = "Allows for clientside texture transparency based upon vmt proxies.",
	version = "1.1.1",
	url = "https://github.com/Frozen-H2O/SM-Client-Side-Hide"
};

Handle g_hidemode;
ConVar g_hidemode_cvar;
Handle g_hidedist;
ConVar g_hidedist_cvar;
ConVar g_hideScale;

public void OnPluginStart() {
	RegConsoleCmd("sm_hide", Command_Hide, "sm_hide <value> - Sets the approximate distance to fully hide textures at (begin fade in). Leave value blank to toggle hide on/off");
	g_hidemode_cvar = CreateConVar("sm_CS_hide_mode_cvar", "bot_dont_shoot", "Which cvar to fake to clients for hide mode. Should mirror the vmt's convar proxy for $hide");
	g_hidemode = RegClientCookie("sm_CS_hide_mode_cookie", "Mode for client side hiding. (0 off, non-0 on)", CookieAccess_Protected);
	g_hidedist_cvar = CreateConVar("sm_CS_hide_dist_cvar", "bot_difficulty", "Which cvar to fake to clients for hide distance. Should mirror the vmt's convar proxy for $hide_dist");
	g_hidedist = RegClientCookie("sm_CS_hide_dist_cookie", "Distance in units * Scale to hide textures (when textures are fully invis/begin to fade in).", CookieAccess_Protected);
	g_hideScale = CreateConVar("sm_CS_hide_scale", "0.007", "Scale at which textures fade out. Should mirror the vmt's PlayerProximity proxy's scale value");
}

public void OnClientCookiesCached(int client) {
	char sHideValue[32];
	GetClientCookie(client, g_hidemode, sHideValue, sizeof(sHideValue));
	char fakeCVar[32];
	g_hidemode_cvar.GetString(fakeCVar, 32);
	SendConVarValue(client, FindConVar(fakeCVar), sHideValue);
	
	char sHideDist[32];
	GetClientCookie(client, g_hidedist, sHideDist, sizeof(sHideDist));
	char fakeCVar2[32];
	g_hidedist_cvar.GetString(fakeCVar2, 32);
	SendConVarValue(client, FindConVar(fakeCVar2), sHideDist);
}

public Action Command_Hide(int client, int args) {
	if (!IsClientInGame(client)) {
		ReplyToCommand(client, "[SM] You must be in-game to use this command.");
		return Plugin_Handled;
	}

	if (args > 1) {
		ReplyToCommand(client, "[SM] Usage: sm_hide <value>");
	} else if (args == 1) { //set hide distance and enable hide mode if non-negative value. Disable if negative value.
		char sHideDist[32];
		GetCmdArg(1, sHideDist, sizeof(sHideDist));
		char hideScale[32];
		g_hideScale.GetString(hideScale, 32);
		float hideDist = StringToFloat(sHideDist) * StringToFloat(hideScale);

		char fakeCVar[32];
		g_hidemode_cvar.GetString(fakeCVar, 32);
		if (hideDist < 0) {
			SendConVarValue(client, FindConVar(fakeCVar), "0");
			SetClientCookie(client, g_hidemode, "0");
			ReplyToCommand(client, "[SM] Hide mode is disabled.");
			return Plugin_Handled;
		}
		SendConVarValue(client, FindConVar(fakeCVar), "1");
		SetClientCookie(client, g_hidemode, "1");

		FloatToString(hideDist, sHideDist, sizeof(sHideDist));
		char fakeCVar2[32];
		g_hidedist_cvar.GetString(fakeCVar2, 32);
		SendConVarValue(client, FindConVar(fakeCVar2), sHideDist);
		SetClientCookie(client, g_hidedist, sHideDist);

		ReplyToCommand(client, "[SM] Hide distance is set to %.0f", (hideDist / StringToFloat(hideScale)));
	} else if (!AreClientCookiesCached(client)) { //toggle hide mode
		ReplyToCommand(client, "[SM] Your cookies are not cached, so you cannot toggle the mode currently. You may still set a specific distance.");
	} else { //toggle hide mode on/off
		char sHideValue[32];
		GetClientCookie(client, g_hidemode, sHideValue, sizeof(sHideValue));
		int hideValue = StringToInt(sHideValue);

		if (hideValue == 0) {
			sHideValue = "1";
			ReplyToCommand(client, "[SM] Hide mode is enabled.");
		} else {
			sHideValue = "0";
			ReplyToCommand(client, "[SM] Hide mode is disabled.");
		}

		char fakeCVar[32];
		g_hidemode_cvar.GetString(fakeCVar, 32);
		SendConVarValue(client, FindConVar(fakeCVar), sHideValue);
		SetClientCookie(client, g_hidemode, sHideValue);
	}
	return Plugin_Handled;
}