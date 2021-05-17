#include <sourcemod>
//#include <sdktools>
#include <clientprefs>
#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
	name = "Client Side Playermodel Hide",
	author = "Ice",
	description = "Fakes a cvar to clients based on .vmt ConVar proxies to hide or show models.",
	version = "1.0.0",
	url = "https://github.com/Frozen-H2O/SM-Client-Side-Hide"
};

Handle g_hidemode;
ConVar g_hidemode_cvar;
Handle g_hidedist;
ConVar g_hidedist_cvar;

public void OnPluginStart() {
	RegConsoleCmd("sm_hide", Command_Hide, "sm_hide <0|1|2> - Mode 0 - off | Mode 1 - Distance Scaling | Mode 2 - $alphatest");
	g_hidemode_cvar = CreateConVar("sm_CS_hide_mode_cvar", "bot_dont_shoot", "Cvar to fake to clients for vmt proxy's hide mode.");
	g_hidemode = RegClientCookie("sm_CS_hide_mode_cookie", "Mode for client side hiding. (0 off, non-0 on)", CookieAccess_Protected);
	
	RegConsoleCmd("sm_hidedist", Command_HideDist, "Usage: sm_hidedist <value>");
	g_hidedist_cvar = CreateConVar("sm_CS_hide_dist_cvar", "bot_difficulty", "Cvar to fake to clients for vmt proxy's hide distance.");
	g_hidedist = RegClientCookie("sm_CS_hide_dist_cookie", "Distance scaling for client side hiding. Actual cvar will be faked to 0.1% of this value, so clients can use whole numbers", CookieAccess_Protected);
}

public void OnClientCookiesCached(int client) {
	char sHideValue[32];
	GetClientCookie(client, g_hidemode, sHideValue, sizeof(sHideValue));
	char fakeCVar[128];
	g_hidemode_cvar.GetString(fakeCVar, 128);
	SendConVarValue(client, FindConVar(fakeCVar), sHideValue);
	
	char sHideDist[32];
	GetClientCookie(client, g_hidedist, sHideDist, sizeof(sHideDist));
	char fakeCVar2[128];
	g_hidedist_cvar.GetString(fakeCVar2, 128);
	SendConVarValue(client, FindConVar(fakeCVar2), sHideDist);
}

public Action Command_Hide(int client, int args) {
	if (!IsClientInGame(client)) {
		ReplyToCommand(client, "[SM] You must be in-game to use this command.");
		return Plugin_Handled;
	}
	
	if (AreClientCookiesCached(client))
	{
		char sHideValue[32];
		GetClientCookie(client, g_hidemode, sHideValue, sizeof(sHideValue));
		int hideValue = StringToInt(sHideValue);
		
		if (args < 1) { //toggle mode
			if (hideValue == 0) {
				sHideValue = "1";
				SetClientCookie(client, g_hidemode, sHideValue);
				ReplyToCommand(client, "[SM] Hide mode is enabled.");
			} else {
				sHideValue = "0";
				SetClientCookie(client, g_hidemode, sHideValue);
				ReplyToCommand(client, "[SM] Hide mode is disabled.");
			}
		} else { //set specific mode
			char hideArg[32];
			GetCmdArg(1, hideArg, sizeof(hideArg));
			int hideMode = StringToInt(hideArg);
			if (hideMode == 0) {
				sHideValue = "0";
				SetClientCookie(client, g_hidemode, sHideValue);
				ReplyToCommand(client, "[SM] Hide mode is disabled.");
			} else {
				sHideValue = "1";
				SetClientCookie(client, g_hidemode, sHideValue);
				ReplyToCommand(client, "[SM] Hide mode is enabled.");
			}
		}
		
		char fakeCVar[128];
		g_hidemode_cvar.GetString(fakeCVar, 128);
		SendConVarValue(client, FindConVar(fakeCVar), sHideValue);
		
	} else if (args < 1) {
		ReplyToCommand(client, "[SM] Your cookies are not cached. You must select a specific mode to set the hide. (0|1)");
		return Plugin_Handled;
	} else { //Set specific mode if cookies are not loaded
		char hideArg[32];
		GetCmdArg(1, hideArg, sizeof(hideArg));
		int hideMode = StringToInt(hideArg);
		char fakeCVar[128];
		g_hidemode_cvar.GetString(fakeCVar, 128);
		if (hideMode == 0) {
			SendConVarValue(client, FindConVar(fakeCVar), "0");
			ReplyToCommand(client, "[SM] Hide mode is disabled.");
		} else {
			SendConVarValue(client, FindConVar(fakeCVar), "1");
			ReplyToCommand(client, "[SM] Hide mode is enabled.");
		}
	}
	return Plugin_Handled;
}

public Action Command_HideDist(int client, int args) {
	if (!IsClientInGame(client)) {
		ReplyToCommand(client, "[SM] You must be in-game to use this command.");
		return Plugin_Handled;
	}
	if (args != 1) {
		ReplyToCommand(client, "[SM] Usage: sm_hidedist <value>");
		return Plugin_Handled;
	}
	
	char sHideDist[32];
	GetCmdArg(1, sHideDist, sizeof(sHideDist));
	float hideDist = StringToFloat(sHideDist);
	hideDist = hideDist * 0.007;
	if (hideDist < 0) {
		hideDist = 0.0;
	}
	
	FloatToString(hideDist, sHideDist, sizeof(sHideDist));
	char fakeCVar2[128];
	g_hidedist_cvar.GetString(fakeCVar2, 128);
	SendConVarValue(client, FindConVar(fakeCVar2), sHideDist);
	hideDist = hideDist / 0.007;
	ReplyToCommand(client, "[SM] Hide distance is set to %.0f", hideDist);
	if (AreClientCookiesCached(client)) {
		SetClientCookie(client, g_hidedist, sHideDist);
	}
	
	return Plugin_Handled;
}