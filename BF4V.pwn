//© 2014 Moustafa Elsisy, All Rights Reserved

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <flares>
#include <mapandreas>
#include <dini>
#include <a_mysql>

#undef MAX_PLAYERS
#define MAX_PLAYERS 30
#define MAX_TEAM_PLAYERS 8

//MySQL Connection defines
#define host "-"
#define user "-"
#define pass "-"
#define DB "-"

//Current # Of Dialogs = 22.

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Battlefield 4 Vengeance SAMP Gamemode, © 2014 Moustafa Elsisy, All Rights Reserved");
	print("----------------------------------\n");
}

#endif
native WP_Hash(buffer[], len, const str[]);
//-----------------NEW Variables-----------------------//
new mysqldb;
new magdifference[MAX_PLAYERS][4];
new Weapon[MAX_PLAYERS char];
new M320g[MAX_PLAYERS];
new LoginAttempts[MAX_PLAYERS char];
new Logged[MAX_PLAYERS char];
new DSP[MAX_PLAYERS char];
new TeamTime[MAX_PLAYERS];
new ClassTime[MAX_PLAYERS];
//new TanksOccupied;
//new Spawned[MAX_PLAYERS];
new VIPattachpickup;
new VIPsetpickup;
new VIPtoclubpickup;
new USTB1;  // US Thunderbolt
new USTB2;
new USMSAM; // US Mobile SAM
new USMRL;  // US Mobile Rocket Launcher
new USmovinggate1;
new USmovinggate2;
new USTBM1; // US Thunderbolt Missile
new USTBM2;
new USTBM3;
new USTBM4;
new USMSAMM; // US Mobile SAM Missile
new USMRLM1; // US Mobile Rocket Launcher Missile
new USMRLM2;
new USMRLM3;
new USMRLM4;
new USMRLM5;
new USMRLM6;
new USMRLM7;
new USMRLM8;
new USMRLH1; // US Mobile Rocket Launcher Holder
new USMRLH2;
new Bomb1[9]; //Bombs
new Bomb2[9];
new EUTB1;
new EUTB2;
new EUMSAM;
new EUMRL;
new EUmovinggate;
new EUTBM1;
new EUTBM2;
new EUTBM3;
new EUTBM4;
new EUMSAMM;
new EUMRLM1;
new EUMRLM2;
new EUMRLM3;
new EUMRLM4;
new EUMRLM5;
new EUMRLM6;
new EUMRLM7;
new EUMRLM8;
new EUMRLH1;
new EUMRLH2;
new INTB1;
new INTB2;
new INTBM1;
new INTBM2;
new INTBM3;
new INTBM4;
new INMSAM;
new INMRL;
new INMSAMM;
new INMRLM1;
new INMRLM2;
new INMRLM3;
new INMRLM4;
new INMRLM5;
new INMRLM6;
new INMRLM7;
new INMRLM8;
new INMRLH1;
new INMRLH2;
new INmovinggate1;
new INmovinggate2;
new RUTB1;
new RUTB2;
new RUMSAM;
new RUMRL;
new RUTBM1;
new RUTBM2;
new RUTBM3;
new RUTBM4;
new RUMSAMM;
new RUMRLM1;
new RUMRLM2;
new RUMRLM3;
new RUMRLM4;
new RUMRLM5;
new RUMRLM6;
new RUMRLM7;
new RUMRLM8;
new RUMRLH1;
new RUMRLH2;
new Czone[MAX_PLAYERS];
new zTimer[17];
new zSetter[17];
new NukeTime[4];
new JamTime[4];
new Tplayers[4][MAX_TEAM_PLAYERS];
new CapturingPlayers[17];
new RAC[MAX_PLAYERS char];
new Jamcoms[MAX_PLAYERS char];
new MRLrocket[17][5];
new MRLParticle[17];
new Float:MRLrocketD[5][6] = {
	{-0.3, -0.6, 5.0, 0.0, -60.0, -90.0},
	{0.3, -0.6, 5.0, 0.0, -60.0, -90.0},
	{0.0, 0.9, 5.0, 0.0, -60.0, -90.0},
	{-0.3, 1.6, 5.0, 0.0, -60.0, -90.0},
	{0.3, 1.6, 5.0, 0.0, -60.0, -90.0}
};
new Tcolor[4] = {
    0x0000E1FF,
    0x00E100FF,
    0xEC8D00FF,
    0xF00006FF
};
new PlayerText:Cdraw[MAX_PLAYERS];
new PlayerText:Magdraw[MAX_PLAYERS];
new PlayerText:Ammodraw[MAX_PLAYERS];
new PlayerText:Hdraw[MAX_PLAYERS];
new PlayerText:Armrdraw[MAX_PLAYERS];
new Text:HUDbg;
new PlayerText:Wstate[MAX_PLAYERS];
new PlayerText:Rankdraw[MAX_PLAYERS];
new PlayerText:Scoredraw[MAX_PLAYERS];
new PlayerText:Mainreward[MAX_PLAYERS];
new PlayerText:Secondaryreward[MAX_PLAYERS];
new PlayerText:Spawnclass[MAX_PLAYERS];
new PlayerText:SpawnNotice[MAX_PLAYERS];
new PlayerText:ClassStats[MAX_PLAYERS];
new Text:DeployButton;
new Text:Logodraw;
new Text:Spawnbg;
new Text:Teamdraw;
new Text:Teambutton[4];
new Text:Deploydraw;
new Text:Deploydrawbg;
new Text:Basebox;
new Text:BaseDepdraw;
new Text:BaseDepdrawbg;
new Text:DeployAsdraw;
new Text:SnipeIcon;
new Text:Classicon[8]; //ASSAULT[0]-MEDIC[1]-SNIPER[2]-ENGINEER[3]-SUPPORT[4]-AIRFORCE[5]-CQ[6]-VIP[7]
new Text:ClassStatsbg;
//new Text:SAmap;
//new Text:SAmap1;
new Rewardtime[MAX_PLAYERS];
new RUmovinggate;
new SAMMissile[13];
new gTeam[MAX_PLAYERS];
new Pclass[MAX_PLAYERS];
new OutOfBombs[9];
new RocketsReload[17];
new hTimer[MAX_PLAYERS];
new rTimer[MAX_PLAYERS];
new zFlag[13];
new cTime[17];
new ractime[MAX_PLAYERS];
new Text3D:Labels[MAX_PLAYERS];
new bool:MSAMfired[MAX_PLAYERS];
//------------END of NEW Terms--------------------//

//-----------------DEFINES-----------------------//
#define HOLDING(%0) \
		((newkeys & (%0)) == (%0))
#define TEAM_US 0
#define TEAM_EU 1
#define TEAM_IN 2
#define TEAM_RU 3
#define TEAM_NULL 4

#define ASSAULT_CLASS 0
#define MEDIC_CLASS 1
#define SNIPER_CLASS 2
#define ENGINEER_CLASS 3
#define SUPPORT_CLASS 4
#define AIRFORCE_CLASS 5
#define CQ_CLASS 6
#define VIP_CLASS 7

#define COLOUR_RED 0xC40000FF
#define COLOUR_GREEN 0x228800FF
#define COLOUR_GREY 0x535353FF
//---------------End of DEFINES------------------//

//------------------Global Floats-----------------//
new Float:USMX[13], Float:USMY[13], Float:USMZ[13];
new Float:gMapX[17][5], Float:gMapY[17][5];
//------------------End of Global Floats----------//
//---------------------ENUMs--------------------//
	enum eZone
	{
    	Float:zMinX,
    	Float:zMinY,
    	Float:zMaxX,
    	Float:zMaxY,
    	zTeam,
    	bool:attacked,
    	zName[30],
    	zTime,
    	Playersreq
	}
	new ZoneInfo[][eZone] = {
    	{-18.7906,1646.6344,422.7896,2134.7302,TEAM_US, false, "US Base", 0, 1000}, // US Base
    	{-1678.5007,1553.4496,-1205.9125,1687.9232, TEAM_EU, false, "Europe's Base",0, 1000}, // EU Base
	 	{-322.9263,2543.1665,-133.0124,2802.6052, TEAM_IN, false, "India's Base", 0, 1000}, // IN Base
	 	{752.3703,2062.5356,894.5995,2284.8674, TEAM_RU, false, "Russia's Base", 0, 1000}, // RU Base
	 	{-111.8066,1336.6687,-70.8306,1382.3855, TEAM_NULL, false, "Lil Probe Inn", 30000, 1}, // Lil Probe Inn
	 	{-590.5292,2528.8081,-502.3170,2641.4363, TEAM_NULL, false, "Bone County Station", 40000, 2}, // Bone County Station
	 	{-891.0732,2737.2122,-715.7129,2768.7021, TEAM_NULL, false, "Valle Ocultado", 40000, 2}, // Valle Ocultado
	 	{107.4610,1331.8864,291.5591,1488.9341, TEAM_NULL, false, "Green Palms Factory", 75000, 5}, // Green Palms Factory
	 	{-1620.9929,2534.7827,-1398.6079,2711.8704, TEAM_NULL, false, "ElQuabrados", 75000, 4}, // ElQuabrados
	 	{-83.7970,2409.7139,444.7785,2561.3286, TEAM_NULL, false, "Verdant Meadows AA", 60000, 5}, // Verdant Meadows AA
	 	{-897.6606,1421.4849,-747.2950,1623.0610, TEAM_NULL, false, "Las Barrancas", 100000, 3}, // Las Barrancas
	 	{983.6252,936.5971,1166.3263,1180.1969, TEAM_NULL, false, "Green Glass College", 90000, 4}, // Green Glass College
	 	{527.9615,809.3765, 732.9948,950.3103, TEAM_NULL, false, "The Quarry", 90000, 4}, // The Quarry
	 	{-437.0929,1497.8580,-253.5117,1658.1324, TEAM_NULL, false, "The Big Ear", 120000, 5}, // Big Ear
	 	{-716.7639,920.2578,-653.9368,991.5058, TEAM_NULL, false, "Torreno's House", 50000, 1}, // Torreno's House
	 	{901.7679, 2626.2410,1173.1858, 2756.0364, TEAM_NULL, false, "The Nuclear Silo Station", 90000, 5}, // Nuclear Silo Launch Station
	 	{1016.9573,1382.1545,1180.3448,1731.1731, TEAM_NULL, false, "LV Stadium", 90000, 4} // LV Stadium
	};
	new ZoneID[sizeof(ZoneInfo)];
	enum pInfo
	{
	    Score,
	    Kills,
	    Deaths,
	    Captures,
	    RankID,
	    Capzone,
	    Adminlevel,
	    bool:muted,
	    bool:jammed,
	    bool:pmreject,
	    bool:pjammed,
	    lastpm,
	    Tokens,
	    dbID
	};
	new Playerinfo[MAX_PLAYERS][pInfo];
	enum Tinfo
	{
	    Skin,
	    Float:TX,
	    Float:TY,
		Float:TZ,
		Float:TAngle
	};
	new Teaminfo[5][Tinfo] = {
	    {287,213.2123,1901.6510,17.6406,357.1272},
		{285, -1320.3314,1631.3756,8.2108,99.5769},
		{28, -253.0346,2604.8044,62.8582,4.0331},	
		{124, 851.9859,2137.7310,10.8203,269.3957},
		{0, 762.6925,-3289.8040,639.3107, 179.4891}
	};
//------------------End of ENUMs-----------------//
//--------------New Functions---------------------//
forward SetPlayerTeamFromClass(playerid, classid);
forward closeUSgate1();
forward closeUSgate2();
forward SAMRespawner();
forward Explosion(playerid);
forward MRLredirect(playerid, vehicleid);
forward DestroyMRL(playerid, vehicleid);
forward closeEUgate();
forward closeINgate1();
forward closeINgate2();
forward closeRUgate();
forward SAMMissileExplode(playerid, tvehicleid);
forward GivePlayerPack(playerid, Pclass[MAX_PLAYERS]);
forward SetGangZoneTeam(playerid);
forward ZoneTimer(playerid);
forward pKick(tid);
forward pBan(tid, reason[]);
forward Unmute(targetid);
forward JamStop(Team);
forward CameraSceneForPlayer(playerid);
forward Rewardhide(playerid);
forward SpectateDebug(playerid);
forward M320gexplosion(playerid);

//MySQL Threads
forward OnAccountSearch(playerid);
forward OnAccountRegister(playerid);
forward OnPlayerAttemptLogin(playerid, inputtext[]);
forward OnAccountSaveStats(playerid, viplevel);
forward OnAccountVIPcheck(playerid);
forward OnVIPObjectsRetrieval(playerid);
forward OnReferredCheck(playerid, path[], params[]);
forward OnPlayerRequestNewUsername(playerid, inputpassword[]);
forward OnPlayerRequestNewPass(playerid, newpassword[]);

stock GetWeaponNameEx(weapon)
{
	new WeaponName[8];
	switch(weapon)
	{
	    case 0: WeaponName = "Melee";
	    case 24: WeaponName = "D-Eagle";
	    case 31: WeaponName = "M4A1";
	    case 34: WeaponName = "Sniper";
	    case 29: WeaponName = "MP5";
	    case 27: WeaponName = "SPAS-12";
	    case 36: WeaponName = "HRPG";
	    case 46: WeaponName = "Para";
	    default: WeaponName = "----";
	}
	return WeaponName;
}

stock GetVIPRank(VIPRankID)
{
	new Type[7];
	switch(VIPRankID)
	{
	    case 1: Type = "Bronze";
	    case 2: Type = "Silver";
	    case 3: Type = "Gold";
	}
	return Type;
}

stock SlotIO(playerid, index)
{
	new Status[7];
	if(index == 0 || index == 1 || index == 2) Status = "LOCKED";
	else if(IsPlayerAttachedObjectSlotUsed(playerid, index)) Status= "USED";
	else Status = "FREE";
	return Status;
}

stock GetWeaponSlot(weaponid)
{
	switch(weaponid)
	{
	    case 0: return 0;
	    case 24: return 1;
	    case 31: return 2;
	    case 34: return 2;
	    case 29: return 3;
	    case 27: return 2;
	    case 36: return 3;
	    case 46: return 3;
	    default: return 0;
	}
	return 0;
}

stock GetWeaponMag(weaponid)
{
	switch(weaponid)
	{
	    case 24: return 7;
	    case 31: return 50;
	    case 29: return 30;
	    case 27: return 7;
	    case 34: return 1;
	    case 36: return 1;
	    default: return 1;
	}
	return -1;
}

stock GetSniperColor(sTeam)
{
	switch(sTeam)
	{
	    case 0: return 0x0000EC00;
	    case 1: return 0x00E80000;
	    case 2: return 0xEC8D0000;
	    case 3: return 0xF0000600;
	}
	return -1;
}

public SpectateDebug(playerid)
{
    SetPlayerCameraPos(playerid, 285.5769,1840.7185,65.6286), SetPlayerCameraLookAt(playerid,210.5712,1913.9818,17.6406), SetPlayerPos(playerid, 210.5712,1913.9818,16.6406);
}

public Rewardhide(playerid)
{
	PlayerTextDrawHide(playerid, Mainreward[playerid]);
	PlayerTextDrawHide(playerid, Secondaryreward[playerid]);
}

public M320gexplosion(playerid)
{
	new Float:X, Float:Y, Float:Z;
	GetObjectPos(M320g[playerid], X, Y, Z);
	CreateExplosion(X, Y, Z, 10, 10);
	DestroyObject(M320g[playerid]);
	/*new Team = gTeam[playerid];
	new Float:th;
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(gTeam[i] != Team)
	        {
	            if(IsPlayerInRangeOfPoint(playerid, 5, X, Y, Z))
	            {
				 	GetPlayerHealth(playerid, th);
				 	if(th <= 0.0)
				 	{
				 	
				 	}
	            }
	        }
	    }
	}*/
}

public CameraSceneForPlayer(playerid)
{
    InterpolateCameraPos(playerid, 306.3605,1226.6588,89.6017, 768.4160,2616.3989,102.2115, 60000, CAMERA_MOVE);
	PlayAudioStreamForPlayer(playerid, "http://k007.kiwi6.com/hotlink/i7p49fjys4/BF4-Theme4Serve.mp3", 0,0,0,0,0);
	SendClientMessage(playerid, 0xFFFFFFFF,"Welcome to {0072CE}[TDM]BattleField 4 Vengeance[0.3z]{FFFFFF}!");
	new query[130];
	GetPlayerName(playerid, query, sizeof(query));
	mysql_format(mysqldb, query, sizeof(query),"SELECT ID FROM SRVRPlayers WHERE Username = '%e' LIMIT 1", query);
	mysql_tquery(mysqldb, query, "OnAccountSearch", "i", playerid);
	return 1;
}

public SetPlayerTeamFromClass(playerid, classid)
{
 	if(classid == 0)
 	{
    	gTeam[playerid] = TEAM_US;
 	}
 	if(classid == 1)
 	{
 	    gTeam[playerid] = TEAM_EU;
	}
	if(classid == 2)
	{
	    gTeam[playerid] = TEAM_IN;
	}
	if(classid == 3)
	{
	    gTeam[playerid] = TEAM_RU;
	}
}

public closeUSgate1()
{
	MoveObject(USmovinggate1,96.4000015,2059.9599609,16.7999992, 7,0,0, 90);
	return 1;
}
public closeUSgate2()
{
	MoveObject(USmovinggate2, 96.3994141,2073.4599609,16.7999992, 7,0,0, 90);
	return 1;
}
public closeEUgate()
{
	MoveObject(EUmovinggate, -1608.3994141,1743.7998047,10.3000002, 7,0.0000000,0.0000000,119.9981689);
	return 1;
}
public closeINgate1()
{
	MoveObject(INmovinggate1, -380.6000061,2694.1999512,63.9000053,7,0,0,209.9981689);
	return 1;
}
public closeINgate2()
{
	MoveObject(INmovinggate2, -143.5000000,2633.3000488,63.7599983,7,0,0,90);
	return 1;
}
public closeRUgate()
{
	MoveObject(RUmovinggate, 765.9000200,2288.8999000,11.1000000,7,0,0,140);
	return 1;
}
public SAMRespawner()
{
	    new Float:X, Float:Y, Float:Z;
	    GetObjectPos(USMSAMM, X, Y, Z);
		if(X != 118.1999969 && Y != 2021.4000000 && Z != 18.6999996)
		{
		    USMSAMM = CreateObject(3884,109.1999969,2954.5000000,10.3999996,0.0000000,0.0000000,0.0000000);
		    AttachObjectToVehicle(USMSAMM, USMSAM, 0,-0.1,-0.7, 0,0, 270);
		}

}
public Explosion(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new Float:X1[9], Float:Y1[9], Float:Z1[9], Float:X2[9], Float:Y2[9], Float:Z2[9];
	GetObjectPos(Bomb1[vehicleid], X1[vehicleid], Y1[vehicleid], Z1[vehicleid]);
	GetObjectPos(Bomb2[vehicleid], X2[vehicleid], Y2[vehicleid], Z2[vehicleid]);
	CreateExplosion(X1[vehicleid], Y1[vehicleid], Z1[vehicleid], 7, 40);
	CreateExplosion(X2[vehicleid], Y2[vehicleid], Z2[vehicleid], 7, 40);
	DestroyObject(Bomb1[vehicleid]);
	DestroyObject(Bomb2[vehicleid]);
	new Team = gTeam[playerid];
	for(new i = 0;i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerInRangeOfPoint(i, 20, X1[vehicleid], Y1[vehicleid], Z1[vehicleid]))
	    {
	        if(gTeam[i] != Team)
	        {
	            new string[50];
	            Playerinfo[playerid][Score] += 5;
	            Playerinfo[playerid][Kills] += 1;
	            Playerinfo[playerid][Tokens] += 1;
				SetPlayerScore(playerid, Playerinfo[playerid][Score]);
				SetPlayerRankFromScore(playerid, Playerinfo[playerid][Score]);
				Update3DTextLabelText(Labels[playerid], 0xD7D7D7FF, GetRankNameFromID(Playerinfo[playerid][RankID]));
				PlayerTextDrawSetString(playerid, Rankdraw[playerid], GetRankNameFromID(Playerinfo[playerid][RankID]));
				format(string, sizeof(string),"Score: %d~n~BattlePoints: %d", Playerinfo[playerid][Score], Playerinfo[playerid][Tokens]);
				PlayerTextDrawSetString(playerid, Scoredraw[playerid], string);
				PlayerTextDrawSetString(playerid, Mainreward[playerid], "Bomb  Kill    5XP  1BP");
				PlayerTextDrawShow(playerid, Mainreward[playerid]);
				Rewardtime[playerid] = SetTimerEx("Rewardhide", 2000, 0, "i", playerid);
			}
		}
	}
}
public GivePlayerPack(playerid, Pclass[MAX_PLAYERS])
{
	switch(Pclass[playerid])
	{
	    case 0:
	    {
	        GivePlayerWeapon(playerid, 24, 63);
 			GivePlayerWeapon(playerid, 29, 270);
  			GivePlayerWeapon(playerid, 31, 300);
		}
		case 3:
		{
 			GivePlayerWeapon(playerid, 24, 63);
 			GivePlayerWeapon(playerid, 31, 270);
  			GivePlayerWeapon(playerid, 36, 5);
		}
		case 4:
		{
		   	GivePlayerWeapon(playerid, 29, 400);
			GivePlayerWeapon(playerid, 31, 390);
		}
		case 6:
		{
		    GivePlayerWeapon(playerid, 24, 63);
		    GivePlayerWeapon(playerid, 27, 56);
		}
		case 1:
		{
 			GivePlayerWeapon(playerid, 24,63);
 			GivePlayerWeapon(playerid, 31, 300);
		}
		case 5:
		{
 			GivePlayerWeapon(playerid, 24, 63);
			GivePlayerWeapon(playerid, 46, 1);
		}
		case 2:
		{
 			GivePlayerWeapon(playerid, 24, 63);
			GivePlayerWeapon(playerid, 34, 120);
			SetPlayerColor(playerid, GetSniperColor(gTeam[playerid]));
			RemovePlayerAttachedObject(playerid, 0);
		}
		case 7:
		{
		    GivePlayerWeapon(playerid, 31, 300);
		    GivePlayerWeapon(playerid, 29, 270);
		    GivePlayerWeapon(playerid, 24, 49);
			SetPVarInt(playerid,"M320gammo", 5);
			SetPVarInt(playerid, "DeagleUse", 1);
			SetPlayerAttachedObject(playerid, 2, 348, 6, -0.006, -0.003, -0.01, 0, 0, 0, 1.024, 1.125, 1.1, 0xFFCAAC00);
		}
	}
}
public SAMMissileExplode(playerid, tvehicleid)
{
	new Float: SAMx[13], Float: SAMy[13], Float:SAMz[13];
	new vehicleid = GetPlayerVehicleID(playerid);
	GetObjectPos(SAMMissile[vehicleid], SAMx[vehicleid], SAMy[vehicleid], SAMz[vehicleid]);
	if(SAMx[vehicleid] == USMX[vehicleid] && SAMy[vehicleid] == USMY[vehicleid] && SAMz[vehicleid] == USMZ[vehicleid])
	{
	    new Float:X, Float:Y, Float:Z;
	 	CreateExplosion(USMX[vehicleid], USMY[vehicleid], USMZ[vehicleid], 7, 40);
	 	GetVehiclePos(tvehicleid, X, Y, Z);
	 	DestroyObject(SAMMissile[vehicleid]);
	 	MSAMfired[playerid] = false;
		if((USMX[vehicleid] - X) < 20 && (USMX[vehicleid] - X) > -20 && (USMY[vehicleid] - Y) < 20 && (USMY[vehicleid] - Y) > -20 && (USMZ[vehicleid] - Z) < 20 && (USMZ[vehicleid] - Z) > -20)
		{
		    new string[50];
		    Playerinfo[playerid][Score] += 10;
		    SetPlayerScore(playerid, Playerinfo[playerid][Score]);
		    SetPlayerRankFromScore(playerid, Playerinfo[playerid][Score]);
			Update3DTextLabelText(Labels[playerid], 0xD7D7D7FF, GetRankNameFromID(Playerinfo[playerid][RankID]));
			PlayerTextDrawSetString(playerid, Rankdraw[playerid], GetRankNameFromID(Playerinfo[playerid][RankID]));
			format(string, sizeof(string),"Score: %d~n~BattlePoints: %d", Playerinfo[playerid][Score], Playerinfo[playerid][Tokens]);
			PlayerTextDrawSetString(playerid, Scoredraw[playerid], string);
		    SendClientMessage(playerid, 0x007D03FF, "Aircraft takedown: +10 XP");
		    PlayerTextDrawSetString(playerid, Mainreward[playerid], "Aircraft  Takedown    10XP");
		    PlayerTextDrawShow(playerid, Mainreward[playerid]);
		    Rewardtime[playerid] = SetTimerEx("Rewardhide", 2000, 0, "i", playerid);
		}
	}
	else
	{
		SetTimerEx("SAMMissileExplode", 400, 0, "ii", playerid, tvehicleid);
	}
}
public MRLredirect(playerid, vehicleid)
{
	new Float:Dz[17][5];
	for(new i=0; i < 5; i++)
	{
		    SetObjectRot(MRLrocket[vehicleid][i],0, -90, 0);
		    MapAndreas_FindZ_For2DCoord(gMapX[vehicleid][i], gMapY[vehicleid][i], Dz[vehicleid][i]);
		    MoveObject(MRLrocket[vehicleid][i], gMapX[vehicleid][i], gMapY[vehicleid][i], Dz[vehicleid][i], 120, 0, -90, 0);
		    CreateExplosion(gMapX[vehicleid][i], gMapY[vehicleid][i], Dz[vehicleid][i], 7, 40);
	}
	new Team = gTeam[playerid];
	for(new i = 0;i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerInRangeOfPoint(i, 25, gMapX[vehicleid][3], gMapY[vehicleid][3], Dz[vehicleid][3]))
	    {
	        if(gTeam[i] != Team)
	        {
	            new string[50];
	            Playerinfo[playerid][Score] += 1;
				SetPlayerScore(playerid, Playerinfo[playerid][Score]);
				SetPlayerRankFromScore(playerid, Playerinfo[playerid][Score]);
				Update3DTextLabelText(Labels[playerid], 0xD7D7D7FF, GetRankNameFromID(Playerinfo[playerid][RankID]));
				PlayerTextDrawSetString(playerid, Rankdraw[playerid], GetRankNameFromID(Playerinfo[playerid][RankID]));
				format(string, sizeof(string),"Score: %d~n~BattlePoints: %d", Playerinfo[playerid][Score], Playerinfo[playerid][Tokens]);
				PlayerTextDrawSetString(playerid, Scoredraw[playerid], string);
				SendClientMessage(playerid, COLOUR_GREEN,"Rocket hit: +1XP");
			}
		}
	}
	SetTimerEx("DestroyMRL", 1000, 0, "ii", playerid, vehicleid);
}
public DestroyMRL(playerid, vehicleid)
{
	for(new i=0; i < 5; i++)
	{
        DestroyObject(MRLrocket[vehicleid][i]);
        DestroyObject(MRLParticle[vehicleid]);
	}
}
stock GetTeamFlagColor(fTeam)
{
	switch(fTeam)
	{
		case TEAM_US: return 0xFF0F2DFF;
		case TEAM_EU: return 0xFF1A7D00;
		case TEAM_IN: return 0xFFD23F00;
		case TEAM_RU: return 0xFF950000;
		case TEAM_NULL: return 0xFF4A4A4A;
	}
	return -1;
}
stock GetTeamZoneColor(teamid)
{
    switch(teamid)
    {
        case TEAM_US: return 0x0000ECAA;
        case TEAM_EU: return 0x00E800AA;
        case TEAM_IN: return 0xEC8D00AA;
        case TEAM_RU: return 0xF00006AA;
        case TEAM_NULL: return 0x4D4D4DAA;
    }
    return -1;
}
stock GetTeamName(pTeam)
{
	new Tname[20];
	switch(pTeam)
	{
		case 0: Tname = "The United States";
		case 1: Tname = "Europe";
		case 2: Tname = "India";
		case 3: Tname = "Russia";
	}
	return Tname;
}
stock SetPlayerRankFromScore(playerid, pScore)
{
	switch(pScore)
	{
	    case 0 .. 49: Playerinfo[playerid][RankID] = 0;
		case 50 .. 149: Playerinfo[playerid][RankID] = 1;
		case 150 .. 349: Playerinfo[playerid][RankID] = 2;
		case 350 .. 699:  Playerinfo[playerid][RankID] = 3;
		case 700 .. 1399: Playerinfo[playerid][RankID] = 4;
		case 1400 .. 2199: Playerinfo[playerid][RankID] = 5;
		case 2200 .. 3399: Playerinfo[playerid][RankID] = 6;
		case 3400 .. 4799: Playerinfo[playerid][RankID] = 7;
		case 4800 .. 5999: Playerinfo[playerid][RankID] = 8;
		case 6000 .. 7749: Playerinfo[playerid][RankID] = 9;
		case 7750 .. 9999: Playerinfo[playerid][RankID] = 10;
		case 10000 .. 12999: Playerinfo[playerid][RankID] = 11;
		case 13000 .. 15999: Playerinfo[playerid][RankID] = 12;
		case 16000 .. 19999: Playerinfo[playerid][RankID] = 13;
  		default: Playerinfo[playerid][RankID] = 14;
	}
}
stock GetRankNameFromID(pRankID)
{
 	new RankName[30];
 	switch (pRankID)
 	{
 	    case 0: RankName = "Private";
 	    case 1: RankName = "Private 1st Class";
 	    case 2: RankName = "Corporal";
 	    case 3: RankName = "Sergeant";
 	    case 4: RankName = "Sergeant 1st Class";
 	    case 5: RankName = "Master Sergeant";
 	    case 6: RankName = "Sergeant Major";
 	    case 7: RankName = "Lieutenant";
 	    case 8: RankName = "Captain";
 	    case 9: RankName = "Major";
 	    case 10: RankName = "Colonel";
 	    case 11: RankName = "Brigadier General";
 	    case 12: RankName = "Major General";
 	    case 13: RankName = "Lieutenant General";
	  	case 14: RankName = "General";
	}
	return RankName;
}
stock RejectClass(playerid)
{
    SendClientMessage(playerid, 0xD70000FF, "Your rank does not permit you to use this class");
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_LIST, "Choose Class", "Assault \n Medic \n Engineer \n Support \n Sniper \n Airforce \n Close Quarters", "Choose", "");
	ResetPlayerWeapons(playerid);
}
public SetGangZoneTeam(playerid)
{
	new Zone = Czone[playerid];
	KillTimer(zTimer[Zone]);
	ZoneInfo[Zone][zTeam] = gTeam[playerid];
 	new string[3];
  	format(string, sizeof(string),"%d",Zone);
   	dini_IntSet("zones.ini", string, gTeam[playerid]);
	GangZoneStopFlashForAll(ZoneID[Zone]);
	GangZoneShowForAll(ZoneID[Zone], GetTeamZoneColor(ZoneInfo[Zone][zTeam]));
	ZoneInfo[Zone][attacked] = false;
	SetObjectMaterial(zFlag[Zone-4], 1, -1, "none", "none", GetTeamFlagColor(gTeam[playerid]));
	SetObjectMaterial(zFlag[Zone-4], 2, -1, "none", "none", GetTeamFlagColor(gTeam[playerid]));
	CapturingPlayers[Zone] = 0;
	new string2[150];
	format(string2,sizeof(string2),"~r~%s has been successfully captured by %s", ZoneInfo[Zone][zName], GetTeamName(gTeam[playerid]));
	GameTextForAll(string2, 4000, 4);
	new string3[50];
	format(string3, sizeof(string3), "Area Captured     %d XP", (ZoneInfo[Zone][Playersreq]*10)+10);
	for(new i = 0; i < MAX_TEAM_PLAYERS; i++)
	{
	    new mateid = Tplayers[gTeam[playerid]][i];
	    if(Playerinfo[mateid][Capzone] == Zone)
	    {
	        new string4[50];
	        SetPlayerWorldBounds(mateid, 20000,-20000,20000,-20000);
 	        PlayerTextDrawSetString(mateid, Mainreward[mateid], string3);
 	        PlayerTextDrawShow(mateid, Mainreward[mateid]);
 	        SetPlayerWorldBounds(mateid, 20000,-20000,20000,-20000);
	        Playerinfo[mateid][Captures] += 1;
	        Playerinfo[mateid][Score] += (ZoneInfo[Zone][Playersreq]*10)+10;
	        SetPlayerScore(mateid, Playerinfo[mateid][Score]);
	        SetPlayerRankFromScore(mateid, Playerinfo[mateid][Score]);
			Update3DTextLabelText(Labels[mateid], 0xD7D7D7FF, GetRankNameFromID(Playerinfo[mateid][RankID]));
	        PlayerTextDrawHide(mateid, Cdraw[mateid]);
	        Playerinfo[mateid][Capzone] = 0;
	        SetPlayerWorldBounds(mateid, 20000,-20000,20000,-20000);
	        PlayerTextDrawSetString(mateid, Rankdraw[mateid], GetRankNameFromID(Playerinfo[mateid][RankID]));
	        format(string4, sizeof(string4),"Score: %d~n~BattlePoints: %d", Playerinfo[mateid][Score], Playerinfo[mateid][Tokens]);
	        PlayerTextDrawSetString(mateid, Scoredraw[mateid], string4);
	        Rewardtime[mateid] = SetTimerEx("Rewardhide", 2000, 0, "i", mateid);
		}
	}
	Czone[playerid] = 0;
}
public ZoneTimer(playerid)
{
	if(CapturingPlayers[Czone[playerid]] < ZoneInfo[Czone[playerid]][Playersreq])
	{
	    KillTimer(zSetter[Czone[playerid]]);
	    KillTimer(zTimer[Czone[playerid]]);
	    new string4[150];
	    format(string4,sizeof(string4),"~r~%s has failed to capture %s", GetTeamName(gTeam[playerid]), ZoneInfo[Czone[playerid]][zName]);
	    GameTextForAll(string4, 4000, 4);
	    GangZoneStopFlashForAll(ZoneID[Czone[playerid]]);
	    ZoneInfo[Czone[playerid]][attacked] = false;
	    for(new i = 0; i < MAX_TEAM_PLAYERS; i++)
	    {
	        new mateid = Tplayers[gTeam[playerid]][i];
	        if(Playerinfo[playerid][Capzone] == Czone[playerid])
	        {
	            SetPlayerWorldBounds(mateid, 20000,-20000,20000,-20000);
	            Playerinfo[mateid][Capzone] = 0;
	            PlayerTextDrawHide(mateid, Cdraw[mateid]);
	        }
		}
		CapturingPlayers[Czone[playerid]] = 0;
		cTime[Czone[playerid]] = 0;
		Czone[playerid] = 0;
	}
	else
	{
	    cTime[Czone[playerid]] -= 1;
	    for(new i = 0; i < MAX_TEAM_PLAYERS; i++)
	    {
	        new string[40];
	        new mateid = Tplayers[gTeam[playerid]][i];
	        if(Playerinfo[mateid][Capzone] == Czone[playerid])
	        {
	        	format(string, sizeof(string),"%s ~n~%d", ZoneInfo[Czone[playerid]][zName], cTime[Czone[playerid]]);
	        	PlayerTextDrawSetString(mateid, Cdraw[mateid], string);
			}
	    }
	}
}
public pKick(tid)
{
	Kick(tid);
}
public pBan(tid, reason[])
{
	BanEx(tid, reason);
}
public Unmute(targetid)
{
	Playerinfo[targetid][muted] = false;
	SendClientMessage(targetid, COLOUR_GREEN, "You have been automatically unmuted");
}
public JamStop(Team)
{
	new string[70];
	format(string, sizeof(string),"~b~Radar Jamming has ended for %s", GetTeamName(Team));
	GameTextForAll(string, 4000, 4);
	for(new i=0; i < MAX_TEAM_PLAYERS;  i++)
	{
	    if(Tplayers[Team][i] != INVALID_PLAYER_ID) SetPlayerColor(Tplayers[Team][i], Tcolor[Team]), Playerinfo[Tplayers[Team][i]][jammed] = false;
	}
}
//-------------End of New Functions-------------//
public OnGameModeInit()
{
    AntiDeAMX();
	SetGameModeText("Battlefield Conquest");
	UsePlayerPedAnims();
	MapAndreas_Init(MAP_ANDREAS_MODE_MINIMAL);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	EnableVehicleFriendlyFire();
	//Connect to MySQL DB and Log
	mysql_log(LOG_ERROR | LOG_WARNING | LOG_DEBUG);
	mysqldb = mysql_connect(host, user, DB, pass);
	if(mysql_errno(mysqldb) != 0) return print("Error Connecting to MySQL Database. Please DO NOT proceed until issue is fixed!"), printf("Error: %d", mysql_errno(mysqldb));
	else print("MySQL Connection Successful to Frag");
	//---------------------------------------Logo Draw-----------------------------------//
	Logodraw = TextDrawCreate(520, 18.4, "~b~BF~n~4V");
	TextDrawSetShadow(Logodraw, 0);
	TextDrawAlignment(Logodraw, 2);
	TextDrawUseBox(Logodraw, 1);
	TextDrawBoxColor(Logodraw, 0x000000FF);
	TextDrawTextSize(Logodraw, 15.2, 42);
	TextDrawFont(Logodraw, 1);
	TextDrawLetterSize(Logodraw, 0.4, 3);
	//--------------------------------End of Logo Draw-----------------------------------//
	//-----------------------------------HUDbg draw--------------------------------------//
	HUDbg = TextDrawCreate(586, 345, " ~n~ ~n~");
	TextDrawSetShadow(HUDbg, 0);
	TextDrawLetterSize(HUDbg,0.2, 3.0);
	TextDrawAlignment(HUDbg, 2);
	TextDrawTextSize(HUDbg,300, 107);
	TextDrawUseBox(HUDbg, 1);
	TextDrawBoxColor(HUDbg, 0x00000077);
	//-------------------------------End of HUDbg Draw-----------------------------------//
	//-------------------------------SAmap draw------------------------------------------//
//	SAmap = TextDrawCreate(420, 120, "samaps:gtasamapbit1");
//	TextDrawFont(SAmap, 4);
//	TextDrawSetShadow(SAmap, 0);
//	TextDrawTextSize(SAmap, 100, 170);
	//-----------------------------End of SAmap draw-------------------------------------//
	//------------------------------SAmap1 draw------------------------------------------//
//	SAmap1 = TextDrawCreate(520, 120, "samaps:gtasamapbit2");
//	TextDrawFont(SAmap1, 4);
//	TextDrawSetShadow(SAmap1, 0);
//	TextDrawTextSize(SAmap1, 100, 170);
	//----------------------------End of SAmap1 draw-------------------------------------//
	//-----------------------------------Team draw---------------------------------------//
	Teamdraw = TextDrawCreate(50, 40, "TEAM:");
	TextDrawSetShadow(Teamdraw, 0);
	TextDrawLetterSize(Teamdraw, 0.6, 2.5);
	TextDrawColor(Teamdraw, -1);
	TextDrawFont(Teamdraw, 2);
	//--------------------------------End of Team draw-----------------------------------//
	//---------------------------------Spawnbg draw--------------------------------------//
	Spawnbg = TextDrawCreate(320, 0, "~n~");
	TextDrawSetShadow(Spawnbg, 0);
	TextDrawAlignment(Spawnbg, 2);
	TextDrawTextSize(Spawnbg, 100, 640);
	TextDrawLetterSize(Spawnbg, 0.1, 240);
	TextDrawUseBox(Spawnbg, 1);
	TextDrawBoxColor(Spawnbg, 0x226FAC77); //Old color:0x226FAC77
	//----------------------------End of Spawnbg draw------------------------------------//
	//--------------------------------Team Buttons--------------------------------------//
	Teambutton[0] = TextDrawCreate(170, 40,"US");
	TextDrawSetShadow(Teambutton[0], 0);
	TextDrawBackgroundColor(Teambutton[0], 0x3D87DA44);
	TextDrawLetterSize(Teambutton[0], 0.6, 2.5);
	TextDrawAlignment(Teambutton[0], 2);
	TextDrawTextSize(Teambutton[0], 15, 85);
	TextDrawFont(Teambutton[0], 2);
	TextDrawUseBox(Teambutton[0], 1);
	TextDrawSetSelectable(Teambutton[0], 1);
	Teambutton[1] = TextDrawCreate(265, 40, "EUROPE");
	TextDrawSetShadow(Teambutton[1], 0);
	TextDrawBackgroundColor(Teambutton[1], 0x3D87DA44);
	TextDrawLetterSize(Teambutton[1], 0.55, 2.5);
	TextDrawAlignment(Teambutton[1], 2);
	TextDrawTextSize(Teambutton[1], 15, 94);
	TextDrawFont(Teambutton[1], 2);
	TextDrawUseBox(Teambutton[1], 1);
	TextDrawSetSelectable(Teambutton[1], 1);
	Teambutton[2] = TextDrawCreate( 360, 40, "INDIA");
	TextDrawSetShadow(Teambutton[2], 0);
	TextDrawBackgroundColor(Teambutton[2], 0x3D87DA44);
	TextDrawLetterSize(Teambutton[2], 0.6, 2.5);
	TextDrawAlignment(Teambutton[2], 2);
	TextDrawTextSize(Teambutton[2], 15, 85);
	TextDrawFont(Teambutton[2], 2);
	TextDrawUseBox(Teambutton[2], 1);
	TextDrawSetSelectable(Teambutton[2], 1);
	Teambutton[3] = TextDrawCreate( 453, 40, "RUSSIA");
	TextDrawSetShadow(Teambutton[3], 0);
	TextDrawBackgroundColor(Teambutton[3], 0x3D87DA44);
	TextDrawLetterSize(Teambutton[3], 0.6, 2.5);
	TextDrawAlignment(Teambutton[3], 2);
	TextDrawTextSize(Teambutton[3], 15, 89);
	TextDrawFont(Teambutton[3], 2);
	TextDrawUseBox(Teambutton[3], 1);
	TextDrawSetSelectable(Teambutton[3], 1);
	//-----------------------------End of Team Buttons----------------------------------//
	//-------------------------------Deploy Choice Draws---------------------------------//
	Deploydrawbg = TextDrawCreate(50, 70, "~n~");
	TextDrawSetShadow(Deploydrawbg, 0);
	TextDrawTextSize(Deploydrawbg, 590, 1.2);
	TextDrawLetterSize(Deploydrawbg, 0.6, 0.5);
	TextDrawUseBox(Deploydrawbg, 1);
	TextDrawBoxColor(Deploydrawbg, 0xE3781755);
	Deploydraw = TextDrawCreate(50, 70, " CHOOSE A DEPLOY POINT");
	TextDrawSetShadow(Deploydraw, 0);
	TextDrawTextSize(Deploydraw, 590, 3);
	TextDrawLetterSize(Deploydraw, 0.4, 1.75);
	TextDrawFont(Deploydraw, 2);
	TextDrawUseBox(Deploydraw, 1);
	TextDrawBoxColor(Deploydraw, 0xE37817AA);
	Basebox = TextDrawCreate(50, 100,"~n~ ~n~");
	TextDrawSetShadow(Basebox, 0);
	TextDrawUseBox(Basebox, 1);
	TextDrawBoxColor(Basebox, 0x3D87DAEE);
	TextDrawTextSize(Basebox, 65, 7);
	TextDrawLetterSize(Basebox, 0.4, 0.7);
	BaseDepdrawbg = TextDrawCreate(70, 101, "~n~");
	TextDrawSetShadow(BaseDepdrawbg, 0);
	TextDrawTextSize(BaseDepdrawbg, 400, 5);
	TextDrawLetterSize(BaseDepdrawbg, 0.6, 0.4);
	TextDrawUseBox(BaseDepdrawbg, 1);
	TextDrawBoxColor(BaseDepdrawbg,0xFFFFFFAA);
	BaseDepdraw = TextDrawCreate(70, 101, "Base Deployment");
	TextDrawSetShadow(BaseDepdraw, 0);
	TextDrawUseBox(BaseDepdraw, 1);
	TextDrawBoxColor(BaseDepdraw, 0xFFFFFFDD);
	TextDrawColor(BaseDepdraw, 0x000000FF);
	TextDrawLetterSize(BaseDepdraw, 0.35, 1.2);
	TextDrawTextSize(BaseDepdraw, 400, 10);
	TextDrawFont(BaseDepdraw, 2);
	DeployAsdraw = TextDrawCreate(50, 300,"DEPLOY AS");
	TextDrawSetShadow(DeployAsdraw, 0);
	TextDrawUseBox(DeployAsdraw, 1);
	TextDrawBoxColor(DeployAsdraw, 0xE37817AA);
	TextDrawFont(DeployAsdraw, 2);
	TextDrawColor(DeployAsdraw, 0x000000FF);
	TextDrawTextSize(DeployAsdraw, 323, 2);
	TextDrawLetterSize(DeployAsdraw, 0.25, 1.4);
	Classicon[0] = TextDrawCreate(67.2, 317,"]");
	TextDrawSetShadow(Classicon[0], 0);
	TextDrawBackgroundColor(Classicon[0], 0x3D87DA33);
	TextDrawFont(Classicon[0], 2);
	TextDrawUseBox(Classicon[0], 1);
	TextDrawAlignment(Classicon[0], 2);
	TextDrawTextSize(Classicon[0],20, 35);
	TextDrawLetterSize(Classicon[0],0.7, 3.5);
	TextDrawSetSelectable(Classicon[0], 1);
	Classicon[1] = TextDrawCreate(106.2, 317,"+");
	TextDrawSetShadow(Classicon[1], 0);
	TextDrawBackgroundColor(Classicon[1], 0x3D87DA33);
	TextDrawSetOutline(Classicon[1], 1);
	TextDrawFont(Classicon[1], 1);
	TextDrawUseBox(Classicon[1], 1);
	TextDrawBoxColor(Classicon[1], 0x15151555);
	TextDrawAlignment(Classicon[1], 2);
	TextDrawTextSize(Classicon[1],20, 35);
	TextDrawLetterSize(Classicon[1],1.0, 3.5);
	TextDrawSetSelectable(Classicon[1], 1);
	Classicon[4] = TextDrawCreate(146.2, 317,">>");
	TextDrawSetShadow(Classicon[4], 0);
	TextDrawBackgroundColor(Classicon[4], 0x3D87DA33);
	TextDrawSetOutline(Classicon[4], 1);
	TextDrawFont(Classicon[4], 2);
	TextDrawUseBox(Classicon[4], 1);
	TextDrawBoxColor(Classicon[4], 0x15151555);
	TextDrawAlignment(Classicon[4], 2);
	TextDrawTextSize(Classicon[4],20, 35);
	TextDrawLetterSize(Classicon[4],0.4, 3.5);
	TextDrawSetSelectable(Classicon[4], 1);
	Classicon[2] = TextDrawCreate(186.0, 317,"O");
	TextDrawSetShadow(Classicon[2], 0);
	TextDrawBackgroundColor(Classicon[2], 0x3D87DA33);
	TextDrawSetOutline(Classicon[2], 1);
	TextDrawFont(Classicon[2], 1);
	TextDrawUseBox(Classicon[2], 1);
	TextDrawBoxColor(Classicon[2], 0x15151555);
	TextDrawAlignment(Classicon[2], 2);
	TextDrawTextSize(Classicon[2],20, 35);
	TextDrawLetterSize(Classicon[2],0.7, 3.5);
	TextDrawSetSelectable(Classicon[2], 1);
	SnipeIcon = TextDrawCreate(186.4, 312.4,"+");
	TextDrawSetShadow(SnipeIcon, 0);
	TextDrawBackgroundColor(SnipeIcon, 0x3D87DA33);
	TextDrawSetOutline(SnipeIcon, 1);
	TextDrawFont(SnipeIcon, 2);
	TextDrawAlignment(SnipeIcon, 2);
	TextDrawTextSize(SnipeIcon,24, 36);
	TextDrawLetterSize(SnipeIcon,1.3, 4.5);
	TextDrawSetSelectable(SnipeIcon, 1);
	Classicon[6] = TextDrawCreate(225.8, 317,"CQ");
	TextDrawSetShadow(Classicon[6], 0);
	TextDrawBackgroundColor(Classicon[6], 0x3D87DA33);
	TextDrawSetOutline(Classicon[6], 1);
	TextDrawFont(Classicon[6], 2);
	TextDrawUseBox(Classicon[6], 1);
	TextDrawBoxColor(Classicon[6], 0x15151555);
	TextDrawAlignment(Classicon[6], 2);
	TextDrawTextSize(Classicon[6],20, 35);
	TextDrawLetterSize(Classicon[6],0.6, 3.5);
	TextDrawSetSelectable(Classicon[6], 1);
	Classicon[3] = TextDrawCreate(265.8, 317,"ENG");
	TextDrawSetShadow(Classicon[3], 0);
	TextDrawBackgroundColor(Classicon[3], 0x3D87DA33);
	TextDrawSetOutline(Classicon[3], 1);
	TextDrawFont(Classicon[3], 2);
	TextDrawUseBox(Classicon[3], 1);
	TextDrawBoxColor(Classicon[3], 0x15151555);
	TextDrawAlignment(Classicon[3], 2);
	TextDrawTextSize(Classicon[3],20, 35);
	TextDrawLetterSize(Classicon[3],0.4, 3.5);
	TextDrawSetSelectable(Classicon[3], 1);
	Classicon[5] = TextDrawCreate(305.4, 317,"AF");
	TextDrawSetShadow(Classicon[5], 0);
	TextDrawBackgroundColor(Classicon[5], 0x3D87DA33);
	TextDrawSetOutline(Classicon[5], 1);
	TextDrawFont(Classicon[5], 2);
	TextDrawUseBox(Classicon[5], 1);
	TextDrawBoxColor(Classicon[5], 0x15151555);
	TextDrawAlignment(Classicon[5], 2);
	TextDrawTextSize(Classicon[5],20, 35);
	TextDrawLetterSize(Classicon[5],0.6, 3.5);
	TextDrawSetSelectable(Classicon[5], 1);
	Classicon[7] = TextDrawCreate(186.5, 355,"VIP");
	TextDrawSetShadow(Classicon[7], 0);
	TextDrawBackgroundColor(Classicon[7], 0x3D87DA33);
	TextDrawSetOutline(Classicon[7], 1);
	TextDrawFont(Classicon[7], 2);
	TextDrawUseBox(Classicon[7], 1);
	TextDrawBoxColor(Classicon[7], 0x15151555);
	TextDrawAlignment(Classicon[7], 2);
	TextDrawTextSize(Classicon[7],20, 273);
	TextDrawLetterSize(Classicon[7],0.6, 3.5);
	TextDrawSetSelectable(Classicon[7], 1);
    ClassStatsbg = TextDrawCreate(328.090759, 317.083343, "~n~");
	TextDrawLetterSize(ClassStatsbg, 0.000000, 1.75);
	TextDrawTextSize(ClassStatsbg, 590.210815, 0.000000);
	TextDrawUseBox(ClassStatsbg, true);
	TextDrawBoxColor(ClassStatsbg, -239);
	TextDrawSetShadow(ClassStatsbg, 0);
	TextDrawFont(ClassStatsbg, 1);
	DeployButton = TextDrawCreate(535, 380,"DEPLOY");
	TextDrawSetShadow(DeployButton, 0);
	TextDrawUseBox(DeployButton, 1);
	TextDrawBoxColor(DeployButton, 0x00185955);
	TextDrawAlignment(DeployButton, 2);
	TextDrawTextSize(DeployButton, 23, 110);
	TextDrawLetterSize(DeployButton, 0.6, 3.5);
	TextDrawBackgroundColor(DeployButton,0x3D87DA22);
	TextDrawSetOutline(DeployButton, 3);
	TextDrawFont(DeployButton, 2);
	TextDrawSetSelectable(DeployButton, 1);
	//-----------------------------End of Deploy Choice Draws-----------------------------//
	//-------------------------------Base Zones------------------------------------------//
	for(new i=0; i < sizeof(ZoneInfo); i++)
	{
    	ZoneID[i] = GangZoneCreate(ZoneInfo[i][zMinX], ZoneInfo[i][zMinY], ZoneInfo[i][zMaxX], ZoneInfo[i][zMaxY]);
	}
 	//----------------------------------------------------------------------------------//
	if(dini_Exists("zones.ini"))
	{
	    for(new d = 3; d < 17; d++)
	    {
	        new string[3];
	        format(string,sizeof(string),"%d",d);
	        ZoneInfo[d][zTeam] = dini_Int("zones.ini", string);
		}
	}
	    //-----------------------------Teams Array Initiation-------------------------------//
 	for(new j = 0;j < MAX_TEAM_PLAYERS; j++)
    {
	        Tplayers[0][j] = INVALID_PLAYER_ID;
	        Tplayers[1][j] = INVALID_PLAYER_ID;
	        Tplayers[2][j] = INVALID_PLAYER_ID;
	        Tplayers[3][j] = INVALID_PLAYER_ID;
	}
 	//-----------------------------End of Teams Array Initiation----------------------//
 	for(new k = 0; k < MAX_PLAYERS; k++)
 	{
 	    Labels[k] = Create3DTextLabel(" ", 0xD7D7D7FF, 0, 3000, 30+k, 40, 0, 1);
 	}
	//AddPlayerClass(287, 213.2123,1901.6510,17.6406,357.1272, 0,0,0,0,0,0); //US Unit
	//AddPlayerClass(285, -1320.3314,1631.3756,8.2108,99.5769, 0,0,0,0,0,0); //EU Unit
	//AddPlayerClass(28, -253.0346,2604.8044,62.8582,4.0331, 0,0,0,0,0,0); // IN Unit
	//AddPlayerClass(124, 851.9859,2137.7310,10.8203,269.3957,0,0,0,0,0,0); // RU Unit
	CreateObject(13607,2299.0000000,470.2999900,100.7000000,0.0000000,0.0000000,0.0000000);
	//-----------------------------------------Pickups------------------------------------------//
	VIPattachpickup = CreatePickup(1318, 2, 1487.9728,-3577.1252,58.3500, -1);
	VIPsetpickup = CreatePickup(1239, 2, 1486.0679,-3598.1116,58.3559, -1);
	VIPtoclubpickup = CreatePickup(1559, 2,1475.1888,-3602.6667,58.7500, -1);
	//--------------------------------End of Pickups-------------------------------------------//
	//---------------------------------------Zone Flags-----------------------------------------//
	CreateObject(16101,-83.7998100,1386.2002000,9.3000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[0] = CreateObject(2914,-83.7998100,1386.2002000,19.2000000,0.0000000,357.9950000,0.0000000); //object(kmb_goflag) (1)
	CreateObject(16101,-523.5000000,2594.0000000,52.4000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[1] = CreateObject(2914,-523.4780300,2594.0400000,62.3000000,0.0000000,357.9950000,270.0000000); //object(kmb_goflag) (1)
	CreateObject(16101,-833.7999900,2740.5000000,44.6000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[2] = CreateObject(2914,-833.7802700,2740.5400000,54.5000000,0.0000000,357.9950000,270.0000000); //object(kmb_goflag) (1)
	CreateObject(16101,287.7000100,1411.5000000,9.4000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[3] = CreateObject(2914,287.7200000,1411.4800000,19.3000000,0.0000000,357.9900000,90.0000000); //object(kmb_goflag) (1)
	CreateObject(16101,-1390.2000000,2635.7000000,55.0000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[4] = CreateObject(2914,-1390.2000000,2635.7390000,64.9000000,0.0000000,357.9950000,270.0000000); //object(kmb_goflag) (1)
	CreateObject(16101,407.7998000,2529.2998000,15.6000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[5] = CreateObject(2914,407.8100000,2529.3501000,25.5000000,0.0000000,358.0000000,270.0000000); //object(kmb_goflag) (1)
	CreateObject(16101,-797.2000100,1557.1000000,26.1000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[6] = CreateObject(2914,-797.1552700,1557.1201000,35.9800000,0.0000000,357.9950000,179.9950000); //object(kmb_goflag) (1)
	CreateObject(16101,1088.9004000,1074.5996000,9.8000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[7] = CreateObject(2914,1088.9100000,1074.5800000,19.7000000,0.0000000,357.9900000,90.0000000); //object(kmb_goflag) (1)
	CreateObject(16101,602.2999900,867.7999900,-44.0000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[8] = CreateObject(2914,602.3203100,867.7714800,-34.1000000,0.0000000,357.9900000,90.0000000); //object(kmb_goflag) (1)
	CreateObject(16101,-336.9003900,1534.9004000,74.6000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[9] = CreateObject(2914,-336.8599200,1534.9000000,84.4999900,0.0000000,358.0000000,180.0000000); //object(kmb_goflag) (1)
	CreateObject(16101,-702.0999800,954.5999800,11.4000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[10] = CreateObject(2914,-702.0498000,954.6103500,21.3000000,0.0000000,357.9950000,179.9950000); //object(kmb_goflag) (1)
	CreateObject(16101,977.7282100,2590.2651000,9.8000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[11] = CreateObject(2914,977.7199700,2590.2600000,19.7000000,0.0000000,358.0000000,0.0000000); //object(kmb_goflag) (1)
	CreateObject(16101,1097.9004000,1703.5000000,9.8000000,0.0000000,0.0000000,0.0000000); //object(des_windsockpole) (1)
	zFlag[12] = CreateObject(2914,1097.9100000,1703.4800000,19.6990000,0.0000000,357.9950000,90.0000000); //object(kmb_goflag) (1)
	//------------------------------------End of Zone Flags----------------------------------------------//
	//-----------------------------------Zone Default Color Set------------------------------------------//
	for(new h = 0; h < 13; h++)
	{
	    SetObjectMaterial(zFlag[h], 1, -1, "none", "none", GetTeamFlagColor(ZoneInfo[h+4][zTeam]));
	}
	//-------------------------------End of Zone Default Color Set--------------------------------------//
	//-----------------------------------------------Special Vehs---------------------------------//
	USTB1 = AddStaticVehicleEx(519,364.5000000,1978.8000488,18.6000004,90.0000000,-1,-1,120); //Shamal
	USTB2 = AddStaticVehicleEx(519,364.5000000,1944.7998047,18.6000004,90.0000000,-1,-1,120); //Shamal
	EUTB1 = AddStaticVehicleEx(519,-1618.5999756,1610.5999756,17.5000000,0.0000000,-1,-1,120); //Shamal
	EUTB2 = AddStaticVehicleEx(519,-1636.2998047,1618.3994141,17.5000000,0.0000000,-1,-1,120); //Shamal
	INTB1 = AddStaticVehicleEx(519,-209.8999939,2592.3999023,63.7000008,0.0000000,-1,-1,120); //Shamal
	INTB2 = AddStaticVehicleEx(519,-232.8994141,2592.3994141,63.7000008,0.0000000,-1,-1,120); //Shamal
	RUTB1 = AddStaticVehicleEx(519,861.0999800,2076.1001000,11.9000000,0.0000000,245,245,120); //Shamal
	RUTB2 = AddStaticVehicleEx(519,881.7000100,2076.1001000,11.9000000,0.0000000,245,245,120); //Shamal
	USMSAM = AddStaticVehicleEx(578,118.1999969,2021.5000000,19.3999996,270.0000000,104,1,120); //DFT-30
	EUMSAM = AddStaticVehicleEx(578,-1350.6999512,1660.3000488,5.0000000,170.0000000,104,1,120); //DFT-30
	INMSAM = AddStaticVehicleEx(578,-293.7999878,2719.3000488,63.0999985,180.0000000,104,1,120); //DFT-30
	RUMSAM = AddStaticVehicleEx(578,831.7000100,2149.1001000,11.5000000,90.0000000,104,1,120); //DFT-30
	USMRL = AddStaticVehicleEx(578,153.1999969,2021.5000000,19.3999996,90.0000000,104,1,120); //DFT-30
	EUMRL = AddStaticVehicleEx(578,-1362.4000244,1662.5000000,5.0000000,169.9969482,104,1,120); //DFT-30
	INMRL = AddStaticVehicleEx(578,-285.7998047,2719.2998047,63.0999985,180.0000000,104,1,120); //DFT-30
	RUMRL = AddStaticVehicleEx(578,831.7002000,2161.1006000,11.5000000,90.0000000,104,1,120); //DFT-30
	//-----------------------------------------End of Special Vehs--------------------------------//
	//----------------------------------------Tanks----------------------------------------------//
	//US
	AddStaticVehicleEx(432,161.8000031,1980.5999756,19.0000000,90.0000000,-1,-1,120); //Rhino
	AddStaticVehicleEx(432,161.7998047,1989.5996094,19.0000000,90.0000000,-1,-1,120); //Rhino
	AddStaticVehicleEx(432,150.7998047,1989.5996094,19.3999996,90.0000000,-1,-1,120); //Rhino
	AddStaticVehicleEx(432,150.7998047,1980.5996094,19.3999996,90.0000000,-1,-1,120); //Rhino
	//EU
	AddStaticVehicleEx(432,-1371.0000000,1587.5999756,4.3000002,350.0000000,-1,-1,120); //Rhino
	AddStaticVehicleEx(432,-1377.3000488,1589.8000488,4.4000001,349.9969482,-1,-1,120); //Rhino
	AddStaticVehicleEx(432,-1375.6992188,1599.3994141,4.4000001,349.9969482,-1,-1,120); //Rhino
	AddStaticVehicleEx(432,-1369.0996094,1598.1992188,4.4000001,349.9969482,-1,-1,120); //Rhino
	//IN
	AddStaticVehicleEx(432,-216.1000061,2658.1999512,62.7999992,180.0000000,-1,-1,120); //Rhino
	AddStaticVehicleEx(432,-227.0996094,2658.1992188,62.7999992,180.0000000,-1,-1,120); //Rhino
	AddStaticVehicleEx(432,-227.0996094,2669.1992188,62.7999992,180.0000000,-1,-1,120); //Rhino
	AddStaticVehicleEx(432,-216.1000061,2669.1999512,62.7999992,180.0000000,-1,-1,120); //Rhino
	//RU
	AddStaticVehicleEx(432,824.0999800,2069.8999000,11.1000000,0.0000000,95,10,120); //Rhino
	AddStaticVehicleEx(432,818.0996100,2069.9004000,11.1000000,0.0000000,95,10,120); //Rhino
	AddStaticVehicleEx(432,824.0999800,2079.8999000,11.1000000,0.0000000,95,10,120); //Rhino
	AddStaticVehicleEx(432,818.0996100,2079.9004000,11.1000000,0.0000000,95,10,120); //Rhino
	//----------------------------------------End of Tanks--------------------------------------//
	//----------------------------------US Vehs------------------------------------------//
	AddStaticVehicleEx(520,280.1999817,1956.0000000,19.0000000,270.0000000,-1,-1,120); //Hydra
	AddStaticVehicleEx(520,280.1992188,2023.8994141,19.0000000,270.0000000,-1,-1,120); //Hydra
	AddStaticVehicleEx(520,280.1992188,1989.5996094,19.0000000,270.0000000,-1,-1,120); //Hydra
	AddStaticVehicleEx(470,191.8000031,1921.0999756,17.7999992,90.0000000,-1,-1,120); //Patriot
	AddStaticVehicleEx(470,198.6000061,1921.1999512,17.7999992,90.0000000,-1,-1,120); //Patriot
	AddStaticVehicleEx(470,205.0000000,1921.1999512,17.7999992,90.0000000,-1,-1,120); //Patriot
	AddStaticVehicleEx(470,211.3999939,1921.3000488,17.7999992,90.0000000,-1,-1,120); //Patriot
	AddStaticVehicleEx(468,216.6000061,1921.5000000,17.3999996,90.0000000,110,1,120); //Sanchez
	AddStaticVehicleEx(468,217.3994141,1919.5000000,17.3999996,90.0000000,110,1,120); //Sanchez
	AddStaticVehicleEx(468,220.8000031,1919.6999512,17.3999996,90.0000000,110,1,120); //Sanchez
	AddStaticVehicleEx(468,220.1999969,1921.9000244,17.3999996,90.0000000,110,1,120); //Sanchez
	AddStaticVehicleEx(425,211.8000031,1963.5999756,21.3999996,90.0000000,-1,-1,120); //Hunter
	AddStaticVehicleEx(425,211.7998047,1995.5996094,21.3999996,90.0000000,-1,-1,120); //Hunter
	AddStaticVehicleEx(447,243.3000031,1963.0999756,20.6000004,90.0000000,-1,-1,120); //Seasparrow
	AddStaticVehicleEx(487,243.1999969,1995.3000488,20.7999992,90.0000000,47,0,120); //Maverick
	//---------------------------------End of US Vehs------------------------------------//
	//----------------------------------US Objects----------------------------------------//
	USmovinggate1 = CreateObject(976,96.4000015,2059.9599609,16.7999992,0.0000000,0.0000000,90.0000000); //object(phils_compnd_gate) (1)
	USmovinggate2 = CreateObject(976,96.3994141,2073.4599609,16.7999992,0.0000000,0.0000000,90.0000000); //object(phils_compnd_gate) (2)
	USTBM1 = CreateObject(3786,101.5000000,2954.8000488,11.8000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (1)
	USTBM2 = CreateObject(3786,102.1992188,2953.7998047,12.8000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (2)
	USTBM3 = CreateObject(3786,100.6999969,2956.1999512,10.3999996,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (3)
	USTBM4 = CreateObject(3786,102.8994141,2952.6992188,13.8000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (4)
	USMSAMM = CreateObject(3884,109.1999969,2954.5000000,10.3999996,0.0000000,0.0000000,0.0000000); //object(samsite_sfxrf) (1)
	USMRLM1 = CreateObject(3790,95.8000031,2954.8000488,12.5000000,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (1)
	USMRLM2 =CreateObject(3790,95.8994141,2952.0996094,15.3000002,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (2)
	USMRLM3 = CreateObject(3790,95.8994141,2952.6992188,14.6999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (3)
	USMRLM4 = CreateObject(3790,95.7998047,2953.3994141,14.0000000,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (4)
	USMRLM5 = CreateObject(3790,95.7998047,2954.0996094,13.1999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (5)
	USMRLM6 = CreateObject(3790,95.9000015,2956.5000000,10.6000004,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (6)
	USMRLM7 = CreateObject(3790,95.7998047,2955.3994141,11.8000002,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (7)
	USMRLM8 =CreateObject(3790,95.7998047,2956.0000000,11.1999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (8)
	USMRLH1 = CreateObject(3389,107.3000031,2949.8999023,16.5000000,0.0000000,0.0000000,0.0000000); //object(a51_srack1_) (1)
	USMRLH2 =CreateObject(3389,104.4000015,2950.3000488,16.2999992,0.0000000,0.0000000,0.0000000); //object(a51_srack1_) (2)
	CreateObject(1682,344.6000061,2070.5000000,33.0999985,0.0000000,0.0000000,0.0000000); //object(ap_radar1_01) (1)
	CreateObject(8172,305.1992188,1979.6992188,16.6599998,0.0000000,0.0000000,179.9945068); //object(vgssairportland07) (1)
	CreateObject(8171,305.2000122,1860.1000977,16.6599998,0.0000000,0.0000000,0.0000000); //object(vgssairportland06) (1)
	CreateObject(16098,377.0000000,1961.8994141,21.5999985,0.0000000,0.0000000,0.0000000); //object(des_by_hangar_) (2)
	CreateObject(9241,213.1999969,1963.0999756,18.4000008,0.0000000,0.0000000,180.0000000); //object(copbits_sfn) (1)
	CreateObject(9241,213.2500000,1995.2500000,18.4000008,0.0000000,0.0000000,179.9945068); //object(copbits_sfn) (2)
	CreateObject(9241,245.2092133,1962.8996582,18.4000008,0.0000000,0.0000000,179.9945068); //object(copbits_sfn) (3)
	CreateObject(9241,245.2092133,1995.0600586,18.4000008,0.0000000,0.0000000,179.9945068); //object(copbits_sfn) (4)
	CreateObject(10763,235.5000000,2048.8999023,49.4000015,0.0000000,0.0000000,140.0000000); //object(controltower_sfse) (1)
	CreateObject(10810,340.2000122,2068.6999512,21.6000004,0.0000000,0.0000000,200.0000000); //object(ap_smallradar1_sfse) (1)
	CreateObject(3095,268.3500061,1883.6000977,15.9900007,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (1)
	CreateObject(10245,270.6000061,1928.5000000,21.2000008,0.0000000,0.0000000,270.0000000); //object(ottos_ramp) (1)
	CreateObject(10245,179.8397980,1950.2998047,20.0000000,0.0000000,0.0000000,315.0000000); //object(ottos_ramp) (3)
	CreateObject(987,96.6999969,1941.5000000,17.2000008,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (1)
	CreateObject(987,96.6992188,1953.5000000,17.2000008,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (2)
	CreateObject(987,96.6992188,1965.5000000,17.2000008,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (3)
	CreateObject(987,96.6992188,1989.5000000,17.2000008,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (4)
	CreateObject(987,96.6992188,1977.5000000,17.2000008,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (5)
	CreateObject(987,96.6992188,2001.5000000,17.2000008,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (6)
	CreateObject(987,96.6992188,2013.5000000,17.2000008,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (7)
	CreateObject(7033,91.1992188,2071.0000000,21.0000000,0.0000000,0.0000000,90.0000000); //object(vgnhsegate02) (1)
	CreateObject(987,96.6992188,2025.5000000,17.2000008,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (8)
	CreateObject(987,96.6992188,2037.5000000,17.2000008,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (9)
	CreateObject(987,96.6992188,2046.5899658,17.2000008,0.0000000,1.2999878,90.0000000); //object(elecfence_bar) (10)
	CreateObject(987,96.9922256,2096.0898438,17.0000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (11)
	CreateObject(987,96.6992188,2083.9892578,17.0000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (12)
	CreateObject(987,108.9921875,2096.0898438,17.0000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (13)
	CreateObject(987,120.9921875,2096.0898438,17.0000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (14)
	CreateObject(987,132.9921875,2096.0898438,17.0000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (15)
	CreateObject(987,144.9921875,2096.0898438,17.1000004,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (16)
	CreateObject(987,156.9921875,2096.0898438,19.0000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (17)
	CreateObject(987,163.9921875,2096.0898438,19.0000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (18)
	CreateObject(10245,180.2998047,1932.2998047,20.0000000,0.0000000,0.0000000,135.0000000); //object(ottos_ramp) (1)
	CreateObject(10245,258.2990112,1915.5993652,21.2000008,0.0000000,0.0000000,90.0000000); //object(ottos_ramp) (1)
	CreateObject(3526,313.2999878,2046.6999512,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (1)
	CreateObject(3526,317.5996094,2046.6992188,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (2)
	CreateObject(3526,304.8999939,2046.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (3)
	CreateObject(3526,309.0996094,2046.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (4)
	CreateObject(3526,299.8994141,2046.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (5)
	CreateObject(3526,294.8994141,2046.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (6)
	CreateObject(3526,289.8994141,2046.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (7)
	CreateObject(3526,313.2998047,2050.6992188,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (8)
	CreateObject(3526,309.0996094,2050.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (9)
	CreateObject(3526,304.8994141,2050.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (10)
	CreateObject(3526,299.8994141,2050.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (11)
	CreateObject(3526,294.8994141,2050.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (12)
	CreateObject(3526,309.0996094,2054.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (13)
	CreateObject(3526,304.8994141,2054.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (14)
	CreateObject(3526,299.8994141,2054.5996094,16.7000008,0.0000000,0.0000000,0.0000000); //object(vegasairportlight) (15)
	CreateObject(3268,156.8000031,1983.6999512,17.6000000,0.0000000,0.0000000,0.0000000); //object(mil_hangar1_) (1)
	CreateObject(3268,156.7998047,2020.6992188,17.0000000,0.0000000,0.0000000,0.0000000); //object(mil_hangar1_) (2)
	CreateObject(3268,115.7998047,1983.6992188,17.7000000,0.0000000,0.0000000,180.0000000); //object(mil_hangar1_) (3)
	CreateObject(3268,115.7998047,2020.6992188,17.2000000,0.0000000,0.0000000,180.0000000); //object(mil_hangar1_) (4)
	CreateObject(3884,192.1999969,1926.4000244,21.8000011,0.0000000,0.0000000,180.0000000); //object(samsite_sfxrf) (1)
	CreateObject(3884,192.1992188,1936.0993652,21.8000011,0.0000000,0.0000000,179.9945068); //object(samsite_sfxrf) (2)
	CreateObject(3884,221.4992218,1936.0986328,21.8000011,0.0000000,0.0000000,179.9945068); //object(samsite_sfxrf) (3)
	CreateObject(3884,221.4992218,1926.3994141,21.8000011,0.0000000,0.0000000,179.9945068); //object(samsite_sfxrf) (4)
	CreateObject(16093,359.0000000,1797.0999756,20.8,0.0000000,0.0000000,35.0000000); //object(a51_gatecontrol) (1)
	CreateObject(16093,337.3999939,1785.0999756,21.1000004,0.0000000,0.0000000,29.9981689); //object(a51_gatecontrol) (2)
	CreateObject(16638,359.5000000,1796.5000000,19.1500008,0.0000000,0.0000000,35.0000000); //object(a51_gatecon_a) (1)
	CreateObject(16638,338.0000000,1784.5000000,19.3999996,0.0000000,0.0000000,29.9981689); //object(a51_gatecon_a) (2)
	CreateObject(992,97.8000031,2070.9899902,18.0000000,0.0000000,0.0000000,270.0000000); //object(bar_barrier10b) (1)
	//------------------------------------End of US Objects------------------------------//
	//---------------------------------------EU Objects----------------------------------//
	EUmovinggate = CreateObject(989,-1608.3994141,1743.7998047,10.3000002,0.0000000,0.0000000,119.9981689); //object(ac_apgate) (3)
	EUTBM1 = CreateObject(3786,101.5000000,2954.8000488,14.8000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (1)
	EUTBM2 = CreateObject(3786,102.1992188,2953.7998047,16.8000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (2)
	EUTBM3 = CreateObject(3786,100.6999969,2956.1999512,13.3999996,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (3)
	EUTBM4 = CreateObject(3786,102.8994141,2952.6992188,15.8000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (4)
	EUMSAMM = CreateObject(3884,109.1999969,2954.5000000,14.3999996,0.0000000,0.0000000,0.0000000); //object(samsite_sfxrf) (1)
	EUMRLM1 = CreateObject(3790,95.8000031,2954.8000488,13.5000000,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (1)
	EUMRLM2 = CreateObject(3790,95.8994141,2952.0996094,16.3000002,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (2)
	EUMRLM3 = CreateObject(3790,95.8994141,2952.6992188,15.6999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (3)
	EUMRLM4 = CreateObject(3790,95.7998047,2953.3994141,15.0000000,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (4)
	EUMRLM5 = CreateObject(3790,95.7998047,2954.0996094,14.1999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (5)
	EUMRLM6 = CreateObject(3790,95.9000015,2956.5000000,11.6000004,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (6)
	EUMRLM7 = CreateObject(3790,95.7998047,2955.3994141,12.8000002,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (7)
	EUMRLM8 = CreateObject(3790,95.7998047,2956.0000000,12.1999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (8)
	EUMRLH1 = CreateObject(3389,107.3000031,2949.8999023,17.5000000,0.0000000,0.0000000,0.0000000); //object(a51_srack1_) (1)
	EUMRLH2 = CreateObject(3389,104.4000015,2950.3000488,17.2999992,0.0000000,0.0000000,0.0000000); //object(a51_srack1_) (2)
	CreateObject(16209,-1350.0996094,1641.7998047,4.4000001,0.0000000,0.0000000,0.0000000); //object(cen_bit_19) (1)
	CreateObject(16182,-1500.5999756,1710.3999023,-1.1000007,0.0000000,0.0000000,0.0000000); //object(ne_bit_12) (1)
	CreateObject(11556,-1312.0999756,1536.6999512,0.0000000,354.0000000,0.0000000,0.0000000); //object(des_adrocks) (1)
	CreateObject(11556,-1226.3994141,1569.2998047,-3.0000000,0.0000000,0.0000000,44.9890137); //object(des_adrocks) (2)
	CreateObject(11556,-1257.3994141,1543.5000000,0.0000000,356.0000000,0.0000000,24.9993896); //object(des_adrocks) (3)
	CreateObject(11556,-1289.0000000,1533.0000000,0.0000000,354.0000000,0.0000000,0.9942627); //object(des_adrocks) (4)
	CreateObject(11556,-1352.1992188,1532.1992188,0.0000000,354.0000000,0.0000000,0.9942627); //object(des_adrocks) (5)
	CreateObject(11556,-1393.5999756,1520.3000488,-2.5000000,0.0000000,0.0000000,0.9942627); //object(des_adrocks) (6)
	CreateObject(11556,-1455.2998047,1536.7998047,0.0000000,355.0000000,0.0000000,0.9942627); //object(des_adrocks) (7)
	CreateObject(11556,-1421.8994141,1536.5000000,0.0000000,355.0000000,0.0000000,0.9942627); //object(des_adrocks) (8)
	CreateObject(11556,-1503.6999512,1585.0999756,-3.0000000,0.0000000,0.0000000,0.9997559); //object(des_adrocks) (9)
	CreateObject(11556,-1489.7998047,1573.0996094,-2.9000001,0.0000000,0.0000000,270.9942627); //object(des_adrocks) (10)
	CreateObject(11556,-1544.1992188,1589.0000000,-3.0000000,0.0000000,0.0000000,344.0039062); //object(des_adrocks) (12)
	CreateObject(11556,-1582.8994141,1611.8994141,-3.0000000,0.0000000,0.0000000,314.0002441); //object(des_adrocks) (13)
	CreateObject(879,-1471.3000488,1588.0000000,4.1999998,0.0000000,0.0000000,0.0000000); //object(p_rubble04bcol) (1)
	CreateObject(880,-1237.5000000,1570.1999512,2.8000002,0.0000000,0.0000000,0.0000000); //object(p_rubble0bcol) (1)
	CreateObject(16112,-1224.1992188,1590.1992188,-3.6999998,0.0000000,0.0000000,0.0000000); //object(des_rockfl1_) (2)
	CreateObject(16112,-1508.0999756,1592.2000732,-4.0000000,0.0000000,0.0000000,0.0000000); //object(des_rockfl1_) (3)
	CreateObject(16112,-1487.1999512,1579.5999756,2.9000001,0.0000000,0.0000000,0.0000000); //object(des_rockfl1_) (4)
	CreateObject(5296,-1600.7998047,1716.7998047,5.4400001,0.0000000,358.3959961,284.9963379); //object(laroads_26a_las01) (1)
	CreateObject(11556,-1606.1992188,1652.0000000,-5.9000001,0.0000000,0.0000000,279.0032959); //object(des_adrocks) (14)
	CreateObject(16112,-1579.3000488,1720.0999756,-7.5999999,0.0000000,0.0000000,0.0000000); //object(des_rockfl1_) (5)
	CreateObject(16112,-1470.9000244,1666.5000000,-6.0000000,0.0000000,0.0000000,0.0000000); //object(des_rockfl1_) (6)
	CreateObject(987,-1552.3000488,1717.5999756,1.3000000,0.0000000,0.0000000,330.0000000); //object(elecfence_bar) (1)
	CreateObject(987,-1562.5996094,1723.7998047,1.2000000,0.0000000,0.0000000,329.9963379); //object(elecfence_bar) (2)
	CreateObject(3749,-1610.0000000,1751.5000000,14.3000002,0.0000000,0.0000000,14.9963379); //object(clubgate01_lax) (1)
	CreateObject(987,-1542.5000000,1712.0000000,1.2000000,0.0000000,0.0000000,329.9963379); //object(elecfence_bar) (3)
	CreateObject(987,-1599.8000488,1779.9000244,8.6999998,0.0000000,0.0000000,70.0000000); //object(elecfence_bar) (4)
	CreateObject(987,-1482.8000488,1710.5000000,1.5000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (5)
	CreateObject(987,-1603.8994141,1768.5996094,8.6000004,0.0000000,0.0000000,69.9993896); //object(elecfence_bar) (6)
	CreateObject(987,-1483.2998047,1698.6992188,1.9000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (7)
	CreateObject(987,-1393.1999512,1709.5999756,3.3000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (8)
	CreateObject(987,-1393.3000488,1721.6999512,3.2000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (9)
	CreateObject(987,-1532.0000000,1706.0000000,1.0000000,0.0000000,0.0000000,329.9963379); //object(elecfence_bar) (10)
	CreateObject(987,-1521.5999756,1699.9000244,0.9000000,0.0000000,0.0000000,329.9963379); //object(elecfence_bar) (11)
	CreateObject(987,-1511.1992188,1693.8994141,0.9000000,0.0000000,0.0000000,329.9963379); //object(elecfence_bar) (13)
	CreateObject(987,-1500.7998047,1687.8994141,0.9000000,0.0000000,0.0000000,329.9963379); //object(elecfence_bar) (14)
	CreateObject(987,-1568.9000244,1713.8000488,0.2000000,0.0000000,0.0000000,60.0000000); //object(elecfence_bar) (15)
	CreateObject(987,-1575.0000000,1703.5000000,1.2000000,0.0000000,0.0000000,59.9963379); //object(elecfence_bar) (16)
	CreateObject(987,-1581.0999756,1693.1999512,0.1000000,0.0000000,0.0000000,59.9963379); //object(elecfence_bar) (17)
	CreateObject(987,-1458.0999756,1660.5000000,3.2000000,0.0000000,0.0000000,329.9963379); //object(elecfence_bar) (18)
	CreateObject(987,-1490.3994141,1682.0000000,0.9000000,0.0000000,0.0000000,329.9963379); //object(elecfence_bar) (19)
	CreateObject(987,-1447.6992188,1654.5996094,3.2000000,0.0000000,0.0000000,0.9942627); //object(elecfence_bar) (20)
	CreateObject(987,-1435.6999512,1654.8000488,3.2000000,0.0000000,0.0000000,0.9942627); //object(elecfence_bar) (20)
	CreateObject(987,-1414.5000000,1662.6999512,3.2000000,0.0000000,0.0000000,40.0000000); //object(elecfence_bar) (20)
	CreateObject(987,-1423.6992188,1655.0000000,3.2000000,0.0000000,0.0000000,39.9957275); //object(elecfence_bar) (20)
	CreateObject(987,-1405.3000488,1670.4000244,3.2000000,0.0000000,0.0000000,22.9957275); //object(elecfence_bar) (20)
	CreateObject(987,-1394.3000488,1675.1999512,3.2000000,0.0000000,0.0000000,22.9943848); //object(elecfence_bar) (20)
	CreateObject(987,-1383.3000488,1679.9000244,3.2000000,0.0000000,0.0000000,22.9943848); //object(elecfence_bar) (20)
	CreateObject(987,-1372.1999512,1684.5999756,3.2000000,0.0000000,0.0000000,22.9943848); //object(elecfence_bar) (20)
	CreateObject(987,-1325.9000244,1685.5000000,3.2000000,0.0000000,0.0000000,340.0000000); //object(elecfence_bar) (20)
	CreateObject(987,-1361.1992188,1689.2998047,3.2000000,0.0000000,0.0000000,0.9942627); //object(elecfence_bar) (20)
	CreateObject(987,-1349.1992188,1689.5000000,3.2000000,0.0000000,0.0000000,0.9942627); //object(elecfence_bar) (20)
	CreateObject(987,-1337.1992188,1689.6992188,3.2000000,0.0000000,0.0000000,339.9993896); //object(elecfence_bar) (20)
	CreateObject(987,-1245.9000244,1634.5999756,3.2000000,0.0000000,0.0000000,300.0000000); //object(elecfence_bar) (20)
	CreateObject(987,-1314.5996094,1681.3994141,3.2000000,0.0000000,0.0000000,339.9993896); //object(elecfence_bar) (20)
	CreateObject(987,-1303.2998047,1677.2998047,3.2000000,0.0000000,0.0000000,339.9993896); //object(elecfence_bar) (20)
	CreateObject(987,-1292.0000000,1673.1992188,3.2000000,0.0000000,0.0000000,319.9987793); //object(elecfence_bar) (20)
	CreateObject(987,-1282.7998047,1665.5000000,3.2000000,0.0000000,0.0000000,319.9987793); //object(elecfence_bar) (20)
	CreateObject(987,-1273.5996094,1657.7998047,3.2000000,0.0000000,0.0000000,319.9987793); //object(elecfence_bar) (20)
	CreateObject(987,-1264.3994141,1650.0000000,3.2000000,0.0000000,0.0000000,319.9987793); //object(elecfence_bar) (20)
	CreateObject(987,-1255.1992188,1642.2998047,3.2000000,0.0000000,0.0000000,319.9987793); //object(elecfence_bar) (20)
	CreateObject(10771,-1565.3994141,1585.1992188,3.7000000,0.0000000,0.0000000,329.9963379); //object(carrier_hull_sfse) (1)
	CreateObject(10245,-1555.7998047,1604.2998047,9.0000000,0.0000000,0.0000000,284.9963379); //object(ottos_ramp) (1)
	CreateObject(10770,-1566.4000244,1577.2000732,36.9000015,0.0000000,0.0000000,330.0000000); //object(carrier_bridge_sfse) (1)
	CreateObject(11237,-1564.9000244,1574.3000488,36.5000000,0.0000000,0.0000000,330.0000000); //object(carrier_bits_sfse) (1)
	CreateObject(16613,-1317.9000244,1607.5999756,8.1999998,0.0000000,0.0000000,270.0000000); //object(des_bigtelescope) (2)
	CreateObject(11149,-1572.9499512,1584.3000488,10.2999992,0.0000000,0.0000000,330.0000000); //object(accorridors_sfs) (1)
	CreateObject(11145,-1620.1000977,1616.9000244,2.6000001,0.0000000,0.0000000,330.0000000); //object(carrier_lowdeck_sfs) (1)
	CreateObject(11146,-1572.6000977,1590.6500244,10.5400000,0.0000000,0.0000000,330.0000000); //object(carrier_hangar_sfs) (1)
	CreateObject(3115,-1650.9000244,1634.4399414,15.1700001,0.0000000,0.0000000,330.0000000); //object(carrier_lift1_sfse) (1)
	CreateObject(3114,-1607.4000244,1625.8000488,14.9000006,0.0000000,0.0000000,330.0000000); //object(carrier_lift2_sfse) (1)
	CreateObject(3114,-1589.5999756,1615.5000000,14.8999996,0.0000000,0.0000000,329.9963379); //object(carrier_lift2_sfse) (2)
	CreateObject(3114,-1608.3994141,1627.7998047,7.9000006,0.0000000,0.0000000,329.9963379); //object(carrier_lift2_sfse) (3)
	CreateObject(3268,-1310.0999756,1663.0999756,3.2000000,0.0000000,0.0000000,80.0000000); //object(mil_hangar1_) (1)
	CreateObject(3268,-1394.5000000,1658.4000244,3.2000000,0.0000000,0.0000000,130.0000000); //object(mil_hangar1_) (2)
	CreateObject(3268,-1372.5000000,1586.3994141,2.4000001,0.0000000,0.0000000,259.9969482); //object(mil_hangar1_) (3)
	CreateObject(3268,-1355.6992188,1667.7998047,3.2000000,0.0000000,0.0000000,79.9969482); //object(mil_hangar1_) (4)
	CreateObject(3279,-1376.8000488,1672.4000244,3.2000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (1)
	CreateObject(3279,-1282.5999756,1656.4000244,3.2000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (2)
	CreateObject(3279,-1331.7998047,1668.2998047,3.2000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (3)
	CreateObject(3279,-1257.0999756,1616.0999756,3.2000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (4)
	CreateObject(3279,-1339.9000244,1572.1999512,1.9000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (5)
	CreateObject(3279,-1403.0999756,1576.1999512,2.8000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (6)
	CreateObject(3279,-1481.6999512,1627.5999756,6.0000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (7)
	CreateObject(3279,-1557.8000488,1677.8000488,6.1000004,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (8)
	CreateObject(7947,-1250.0000000,1580.5000000,-1.3000000,0.0000000,0.0000000,200.0000000); //object(vegaspumphouse1) (1)
	CreateObject(16093,-1574.3000488,1666.9000244,4.5000000,0.0000000,0.0000000,200.0000000); //object(a51_gatecontrol) (1)
	CreateObject(16093,-1597.5000000,1661.9000244,3.7000000,0.0000000,0.0000000,199.9951172); //object(a51_gatecontrol) (2)
	CreateObject(989,-1603.0000000,1744.9000244,10.1999998,0.0000000,0.0000000,120.0000000); //object(ac_apgate) (1)
	CreateObject(989,-1613.5996094,1742.0996094,10.1000004,0.0000000,0.0000000,119.9981689); //object(ac_apgate) (2)
	CreateObject(11556,-1384.6992188,1536.3994141,0.0000000,356.0000000,0.0000000,0.9942627); //object(des_adrocks) (6)

	//-----------------------------------------End of EU Objects----------------------------//
	//--------------------------------------------EU Vehs----------------------------------------//
	AddStaticVehicleEx(425,-1655.8000488,1628.0000000,17.3999996,240.0000000,-1,-1,120); //Hunter
	AddStaticVehicleEx(425,-1645.0996094,1637.2998047,17.2999992,239.9963379,-1,-1,120); //Hunter
	AddStaticVehicleEx(520,-1608.3000488,1611.4000244,10.8000002,330.0000000,-1,-1,120); //Hydra
	AddStaticVehicleEx(520,-1608.8000488,1623.8000488,10.8000002,329.9963379,-1,-1,120); //Hydra
	AddStaticVehicleEx(520,-1622.0996094,1619.7998047,10.8000002,329.9963379,-1,-1,120); //Hydra
	AddStaticVehicleEx(447,-1611.6992188,1631.5000000,16.6000004,240.0000000,-1,-1,120); //Seasparrow
	AddStaticVehicleEx(487,-1597.1999512,1623.1999512,16.7000008,240.0000000,104,0,120); //Maverick
	AddStaticVehicleEx(470,-1307.8000488,1660.8000488,4.3000002,170.0000000,-1,-1,120); //Patriot
	AddStaticVehicleEx(470,-1303.1999512,1660.4000244,4.3000002,169.9969482,-1,-1,120); //Patriot
	AddStaticVehicleEx(470,-1304.7998047,1653.0996094,4.3000002,169.9969482,-1,-1,120); //Patriot
	AddStaticVehicleEx(470,-1309.0999756,1653.5000000,4.3000002,169.9969482,-1,-1,120); //Patriot
	AddStaticVehicleEx(468,-1313.8000488,1654.0999756,4.0000000,170.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(468,-1317.4000244,1655.0000000,4.0000000,169.9969482,104,1,120); //Sanchez
	AddStaticVehicleEx(468,-1316.6999512,1661.9000244,4.0000000,169.9969482,104,1,120); //Sanchez
	AddStaticVehicleEx(468,-1312.5000000,1660.6999512,4.0000000,169.9969482,104,1,120); //Sanchez
	//--------------------------------------End of EU Vehs-----------------------------------//
	//-----------------------------------------IN Objects-----------------------------------//
    INTBM1 = CreateObject(3786,101.5000000,2954.8000488,22.8000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (1)
	INTBM2 = CreateObject(3786,102.1992188,2953.7998047,23.8000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (2)
	INTBM3 = CreateObject(3786,100.6999969,2956.1999512,21.3999996,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (3)
	INTBM4 = CreateObject(3786,102.8994141,2952.6992188,20.8000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (4)
	INMSAMM = CreateObject(3884,109.1999969,2954.5000000,25.3999996,0.0000000,0.0000000,0.0000000); //object(samsite_sfxrf) (1)
	INMRLM1 = CreateObject(3790,95.8000031,2954.8000488,14.5000000,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (1)
	INMRLM2 = CreateObject(3790,95.8994141,2952.0996094,18.3000002,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (2)
	INMRLM3 = CreateObject(3790,95.8994141,2952.6992188,16.6999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (3)
	INMRLM4 = CreateObject(3790,95.7998047,2953.3994141,21.0000000,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (4)
	INMRLM5 = CreateObject(3790,95.7998047,2954.0996094,22.1999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (5)
	INMRLM6 = CreateObject(3790,95.9000015,2956.5000000,22.6000004,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (6)
	INMRLM7 = CreateObject(3790,95.7998047,2955.3994141,22.8000002,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (7)
	INMRLM8 = CreateObject(3790,95.7998047,2956.0000000,22.1999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (8)
	INMRLH1 = CreateObject(3389,107.3000031,2949.8999023,25.5000000,0.0000000,0.0000000,0.0000000); //object(a51_srack1_) (1)
	INMRLH2 = CreateObject(3389,104.4000015,2950.3000488,26.2999992,0.0000000,0.0000000,0.0000000); //object(a51_srack1_) (2)
	INmovinggate1 = CreateObject(988,-380.6000061,2694.1999512,63.9000053,0.0000000,0.0000000,209.9981689); //object(ws_apgate) (4)
	INmovinggate2 = CreateObject(988,-143.5000000,2633.3000488,63.7599983,0.0000000,0.0000000,90.0000000); //object(ws_apgate) (1)
	CreateObject(4652,-186.8000031,2568.3999023,61.9000092,0.0000000,0.0000000,90.0000000); //object(road04_lan2) (1)
	CreateObject(8657,-177.4000092,2599.6000977,60.7999992,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (1)
	CreateObject(8657,-177.3994141,2568.5996094,60.7999992,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (2)
	CreateObject(8657,-177.3994141,2537.5996094,60.7999992,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (4)
	CreateObject(8657,-177.3994141,2535.9995117,60.7999992,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (5)
	CreateObject(8657,-178.5194244,2535.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (6)
	CreateObject(8657,-179.6385651,2596.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (7)
	CreateObject(8657,-180.7377014,2535.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (8)
	CreateObject(8657,-181.8372955,2535.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (9)
	CreateObject(8657,-182.9369202,2535.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (10)
	CreateObject(8657,-184.0365143,2535.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (11)
	CreateObject(8657,-184.9361267,2535.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (12)
	CreateObject(8657,-186.0355530,2535.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (13)
	CreateObject(8657,-187.1351471,2535.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (14)
	CreateObject(8657,-188.2347717,2535.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (15)
	CreateObject(8657,-189.3343811,2535.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (16)
	CreateObject(8657,-190.4339905,2535.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (17)
	CreateObject(8657,-191.5335999,2535.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (18)
	CreateObject(8657,-192.6332092,2535.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (19)
	CreateObject(8657,-193.7328186,2535.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (20)
	CreateObject(8657,-194.8324280,2535.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (21)
	CreateObject(8657,-195.9320374,2535.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (22)
	CreateObject(8657,-196.9316406,2535.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (23)
	CreateObject(8657,-178.5185547,2566.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (24)
	CreateObject(8657,-178.5185547,2596.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (25)
	CreateObject(8657,-179.6376953,2566.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (26)
	CreateObject(8657,-180.7373047,2566.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (27)
	CreateObject(8657,-180.7373047,2596.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (28)
	CreateObject(8657,-181.8369141,2566.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (29)
	CreateObject(8657,-181.8369141,2596.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (30)
	CreateObject(8657,-182.9365234,2566.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (31)
	CreateObject(8657,-182.9365234,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (32)
	CreateObject(8657,-179.6376953,2535.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (33)
	CreateObject(8657,-184.0361328,2566.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (34)
	CreateObject(8657,-184.0361328,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (35)
	CreateObject(8657,-184.9355469,2566.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (36)
	CreateObject(8657,-184.9355469,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (37)
	CreateObject(8657,-186.0351562,2566.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (38)
	CreateObject(8657,-186.0351562,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (39)
	CreateObject(8657,-187.1347656,2566.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (40)
	CreateObject(8657,-187.1347656,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (41)
	CreateObject(8657,-188.2343750,2566.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (42)
	CreateObject(8657,-188.2343750,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (43)
	CreateObject(8657,-189.3339844,2566.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (44)
	CreateObject(8657,-189.3339844,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (45)
	CreateObject(8657,-190.4335938,2566.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (46)
	CreateObject(8657,-190.4335938,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (47)
	CreateObject(8657,-191.5332031,2566.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (48)
	CreateObject(8657,-191.5332031,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (49)
	CreateObject(8657,-192.6328125,2566.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (50)
	CreateObject(8657,-192.6328125,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (51)
	CreateObject(8657,-193.7324219,2566.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (52)
	CreateObject(8657,-193.7324219,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (53)
	CreateObject(8657,-194.8320312,2566.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (54)
	CreateObject(8657,-194.8320312,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (55)
	CreateObject(8657,-195.9316406,2566.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (56)
	CreateObject(8657,-195.9316406,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (57)
	CreateObject(8657,-196.9316406,2566.9990234,60.7799988,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (58)
	CreateObject(8657,-196.9316406,2596.9990234,60.5799980,0.0000000,0.0000000,0.0000000); //object(shbbyhswall10_lvs) (59)
	CreateObject(3268,-289.6000061,2725.3999023,61.2000008,0.0000000,0.0000000,90.0000000); //object(mil_hangar1_) (2)
	CreateObject(3268,-222.6999969,2725.5000000,61.7000008,0.0000000,0.0000000,90.0000000); //object(mil_hangar1_) (4)
	CreateObject(3268,-222.1992188,2665.1992188,61.6999969,0.0000000,0.0000000,90.0000000); //object(mil_hangar1_) (5)
	CreateObject(8150,-335.7999878,2747.0000000,66.0099945,0.0000000,0.0000000,232.0000000); //object(vgsselecfence04) (1)
	CreateObject(8165,-164.2900085,2759.1999512,63.3999977,0.0000000,0.0000000,180.0000000); //object(vgsselecfence10) (1)
	CreateObject(8210,-147.6000061,2701.1999512,64.1600037,0.0000000,0.0000000,100.0000000); //object(vgsselecfence12) (1)
	CreateObject(3749,-143.8999939,2636.1999512,68.5999985,0.0000000,0.0000000,90.0000000); //object(clubgate01_lax) (1)
	CreateObject(8315,-143.8999939,2674.8999023,63.9000015,0.0000000,0.0000000,0.0000000); //object(vgsselecfence18) (1)
	CreateObject(988,-143.5000000,2639.2998047,63.7599983,0.0000000,0.0000000,90.0000000); //object(ws_apgate) (2)
	CreateObject(9241,-161.8000031,2662.8999023,63.3999977,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (1)
	CreateObject(9241,-163.3999939,2693.8999023,63.0000000,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (2)
	CreateObject(9241,-164.3000031,2722.1999512,62.6000023,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (3)
	CreateObject(9241,-174.0000000,2751.0000000,63.0000000,0.0000000,0.0000000,15); //object(copbits_sfn) (4)
	CreateObject(3279,-168.6000061,2621.0000000,61.2999992,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (1)
	CreateObject(3279,-201.5000000,2686.3999023,61.7000008,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (2)
	CreateObject(3279,-241.1999969,2650.3999023,61.7999992,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (3)
	CreateObject(3279,-268.1000061,2715.3999023,61.7000008,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (4)
	CreateObject(3279,-200.1999969,2738.1000977,61.7000008,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (5)
	CreateObject(987,-294.1000061,2584.3000488,59.0999985,0.0000000,350.0000000,135.0000000); //object(elecfence_bar) (2)
	CreateObject(987,-302.3999939,2592.6000977,61.0999985,0.0000000,349.9969482,135.0000000); //object(elecfence_bar) (3)
	CreateObject(987,-310.3999939,2600.6000977,63.2000008,0.0000000,357.0000000,135.0000000); //object(elecfence_bar) (4)
	CreateObject(987,-318.8999939,2609.1000977,63.5999985,0.0000000,358.0000000,135.0000000); //object(elecfence_bar) (5)
	CreateObject(3749,-382.8999939,2692.8000488,68.3000031,0.0000000,0.0000000,30.0000000); //object(clubgate01_lax) (2)
	CreateObject(3279,-352.2000122,2678.5000000,63.0000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (6)
	CreateObject(987,-327.2000122,2617.6000977,63.7999992,0.0000000,2.0000000,135.0000000); //object(elecfence_bar) (6)
	CreateObject(987,-335.7000122,2626.0000000,63.5000000,0.0000000,0.0000000,150.0000000); //object(elecfence_bar) (7)
	CreateObject(987,-346.1000061,2632.0000000,62.8999977,0.0000000,0.0000000,149.9963379); //object(elecfence_bar) (8)
	CreateObject(987,-356.5000000,2638.1000977,62.9000015,0.0000000,0.0000000,135.9963379); //object(elecfence_bar) (9)
	CreateObject(987,-365.1000061,2646.3000488,62.9000015,0.0000000,0.0000000,130.9942627); //object(elecfence_bar) (10)
	CreateObject(987,-372.8999939,2655.3999023,62.8999977,0.0000000,0.0000000,130.9899902); //object(elecfence_bar) (11)
	CreateObject(987,-380.7999878,2664.6000977,62.9000015,0.0000000,0.0000000,110.9899902); //object(elecfence_bar) (12)
	CreateObject(987,-385.1000061,2675.8000488,63.2999992,0.0000000,0.0000000,110.9893799); //object(elecfence_bar) (13)
	CreateObject(8150,-239.0000000,2790.2998047,65.0000000,0.0000000,0.0000000,179.9945068); //object(vgsselecfence04) (2)
	CreateObject(988,-385.6000061,2691.2998047,64.1999969,0.0000000,0.0000000,210.0000000); //object(ws_apgate) (3)
	CreateObject(3578,-184.5000000,2609.6000977,61.0229988,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (1)
	CreateObject(3578,-190.0000000,2609.5996094,61.0229988,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (2)
	CreateObject(3578,-187.6999969,2571.0000000,61.0228996,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (3)
	CreateObject(3578,-189.0000000,2609.5996094,61.0229988,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (4)
	CreateObject(3578,-186.5000000,2609.5996094,61.0229988,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (5)
	CreateObject(3578,-185.5000000,2609.5996094,61.0229988,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (6)
	CreateObject(3578,-187.6999969,2598.3000488,61.0228996,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (7)
	CreateObject(3578,-187.7000122,2584.8000488,61.0228996,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (8)
	CreateObject(3578,-191.0000000,2609.5996094,61.0229988,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (9)
	CreateObject(3578,-187.6999969,2557.1000977,61.0228996,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (10)
	CreateObject(3578,-187.6999969,2543.0000000,61.0228996,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (11)
	CreateObject(3578,-187.6999969,2528.6999512,61.0228996,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (12)
	CreateObject(2774,-179.5000000,2569.6000977,47.2999992,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (1)
	CreateObject(2774,-194.5000000,2569.5996094,47.2999992,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (2)
	CreateObject(2774,-194.5000000,2549.5996094,45.2999992,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (3)
	CreateObject(2774,-179.5000000,2549.5996094,41.2999992,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (4)
	CreateObject(2774,-179.5000000,2549.5996094,47.2999992,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (5)
	CreateObject(2774,-194.5000000,2549.5996094,47.2999992,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (6)
	CreateObject(2774,-179.5000000,2529.5996094,47.2999992,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (7)
	CreateObject(2774,-179.5000000,2529.5996094,39.2999992,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (8)
	CreateObject(2774,-194.5000000,2529.5996094,41.2999992,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (9)
	CreateObject(2774,-194.5000000,2529.5996094,47.2999992,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (10)
	CreateObject(3623,-209.8000031,2770.8999023,65.2000015,0.0000000,0.0000000,270.0000000); //object(rdwarhus2) (1)
	CreateObject(3268,-253.8999939,2771.8000488,60.6000023,0.0000000,0.0000000,90.0000000); //object(mil_hangar1_) (1)
	CreateObject(10763,-172.6999969,2621.5000000,74.0999985,0.0000000,0.0000000,140.0000000); //object(controltower_sfse) (1)
	//----------------------------------End of IN Objects----------------------------------------//
	//--------------------------------------------IN Vehs----------------------------------------//
	AddStaticVehicleEx(425,-160.5000000,2662.6000977,66.0999985,270.0000000,-1,-1,120); //Hunter
	AddStaticVehicleEx(425,-161.3999939,2693.6000977,65.6999969,270.0000000,-1,-1,120); //Hunter
	AddStaticVehicleEx(447,-164.5000000,2722.0000000,64.5000000,270.0000000,-1,-1,120); //Seasparrow
	AddStaticVehicleEx(487,-173.3000031,2750.3999023,65.0999985,285.0000000,104,0,120); //Maverick
	AddStaticVehicleEx(520,-302.1000061,2608.8000488,65.0999985,330.0000000,-1,-1,120); //Hydra
	AddStaticVehicleEx(520,-291.8999939,2603.0000000,64.5999985,329.9963379,-1,-1,120); //Hydra
	AddStaticVehicleEx(520,-312.2000122,2614.6000977,65.5000000,330.0000000,-1,-1,120); //Hydra
	AddStaticVehicleEx(470,-246.8999939,2764.3999023,62.7999992,180.0000000,-1,-1,120); //Patriot
	AddStaticVehicleEx(470,-253.8994141,2772.3994141,62.7999992,180.0000000,-1,-1,120); //Patriot
	AddStaticVehicleEx(470,-246.8994141,2772.3994141,62.7999992,180.0000000,-1,-1,120); //Patriot
	AddStaticVehicleEx(470,-253.8994141,2764.3994141,62.7999992,180.0000000,-1,-1,120); //Patriot
	AddStaticVehicleEx(468,-257.7999878,2764.3000488,62.2000008,180.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(468,-260.7999878,2764.3000488,62.2000008,180.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(468,-257.7998047,2772.2998047,62.2000008,180.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(468,-260.7998047,2772.2998047,62.2000008,180.0000000,104,1,120); //Sanchez
	//----------------------------------End of IN Vehs------------------------------------------//
	//--------------------------------------RU Vehs--------------------------------------------//
	AddStaticVehicleEx(520,843.0999800,2080.3999000,11.7000000,0.0000000,-1,-1,120); //Hydra
	AddStaticVehicleEx(520,837.7998000,2071.6006000,11.5000000,0.0000000,-1,-1,120); //Hydra
	AddStaticVehicleEx(520,848.5000000,2071.6006000,11.5000000,0.0000000,-1,-1,120); //Hydra
	AddStaticVehicleEx(470,812.0100100,2102.8000000,11.7000000,0.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(470,812.2998000,2092.7998000,11.7000000,0.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(470,828.2998000,2092.7998000,11.7000000,0.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(470,828.2998000,2102.7998000,11.7000000,0.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(425,836.5999800,2271.8999000,14.2000000,0.0000000,95,10,120); //Hunter
	AddStaticVehicleEx(425,807.4000200,2271.6001000,13.6000000,0.0000000,95,10,120); //Hunter
	AddStaticVehicleEx(487,836.2999900,2242.0000000,13.1000000,0.0000000,104,0,120); //Maverick
	AddStaticVehicleEx(447,807.5000000,2242.8999000,11.9000000,0.0000000,32,32,120); //Seasparrow
	AddStaticVehicleEx(468,835.0000000,2153.7000000,10.5000000,90.0000000,110,1,120); //Sanchez
	AddStaticVehicleEx(468,835.0000000,2155.8999000,10.5000000,90.0000000,110,1,120); //Sanchez
	AddStaticVehicleEx(468,831.0000000,2153.7002000,10.5000000,90.0000000,110,1,120); //Sanchez
	AddStaticVehicleEx(468,831.0000000,2155.9004000,10.5000000,90.0000000,110,1,120); //Sanchez
	//---------------------------------End of RU Vehs---------------------------------------------//
	//------------------------------------RU Objects---------------------------------------------//
	RUTBM1 = CreateObject(3786,105.5000000,2953.8000488,13.9000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (1)
	RUTBM2 = CreateObject(3786,98.1992188,2952.7998047,13.0000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (2)
	RUTBM3 = CreateObject(3786,110.6999969,2958.1999512,9.3999996,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (3)
	RUTBM4 = CreateObject(3786,122.8994141,2950.6992188,12.5000002,0.0000000,0.0000000,0.0000000); //object(missile_05_sfxr) (4)
	RUMSAMM = CreateObject(3884,131.1999969,2950.5000000,40.3999996,0.0000000,0.0000000,0.0000000); //object(samsite_sfxrf) (1)
	RUMRLM1 = CreateObject(3790,180.8000031,2954.8000488,31.5000000,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (1)
	RUMRLM2 = CreateObject(3790,143.8994141,2957.0996094,27.8000002,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (2)
	RUMRLM3 = CreateObject(3790,91.8994141,2950.6992188,23.6999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (3)
	RUMRLM4 = CreateObject(3790,87.7998047,2952.3994141,31.0000000,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (4)
	RUMRLM5 = CreateObject(3790,129.7998047,2963.0996094,50.1999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (5)
	RUMRLM6 = CreateObject(3790,143.9000015,2956.5000000,34.6000004,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (6)
	RUMRLM7 = CreateObject(3790,86.7998047,2885.3994141,37.8000002,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (7)
	RUMRLM8 = CreateObject(3790,163.7998047,2956.0000000,33.1999998,0.0000000,0.0000000,0.0000000); //object(missile_01_sfxr) (8)
	RUMRLH1 = CreateObject(3389,117.3000031,2922.8999023,30.7000000,0.0000000,0.0000000,0.0000000); //object(a51_srack1_) (1)
	RUMRLH2 = CreateObject(3389,180.4000015,2980.3000488,39.2999992,0.0000000,0.0000000,0.0000000); //object(a51_srack1_) (2
	RUmovinggate = CreateObject(989,765.9000200,2288.8999000,11.1000000,0.0000000,0.0000000,140.0000000); //object(ac_apgate) (1)
	CreateObject(989,761.0000000,2285.7000000,11.1000000,0.0000000,0.0000000,139.9990000); //object(ac_apgate) (2)
	CreateObject(987,881.7000100,2063.8999000,9.8000000,0.0000000,0.0000000,180.0000000); //object(elecfence_bar) (1)
	CreateObject(987,893.7000100,2063.9004000,9.8000000,0.0000000,0.0000000,179.9950000); //object(elecfence_bar) (2)
	CreateObject(987,869.7002000,2063.9004000,9.8000000,0.0000000,0.0000000,179.9950000); //object(elecfence_bar) (3)
	CreateObject(987,821.7002000,2063.9004000,9.8000000,0.0000000,0.0000000,179.9950000); //object(elecfence_bar) (4)
	CreateObject(987,857.7002000,2063.9004000,9.8000000,0.0000000,0.0000000,179.9950000); //object(elecfence_bar) (5)
	CreateObject(987,845.7002000,2063.9004000,9.8000000,0.0000000,0.0000000,179.9950000); //object(elecfence_bar) (6)
	CreateObject(987,833.7002000,2063.9004000,9.8000000,0.0000000,0.0000000,179.9950000); //object(elecfence_bar) (7)
	CreateObject(987,893.8001700,2075.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (8)
	CreateObject(987,893.7998000,2087.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (9)
	CreateObject(987,893.7998000,2099.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (10)
	CreateObject(987,893.7998000,2111.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (11)
	CreateObject(987,893.7998000,2123.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (12)
	CreateObject(987,893.7998000,2135.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (13)
	CreateObject(987,893.7998000,2147.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (14)
	CreateObject(987,893.7998000,2159.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (15)
	CreateObject(987,893.7998000,2171.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (16)
	CreateObject(987,893.7998000,2183.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (17)
	CreateObject(987,893.7998000,2195.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (18)
	CreateObject(987,893.7998000,2207.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (19)
	CreateObject(987,893.7998000,2219.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (20)
	CreateObject(987,893.7998000,2231.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (21)
	CreateObject(987,893.7998000,2243.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (22)
	CreateObject(987,893.7998000,2255.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (23)
	CreateObject(987,893.7998000,2267.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (24)
	CreateObject(987,881.7998000,2292.0005000,9.8000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (25)
	CreateObject(987,893.7998000,2279.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (26)
	CreateObject(987,893.7998000,2291.9004000,9.8000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (27)
	CreateObject(987,869.7998000,2292.0010000,9.8000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (28)
	CreateObject(987,857.7998000,2292.0010000,9.8000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (29)
	CreateObject(987,845.7998000,2292.0010000,9.8000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (30)
	CreateObject(987,833.7998000,2292.0010000,9.8000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (31)
	CreateObject(987,821.7998000,2292.0010000,9.8000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (32)
	CreateObject(987,809.7998000,2292.0010000,9.8000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (33)
	CreateObject(987,797.7998000,2292.0010000,9.8000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (34)
	CreateObject(987,785.7998000,2292.0010000,10.3000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (35)
	CreateObject(987,797.7998000,2292.0010000,10.0000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (36)
	CreateObject(987,773.7998000,2292.0010000,9.7000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (37)
	CreateObject(987,805.7763700,2147.9004000,9.7900000,0.0000000,1.0000000,99.0000000); //object(elecfence_bar) (38)
	CreateObject(987,809.7002000,2064.0010000,9.8000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (39)
	CreateObject(987,809.7002000,2076.0010000,9.8000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (40)
	CreateObject(987,809.7002000,2088.0010000,9.8000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (41)
	CreateObject(987,809.7002000,2100.0010000,9.8000000,0.0000000,0.0000000,93.9990000); //object(elecfence_bar) (42)
	CreateObject(987,808.8798800,2112.0010000,9.8000000,0.0000000,0.0000000,93.9990000); //object(elecfence_bar) (43)
	CreateObject(987,808.0517600,2124.0010000,9.8000000,0.0000000,0.0000000,93.9990000); //object(elecfence_bar) (44)
	CreateObject(987,807.2314500,2136.0010000,9.8000000,0.0000000,0.0000000,96.9980000); //object(elecfence_bar) (45)
	CreateObject(987,797.3400300,2183.0000000,8.8400000,0.0000000,0.3000000,110.9980000); //object(elecfence_bar) (46)
	CreateObject(987,803.9765600,2159.7002000,9.6000000,0.0000000,2.8950000,103.9970000); //object(elecfence_bar) (47)
	CreateObject(987,801.0263700,2171.6006000,9.0000000,0.0000000,0.0990000,107.9960000); //object(elecfence_bar) (48)
	CreateObject(987,779.4000200,2227.3000000,8.6000000,0.0000000,0.2970000,114.9950000); //object(elecfence_bar) (49)
	CreateObject(987,793.0400400,2194.2002000,8.7000000,0.0000000,0.2970000,110.9950000); //object(elecfence_bar) (50)
	CreateObject(987,788.7197300,2205.4004000,8.6000000,0.0000000,0.2970000,110.9950000); //object(elecfence_bar) (51)
	CreateObject(987,784.4003900,2216.5000000,8.6000000,0.0000000,0.2910000,114.9940000); //object(elecfence_bar) (52)
	CreateObject(987,764.2000100,2259.8000000,9.0000000,0.0000000,0.2910000,114.9940000); //object(elecfence_bar) (53)
	CreateObject(987,774.4003900,2238.2002000,8.7000000,0.0000000,0.2910000,114.9940000); //object(elecfence_bar) (54)
	CreateObject(987,769.2998000,2249.0000000,8.8000000,0.0000000,0.2910000,114.9940000); //object(elecfence_bar) (55)
	CreateObject(987,759.0999800,2270.3999000,9.2000000,0.0000000,0.2910000,114.9940000); //object(elecfence_bar) (56)
	CreateObject(3749,764.0000000,2286.6001000,15.1000000,0.0000000,0.0000000,30.0000000); //object(clubgate01_lax) (1)
	CreateObject(992,772.0999800,2291.3000000,11.2000000,0.0000000,0.0000000,10.0000000); //object(bar_barrier10b) (1)
	CreateObject(992,755.9003900,2281.7998000,11.0000000,0.0000000,0.0000000,29.9980000); //object(bar_barrier10b) (2)
	CreateObject(8355,873.4000200,2135.5000000,9.9000000,0.0000000,0.0000000,180.0000000); //object(vgssairportland18) (1)
	CreateObject(8355,873.4003900,2221.5000000,9.8300000,0.0000000,0.0000000,0.0000000); //object(vgssairportland18) (2)
	CreateObject(9241,836.5000000,2269.7998000,11.5000000,0.0000000,0.0000000,90.0000000); //object(copbits_sfn) (1)
	CreateObject(9241,807.5000000,2269.7998000,10.9000000,358.9950000,0.0000000,90.0000000); //object(copbits_sfn) (2)
	CreateObject(9241,807.5000000,2239.7998000,10.0000000,359.8000000,0.0000000,90.0000000); //object(copbits_sfn) (1)
	CreateObject(9241,836.5000000,2239.7998000,11.0000000,359.8000000,0.0000000,90.0000000); //object(copbits_sfn) (1)
	CreateObject(8251,839.2999900,2156.3999000,13.2000000,0.0000000,0.0000000,180.0000000); //object(pltschlhnger02_lvs) (1)
	CreateObject(3791,843.5000000,2187.2000000,10.3000000,0.0000000,0.0000000,0.0000000); //object(missile_10_sfxr) (1)
	CreateObject(3791,843.2999900,2189.5000000,10.3000000,0.0000000,0.0000000,40.0000000); //object(missile_10_sfxr) (2)
	CreateObject(3795,845.2000100,2192.5000000,10.2000000,0.0000000,0.0000000,340.0000000); //object(missile_04_sfxr) (1)
	CreateObject(3794,843.0999800,2196.3999000,10.4000000,0.0000000,0.0000000,90.0000000); //object(missile_07_sfxr) (1)
	CreateObject(3791,848.0999800,2201.3999000,10.3000000,0.0000000,0.0000000,50.0000000); //object(missile_10_sfxr) (3)
	CreateObject(3791,843.9000200,2203.2000000,10.3000000,0.0000000,0.0000000,0.0000000); //object(missile_10_sfxr) (4)
	CreateObject(8251,839.2998000,2196.4004000,13.2000000,0.0000000,0.0000000,179.9950000); //object(pltschlhnger02_lvs) (2)
	CreateObject(3279,828.7000100,2216.3000000,9.4000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (1)
	CreateObject(3279,779.4003900,2286.1006000,9.3100000,0.0000000,0.0000000,299.9980000); //object(a51_spottower) (2)
	CreateObject(3279,829.0000000,2176.6001000,9.3500000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (3)
	CreateObject(7981,842.5999800,2121.3000000,14.8000000,0.0000000,0.0000000,90.0000000); //object(smallradar02_lvs) (1)
	CreateObject(1682,843.9000200,2125.6001000,26.3000000,0.0000000,0.0000000,270.0000000); //object(ap_radar1_01) (1)
	//----------------------------------------End of RU Objects--------------------------------------------------------//
	//------------------------------------Nuclear Silo Launch Station------------------------------------------------//
 	/*
	CreateObject(17049,1041.6000000,2619.0000000,27.1000000,0.0000000,0.0000000,90.0000000); //object(cw_silo01) (1)
	CreateObject(16532,1061.0000000,2654.3999000,14.5000000,0.0000000,0.0000000,0.0000000); //object(des_oilpipe_05) (1)
	CreateObject(10965,985.9000200,2660.8999000,15.6000000,0.0000000,0.0000000,0.0000000); //object(depot_sfs) (1)
	CreateObject(6928,1127.9000000,2540.8999000,19.1000000,0.0000000,0.0000000,0.0000000); //object(vegasplant03) (1)
	CreateObject(11081,1104.4000000,2651.6001000,14.6400000,0.0000000,0.0000000,0.0000000); //object(crackfacttanks_sfs) (1)
	CreateObject(11290,1074.8000000,2672.1001000,15.6000000,0.0000000,0.0000000,0.0000000); //object(facttanks_sfse04) (1)
	CreateObject(6928,1036.8000000,2715.8000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(vegasplant03) (2)
	CreateObject(6932,1090.1000000,2634.2000000,43.7000000,0.0000000,0.0000000,0.0000000); //object(vegasplant07) (1)
	CreateObject(6929,1037.1000000,2627.0000000,19.0000000,0.0000000,0.0000000,0.0000000); //object(vegasplant04) (1)
	CreateObject(17049,1041.5996000,2634.7002000,27.1000000,0.0000000,0.0000000,90.0000000); //object(cw_silo01) (2)
	CreateObject(7024,1107.5000000,2584.0000000,13.9000000,0.0000000,0.0000000,0.0000000); //object(vegasplant069) (1)
	CreateObject(6928,1026.9003900,2688.4003900,19.1000000,0.0000000,0.0000000,0.0000000); //object(vegasplant03) (3)
	CreateObject(3636,1152.0000000,2580.8000000,17.4000000,0.0000000,0.0000000,179.9950000); //object(indust1las_las) (1)
	CreateObject(3567,1115.0000000,2578.8000000,10.7000000,0.0000000,0.0000000,2.0000000); //object(lasnfltrail) (1)
	CreateObject(17049,1136.8000000,2601.7000000,15.4000000,340.0000000,270.0000000,0.0000000); //object(cw_silo01) (3)
	CreateObject(17049,1114.9000000,2567.2000000,15.4000000,339.9990000,270.0000000,270.0000000); //object(cw_silo01) (4)
	CreateObject(3567,1125.4004000,2601.6006000,10.7000000,0.0000000,0.0000000,90.0000000); //object(lasnfltrail) (2)
	CreateObject(17049,1090.9000000,2613.3999000,15.4000000,339.9990000,270.0000000,90.0000000); //object(cw_silo01) (5)
	CreateObject(3567,1090.8999000,2601.5000000,10.7000000,0.0000000,0.0000000,180.0000000); //object(lasnfltrail) (3)
	CreateObject(7103,1096.5000000,2590.1001000,19.2000000,0.0000000,0.0000000,0.0000000); //object(vgnplantwalk) (1)
	CreateObject(7105,1103.9000000,2584.0000000,14.2000000,0.0000000,0.0000000,0.0000000); //object(vegasplant0692) (2)
	CreateObject(3798,1065.9000000,2574.3999000,9.8000000,0.0000000,0.0000000,0.0000000); //object(acbox3_sfs) (2) */
	CreateObject(8151,980.5000000,2697.8000000,14.2000000,0.0000000,0.0000000,65.0000000); //object(vgsselecfence05) (2)
	CreateObject(6928,978.4000200,2630.2000000,35.2000000,0.0000000,0.0000000,0.0000000); //object(vegasplant03) (1)
	CreateObject(6928,1138.6000000,2635.8000000,35.5000000,0.0000000,0.0000000,0.0000000); //object(vegasplant03) (2)
	CreateObject(7024,985.0000000,2675.0999000,13.5000000,0.0000000,0.0000000,324.9980000); //object(vegasplant069) (1)
	CreateObject(17049,1020.0996000,2643.9004000,26.0000000,0.0000000,0.0000000,164.9980000); //object(cw_silo01) (1)
	CreateObject(17049,1029.4000000,2656.3999000,26.0000000,0.0000000,0.0000000,164.9980000); //object(cw_silo01) (2)
	CreateObject(6930,1028.0000000,2647.1001000,19.0000000,0.0000000,0.0000000,322.0000000); //object(vegasplant05) (1)
	CreateObject(8150,1059.8000000,2695.7000000,12.9000000,0.0000000,0.0000000,334.9950000); //object(vgsselecfence04) (1)
	CreateObject(8151,1126.5000000,2621.2000000,14.2000000,0.0000000,0.0000000,334.9900000); //object(vgsselecfence05) (3)
	CreateObject(8151,948.9000200,2649.6001000,14.2000000,0.0000000,0.0000000,155.0000000); //object(vgsselecfence05) (4)
	CreateObject(971,962.5999800,2602.7000000,13.0000000,0.0000000,0.0000000,14.9960000); //object(subwaygate) (1)
	CreateObject(971,974.0000000,2591.6001000,13.0000000,0.0000000,0.0000000,189.9980000); //object(subwaygate) (2)
	CreateObject(8150,1035.3000000,2565.5000000,12.9000000,0.0000000,0.0000000,334.9950000); //object(vgsselecfence04) (2)
	CreateObject(8151,1095.1000000,2572.8999000,14.2000000,0.0000000,0.0000000,245.0000000); //object(vgsselecfence05) (5)
	CreateObject(1337,1012.4000000,2440.1001000,74.1000000,0.0000000,0.0000000,0.0000000); //object(binnt07_la) (4)
	CreateObject(10965,1078.2998000,2574.5000000,23.9000000,0.0000000,0.0000000,64.9950000); //object(depot_sfs) (1)
	CreateObject(3567,969.7000100,2707.8999000,10.7000000,0.0000000,0.0000000,150.0000000); //object(lasnfltrail) (1)
	CreateObject(17049,1009.5996000,2694.5000000,15.5000000,339.9990000,270.0000000,59.9960000); //object(cw_silo01) (1)
	CreateObject(3567,1004.8000000,2686.7000000,10.7000000,0.0000000,0.0000000,149.9960000); //object(lasnfltrail) (2)
	CreateObject(17049,975.5999800,2718.0000000,15.5000000,339.9990000,270.0000000,59.9960000); //object(cw_silo01) (1)
	CreateObject(3567,975.2000100,2675.2000000,10.7000000,0.0000000,0.0000000,324.0040000); //object(lasnfltrail) (3)
	CreateObject(17049,968.9000200,2667.0000000,15.5000000,339.9990000,270.0000000,233.9960000); //object(cw_silo01) (1)
	CreateObject(17016,1125.4000000,2585.3999000,62.0000000,0.0000000,0.0000000,335.0000000); //object(cutnwplant09) (1)
	CreateObject(17016,935.5000000,2629.3000000,62.0000000,0.0000000,0.0000000,230.0000000); //object(cutnwplant09) (2)
	CreateObject(7103,982.5999800,2684.2002000,19.1500000,0.0000000,0.0000000,325.0000000); //object(vgnplantwalk) (1)
	CreateObject(7105,985.4000200,2675.0000000,14.2000000,0.0000000,0.0000000,325.0000000); //object(vegasplant0692) (1)
	//---------------------------------End of Nuclear Silo Launch Station---------------------------------------------//
	//--------------------------------------------VIP Room------------------------------------------------------------//
	new OffWalls[52], Floor[15];
	CreateObject(2290,1481.4000000,-3593.2000000,57.4000000,0.0000000,0.0000000,90.0000000); //object(swk_couch_1) (1)
	CreateObject(2357,1486.3000000,-3597.1001000,57.8000000,0.0000000,0.0000000,0.0000000); //object(dunc_dinning) (1)
	CreateObject(741,1481.4000000,-3587.5000000,57.7000000,0.0000000,0.0000000,0.0000000); //object(pot_01) (1)
	CreateObject(904,1491.2999000,-3599.9900000,57.0000000,0.0000000,0.0000000,0.0000000); //object(sand_josh1) (1)
	CreateObject(1705,1487.9000000,-3595.2000000,57.4000000,0.0000000,0.0000000,270.0000000); //object(kb_chair04) (1)
	CreateObject(1705,1484.7000000,-3596.2002000,57.4000000,0.0000000,0.0000000,90.0000000); //object(kb_chair04) (2)
	CreateObject(1714,1486.2000000,-3598.9702000,57.4000000,0.0000000,0.0000000,180.0000000); //object(kb_swivelchair1) (1)
	CreateObject(2290,1491.4004000,-3591.2002000,57.4000000,0.0000000,0.0000000,270.0000000); //object(swk_couch_1) (2)
	CreateObject(1742,1483.9000000,-3600.6001000,57.4000000,0.0000000,0.0000000,180.0000000); //object(med_bookshelf) (1)
	CreateObject(2108,1488.1000000,-3598.0000000,57.4000000,0.0000000,0.0000000,0.0000000); //object(cj_mlight13) (1)
	CreateObject(2108,1488.0996000,-3598.0000000,57.4000000,0.0000000,0.0000000,0.0000000); //object(cj_mlight13) (2)
	CreateObject(2108,1484.3995000,-3598.0000000,57.4000000,0.0000000,0.0000000,0.0000000); //object(cj_mlight13) (3)
	CreateObject(1620,1490.8009000,-3586.9502000,60.2000000,0.0000000,0.0000000,0.0000000); //object(nt_vent2_01) (1)
	CreateObject(741,1491.4000000,-3598.3000000,57.7000000,0.0000000,0.0000000,0.0000000); //object(pot_01) (2)
	CreateObject(904,1481.2998000,-3589.0996000,57.0100000,0.0000000,0.0000000,0.0000000); //object(sand_josh1) (2)
	CreateObject(14750,1291.4000000,-3669.5000000,60.0000000,0.0000000,0.0000000,0.0000000); //object(sfhsm2) (1)
	CreateObject(14389,1479.0996000,-3624.5996000,60.6000000,0.0000000,0.0000000,0.0000000); //object(madddoggs03) (1)
	CreateObject(1557,1475.8000000,-3599.8691000,57.4000000,0.0000000,0.0000000,270.0000000); //object(gen_doorext19) (1)
	CreateObject(1557,1475.7998000,-3602.8994000,57.4000000,0.0000000,0.0000000,90.0000000); //object(gen_doorext19) (2)
	CreateObject(1557,1471.6000000,-3592.1001000,57.4000000,0.0000000,0.0000000,90.0000000); //object(gen_doorext19) (3)
	CreateObject(1557,1492.1500000,-3580.4001000,57.3500000,0.0000000,0.0000000,270.0000000); //object(gen_doorext19) (4)
	CreateObject(1557,1492.1504000,-3583.4004000,57.3500000,0.0000000,0.0000000,90.0000000); //object(gen_doorext19) (5)
	CreateObject(1557,1485.2402000,-3587.3994000,57.3620000,0.0000000,0.0000000,0.0000000); //object(gen_doorext19) (7)
	CreateObject(1744,1486.0996000,-3576.2998000,57.9000000,0.0000000,0.0000000,0.0000000); //object(med_shelf) (1)
	CreateObject(1744,1489.0996000,-3576.2993000,57.9000000,0.0000000,0.0000000,0.0000000); //object(med_shelf) (2)
	CreateObject(356,1486.8000000,-3576.6399000,58.2799800,90.0000000,0.0000000,0.0000000); //object(1)
	CreateObject(2358,1486.2000000,-3576.7000000,58.3600000,0.0000000,0.0000000,0.0000000); //object(ammo_box_c2) (1)
	CreateObject(353,1486.1000000,-3576.7000000,58.5300000,90.0000000,0.0000000,0.0000000); //object(2)
	CreateObject(348,1487.2001000,-3576.4998000,58.3100000,350.0000000,0.0000000,0.0000000); //object(4)
	CreateObject(2061,1487.7000000,-3576.5000000,57.6000000,0.0000000,0.0000000,0.0000000); //object(cj_shells1) (1)
	CreateObject(2061,1487.3000000,-3576.5000000,57.6000000,0.0000000,0.0000000,0.0000000); //object(cj_shells1) (2)
	CreateObject(360,1486.5000000,-3576.5000000,57.4100000,350.0000000,0.0000000,0.0000000); //object(3)
	CreateObject(358,1488.4000000,-3576.5999000,57.6000000,0.0000000,303.0000000,0.0000000); //object(6)
	CreateObject(343,1490.3000000,-3576.6001000,58.3300000,0.0000000,0.0000000,0.0000000); //object(7)
	CreateObject(343,1490.4004000,-3576.5996000,58.3300000,0.0000000,0.0000000,0.0000000); //object(8)
	CreateObject(343,1490.4004000,-3576.7998000,58.3300000,0.0000000,0.0000000,0.0000000); //object(9)
	CreateObject(343,1490.2998000,-3576.7998000,58.3300000,0.0000000,0.0000000,0.0000000); //object(10)
	CreateObject(858,1478.9000000,-3586.3000000,57.7000000,0.0000000,0.0000000,0.0000000); //object(sand_josh2) (1)
	CreateObject(801,1482.0000000,-3585.5000000,57.5000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush01) (1)
	CreateObject(1360,1488.0000000,-3586.8000000,57.7000000,0.0000000,0.0000000,90.0000000); //object(cj_bush_prop3) (1)
	CreateObject(858,1480.6000000,-3586.3000000,57.7000000,0.0000000,0.0000000,180.0000000); //object(sand_josh2) (2)
	CreateObject(801,1478.0000000,-3585.5000000,57.5000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush01) (2)
	CreateObject(1731,1487.9501000,-3587.1997000,60.3000000,0.0000000,0.0000000,270.0000000); //object(cj_mlight3) (1)
	CreateObject(1731,1478.3496000,-3578.5996000,60.3000000,0.0000000,0.0000000,90.0000000); //object(cj_mlight3) (2)
	CreateObject(1731,1481.9502000,-3578.5996000,60.3000000,0.0000000,0.0000000,90.0000000); //object(cj_mlight3) (3)
	CreateObject(1731,1486.2605000,-3576.5996000,60.3000000,0.0000000,0.0000000,90.0000000); //object(cj_mlight3) (4)
	CreateObject(1731,1475.5601000,-3596.7600000,60.3000000,0.0000000,0.0000000,0.0000000); //object(cj_mlight3) (5)
	CreateObject(1731,1475.5605000,-3589.3594000,60.3000000,0.0000000,0.0000000,0.0000000); //object(cj_mlight3) (6)
	CreateObject(362,1488.8000000,-3576.7800000,58.5000000,0.0000000,27.0000000,0.0000000); //object(12)
	CreateObject(1731,1489.6699000,-3576.5996000,60.3000000,0.0000000,0.0000000,90.0000000); //object(cj_mlight3) (7)
	CreateObject(2239,1491.0000000,-3583.8999000,57.4000000,0.0000000,0.0000000,20.0000000); //object(cj_mlight16) (1)
	CreateObject(2239,1491.0000000,-3579.8994000,57.4000000,0.0000000,0.0000000,19.9950000); //object(cj_mlight16) (2)
	Floor[0] = CreateObject(2395,1488.7800000,-3590.1001000,57.4000000,270.0000000,180.0000000,180.0000000); //object(cj_sports_wall) (1)
	Floor[1] = CreateObject(2395,1485.0803000,-3590.0996000,57.4000000,270.0000000,180.0000000,180.0000000); //object(cj_sports_wall) (2)
	Floor[2] = CreateObject(2395,1481.3604000,-3590.0996000,57.4000000,270.0000000,179.9950000,179.9950000); //object(cj_sports_wall) (3)
	Floor[3] = CreateObject(2395,1485.0903000,-3592.8396000,57.4000000,270.0000000,0.0000000,0.0000000); //object(cj_sports_wall) (4)
	Floor[4] = CreateObject(2395,1485.0918000,-3595.5801000,57.4000000,270.0000000,179.9950000,179.9950000); //object(cj_sports_wall) (5)
	Floor[5] = CreateObject(2395,1488.7908000,-3592.8398000,57.4000000,270.0000000,180.0000000,180.0000000); //object(cj_sports_wall) (6)
	Floor[6] = CreateObject(2395,1481.3604000,-3592.8398000,57.4000000,270.0000000,359.9960000,359.9960000); //object(cj_sports_wall) (7)
	Floor[7] = CreateObject(2395,1485.0903000,-3601.0581000,57.4000000,270.0000000,0.0000000,0.0000000); //object(cj_sports_wall) (8)
	Floor[8] = CreateObject(2395,1488.7917000,-3595.5801000,57.4000000,270.0000000,359.9960000,359.9960000); //object(cj_sports_wall) (9)
	Floor[9] = CreateObject(2395,1481.3604000,-3595.5801000,57.4000000,270.0000000,179.9950000,179.9950000); //object(cj_sports_wall) (10)
	Floor[10] = CreateObject(2395,1485.0903000,-3598.3184000,57.4000000,270.0000000,180.0000000,180.0000000); //object(cj_sports_wall) (11)
	Floor[11] = CreateObject(2395,1488.7908000,-3598.3184000,57.4000000,270.0000000,359.9960000,359.9960000); //object(cj_sports_wall) (12)
	Floor[12] = CreateObject(2395,1481.3604000,-3598.3184000,57.4000000,270.0000000,180.0000000,180.0000000); //object(cj_sports_wall) (13)
	Floor[13] = CreateObject(2395,1481.3604000,-3601.0576000,57.4000000,270.0000000,359.9960000,359.9960000); //object(cj_sports_wall) (14)
	Floor[14] = CreateObject(2395,1488.7908000,-3601.0576000,57.4000000,270.0000000,180.0000000,180.0000000); //object(cj_sports_wall) (15)
	OffWalls[0] = CreateObject(7921,1479.9004000,-3589.0195000,58.7000000,0.0000000,0.0000000,0.0000000); //object(vgwstnewall6904) (1)
	OffWalls[1] = CreateObject(7921,1479.9004000,-3592.3154000,58.7000000,0.0000000,0.0000000,0.0000000); //object(vgwstnewall6904) (2)
	OffWalls[2] = CreateObject(7921,1479.9004000,-3595.6152000,58.7000000,0.0000000,0.0000000,0.0000000); //object(vgwstnewall6904) (3)
	OffWalls[3] = CreateObject(7921,1479.9004000,-3598.6152000,58.7000000,0.0000000,0.0000000,0.0000000); //object(vgwstnewall6904) (4)
	OffWalls[4] = CreateObject(7921,1479.9004000,-3601.6152000,58.7000000,0.0000000,0.0000000,0.0000000); //object(vgwstnewall6904) (5)
	OffWalls[5] = CreateObject(7921,1482.5000000,-3601.6152000,58.7000000,0.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (6)
	OffWalls[6] = CreateObject(7921,1485.7998000,-3601.6152000,58.7000000,0.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (7)
	OffWalls[7] = CreateObject(7921,1489.0996000,-3601.6152000,58.7000000,0.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (8)
	OffWalls[8] = CreateObject(7921,1492.3994000,-3601.6152000,58.7000000,0.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (9)
	OffWalls[9] = CreateObject(7921,1492.9990000,-3598.9424000,58.7000000,0.0000000,0.0000000,179.9950000); //object(vgwstnewall6904) (10)
	OffWalls[10] = CreateObject(7921,1492.9990000,-3595.6318000,58.7000000,0.0000000,0.0000000,179.9950000); //object(vgwstnewall6904) (11)
	OffWalls[11] = CreateObject(7921,1492.9990000,-3592.3320000,58.7000000,0.0000000,0.0000000,179.9950000); //object(vgwstnewall6904) (12)
	OffWalls[12] = CreateObject(7921,1492.9990000,-3589.0322000,58.7000000,0.0000000,0.0000000,179.9950000); //object(vgwstnewall6904) (13)
	OffWalls[13] = CreateObject(7921,1482.2998000,-3588.5996000,58.1000000,270.0000000,181.1640000,271.1640000); //object(vgwstnewall6904) (1)
	OffWalls[14] = CreateObject(7921,1487.8497000,-3588.5996000,58.1000000,270.0000000,180.0000000,270.0000000); //object(vgwstnewall6904) (1)
	OffWalls[15] = CreateObject(7921,1485.0498000,-3588.5996000,58.1000000,270.0000000,359.9960000,90.0020000); //object(vgwstnewall6904) (1)
	OffWalls[16] = CreateObject(7921,1492.1791000,-3587.4998000,58.1000000,270.0000000,0.0000000,270.0000000); //object(vgwstnewall6904) (1)
	OffWalls[17] = CreateObject(7921,1479.9004000,-3589.0195000,61.5000000,0.0000000,0.0000000,0.0000000); //object(vgwstnewall6904) (1)
	OffWalls[18] = CreateObject(7921,1479.9004000,-3592.3154000,61.5000000,0.0000000,0.0000000,0.0000000); //object(vgwstnewall6904) (1)
	OffWalls[19] = CreateObject(7921,1479.9004000,-3595.6152000,61.5000000,0.0000000,0.0000000,0.0000000); //object(vgwstnewall6904) (1)
	OffWalls[20] = CreateObject(7921,1479.9004000,-3598.6152000,61.5000000,0.0000000,0.0000000,0.0000000); //object(vgwstnewall6904) (1)
	OffWalls[21] = CreateObject(7921,1479.9004000,-3601.6152000,61.5000000,0.0000000,0.0000000,0.0000000); //object(vgwstnewall6904) (1)
	OffWalls[22] = CreateObject(7921,1482.5000000,-3601.6152000,61.5000000,0.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (6)
	OffWalls[23] = CreateObject(7921,1485.7998000,-3601.6152000,61.5000000,0.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (7)
	OffWalls[24] = CreateObject(7921,1489.0996000,-3601.6152000,61.5000000,0.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (8)
	OffWalls[25] = CreateObject(7921,1492.3994000,-3601.6152000,61.5000000,0.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (9)
	OffWalls[26] = CreateObject(7921,1492.9990000,-3598.9424000,61.5000000,0.0000000,0.0000000,179.9950000); //object(vgwstnewall6904) (10)
	OffWalls[27] = CreateObject(7921,1492.9990000,-3595.6318000,61.5000000,0.0000000,0.0000000,179.9950000); //object(vgwstnewall6904) (11)
	OffWalls[28] = CreateObject(7921,1492.9990000,-3592.3320000,61.5000000,0.0000000,0.0000000,179.9950000); //object(vgwstnewall6904) (12)
	OffWalls[29] = CreateObject(7921,1492.9990000,-3589.0322000,61.5000000,0.0000000,0.0000000,179.9950000); //object(vgwstnewall6904) (13)
	OffWalls[30] = CreateObject(7921,1492.1787000,-3587.5000000,61.4010000,270.0000000,180.0000000,90.0000000); //object(vgwstnewall6904) (1)
	OffWalls[31] = CreateObject(7921,1489.3708000,-3588.6035000,61.4010000,90.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (1)
	OffWalls[32] = CreateObject(7921,1486.6309000,-3588.6035000,61.4010000,90.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (1)
	OffWalls[33] = CreateObject(7921,1483.8308000,-3588.6035000,61.4010000,90.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (1)
	OffWalls[34] = CreateObject(7921,1481.0510000,-3588.6035000,61.4010000,90.0000000,0.0000000,90.0000000); //object(vgwstnewall6904) (1)
	OffWalls[35] = CreateObject(7921,1482.3301000,-3590.0000000,63.1800000,0.0000000,90.0000000,180.0000000); //object(vgwstnewall6904) (1)
	OffWalls[36] = CreateObject(7921,1482.3301000,-3593.3003000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[37] = CreateObject(7921,1482.3301000,-3596.5999000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[38] = CreateObject(7921,1485.1200000,-3599.8997000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[39] = CreateObject(7921,1482.3301000,-3599.8994000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[40] = CreateObject(7921,1487.9202000,-3599.8994000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[41] = CreateObject(7921,1485.1201000,-3596.5996000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[42] = CreateObject(7921,1485.1201000,-3593.2998000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[43] = CreateObject(7921,1485.1201000,-3590.0000000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[44] = CreateObject(7921,1485.1201000,-3599.8994000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[45] = CreateObject(7921,1487.9202000,-3596.5996000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[46] = CreateObject(7921,1487.9202000,-3593.2998000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[47] = CreateObject(7921,1487.9202000,-3590.0000000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[48] = CreateObject(7921,1490.7200000,-3599.8994000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[49] = CreateObject(7921,1490.7200000,-3596.5996000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[50] = CreateObject(7921,1490.7200000,-3593.2998000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	OffWalls[51] = CreateObject(7921,1490.7200000,-3590.0000000,63.1800000,0.0000000,90.0000000,179.9950000); //object(vgwstnewall6904) (1)
	CreateObject(1557,1490.7000000,-3587.3750000,57.3500000,0.0000000,0.0000000,270.0000000); //object(gen_doorext19) (7)
	for(new a = 0; a < 52; a++)
	{
	    //SetObjectMaterial(OffWalls[a], 0, 6052, "law_doontoon", "gz_lawbuilda_7", 0xFF707070);
	    SetObjectMaterial(OffWalls[a], 0, 14389, "madpoolbit", "AH_bgmartiles", 0);
	}
	for(new b = 0; b < 15; b++)
	{
	    SetObjectMaterial(Floor[b], 0, -1, "none", "none", 0xFF894224);
	}
//---------------------------------------END of VIP Room--------------------------------------------------------------//
//---------------------------------------VIP Club--------------------------------------------------------------------//
	new BFboard;
	CreateObject(14623,764.2998000,-3324.2002000,641.0999800,0.0000000,0.0000000,0.0000000); //object(mafcasmain1) (1)
	CreateObject(14624,781.7998000,-3403.2598000,639.3900100,0.0000000,0.0000000,0.0000000); //object(mafcasmain2) (1)
	CreateObject(1557,760.8499800,-3286.0798000,639.5499900,0.0000000,0.0000000,0.0000000); //object(gen_doorext19) (1)
	CreateObject(1557,763.8800000,-3286.0801000,639.5499900,0.0000000,0.0000000,179.9950000); //object(gen_doorext19) (2)
	CreateObject(14606,724.4638100,-3398.3899000,638.0899700,0.0000000,0.0000000,0.0000000); //object(mafcasmain4) (1)
	CreateObject(14434,795.7000100,-3391.0000000,642.2999900,0.0000000,0.0000000,0.0000000); //object(carter-spotlight42) (1)
	CreateObject(14434,786.0999800,-3403.8000000,642.2999900,0.0000000,0.0000000,179.9950000); //object(carter-spotlight42) (2)
	CreateObject(14434,796.4000200,-3405.2000000,642.2999900,0.0000000,0.0000000,270.0000000); //object(carter-spotlight42) (1)
	CreateObject(14434,785.2000100,-3390.6001000,642.2999900,0.0000000,0.0000000,90.0000000); //object(carter-spotlight42) (1)
	CreateObject(14582,764.2999900,-3324.0000000,639.0000000,0.0000000,0.0000000,0.0000000); //object(mafiacasinobar1) (1)
	CreateObject(2232,764.2000100,-3322.7000000,642.0000000,0.0000000,0.0000000,184.0000000); //object(med_speaker_4) (1)
	CreateObject(2232,764.2002000,-3325.3003000,642.0000000,0.0000000,0.0000000,3.9990000); //object(med_speaker_4) (2)
	CreateObject(2780,804.4000200,-3382.8000000,632.9000200,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach) (1)
	CreateObject(2780,780.0000000,-3383.3000000,632.9000200,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach) (2)
	CreateObject(2780,778.7000100,-3412.0000000,632.9000200,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach) (3)
	CreateObject(2780,804.4000200,-3412.0000000,632.9000200,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach) (4)
	CreateObject(2229,776.0999800,-3404.7000000,633.4000200,0.0000000,0.0000000,90.0000000); //object(swank_speaker) (1)
	CreateObject(2229,776.0999800,-3388.7000000,633.4000200,0.0000000,0.0000000,90.0000000); //object(swank_speaker) (2)
	CreateObject(2232,776.2002000,-3396.7002000,634.0000000,0.0000000,0.0000000,90.0000000); //object(med_speaker_4) (3)
	CreateObject(2232,776.2002000,-3399.2002000,634.0000000,0.0000000,0.0000000,90.0000000); //object(med_speaker_4) (4)
	CreateObject(2232,776.2998000,-3394.0996000,634.0000000,0.0000000,0.0000000,90.0000000); //object(med_speaker_4) (5)
	CreateObject(2229,775.2999900,-3390.2000000,633.4000200,0.0000000,0.0000000,90.0000000); //object(swank_speaker) (3)
	CreateObject(2229,774.5000000,-3391.8999000,633.4000200,0.0000000,0.0000000,90.0000000); //object(swank_speaker) (4)
	CreateObject(2229,775.4000200,-3402.3999000,633.4000200,0.0000000,0.0000000,90.0000000); //object(swank_speaker) (5)
	CreateObject(2229,774.2000100,-3400.6001000,633.4000200,0.0000000,0.0000000,90.0000000); //object(swank_speaker) (6)
	CreateObject(3462,769.8000500,-3344.1001000,637.0999800,0.0000000,0.0000000,0.0000000); //object(csrangel_lvs) (2)
	CreateObject(3462,758.7003800,-3344.0996000,637.0999800,0.0000000,0.0000000,180.0000000); //object(csrangel_lvs) (3)
	CreateObject(3462,769.8000500,-3361.6001000,637.0999800,0.0000000,0.0000000,0.0000000); //object(csrangel_lvs) (4)
	CreateObject(3462,758.9003900,-3361.5996000,637.0999800,0.0000000,0.0000000,179.9950000); //object(csrangel_lvs) (5)
	CreateObject(3462,759.0000000,-3353.1001000,637.0999800,0.0000000,0.0000000,179.9950000); //object(csrangel_lvs) (6)
	CreateObject(3462,769.8000500,-3353.0000000,637.0999800,0.0000000,0.0000000,0.0000000); //object(csrangel_lvs) (7)
	CreateObject(16151,763.0950300,-3395.2000000,633.7000100,0.0000000,0.0000000,0.0000000); //object(ufo_bar) (1)
	CreateObject(16151,765.4502000,-3395.2002000,633.7000100,0.0000000,0.0000000,179.9950000); //object(ufo_bar) (2)
	CreateObject(2290,754.0999800,-3383.1001000,633.4000200,0.0000000,0.0000000,90.0000000); //object(swk_couch_1) (1)
	CreateObject(2290,754.0999800,-3387.8000000,633.4000200,0.0000000,0.0000000,90.0000000); //object(swk_couch_1) (2)
	CreateObject(1557,721.0000000,-3396.3999000,633.3000500,0.0000000,0.0000000,0.0000000); //object(gen_doorext19) (4)
	CreateObject(1557,721.0000000,-3396.4094000,633.5000600,0.0000000,0.0000000,0.0000000); //object(gen_doorext19) (5)
	BFboard = CreateObject(7301,761.9000200,-3304.6001000,643.0000000,0.0000000,0.0000000,315.0000000); //object(vgsn_addboard03) (1)
	CreateObject(1660,773.5999800,-3300.2000000,634.9099700,344.0000000,0.0000000,0.0000000); //object(ramp) (1)
	CreateObject(1660,773.5999800,-3293.2000000,636.9990200,343.9980000,0.0000000,0.0000000); //object(ramp) (2)
	CreateObject(1660,768.3300200,-3293.2000000,637.0000000,343.9980000,0.0000000,0.0000000); //object(ramp) (3)
	CreateObject(1660,763.2999900,-3293.1001000,637.0000000,343.9980000,0.0000000,0.0000000); //object(ramp) (4)
	CreateObject(1660,758.0999800,-3293.0000000,637.0000000,343.9980000,0.0000000,0.0000000); //object(ramp) (5)
	CreateObject(1660,752.7999900,-3293.1001000,637.0000000,343.9980000,0.0000000,0.0000000); //object(ramp) (6)
	CreateObject(1660,763.2999900,-3300.2002000,634.9099700,343.9980000,0.0000000,0.0000000); //object(ramp) (7)
	CreateObject(1660,758.0996100,-3293.0000000,637.0000000,343.9980000,0.0000000,0.0000000); //object(ramp) (8)
	CreateObject(1660,758.0996100,-3300.2002000,634.9099700,343.9980000,0.0000000,0.0000000); //object(ramp) (9)
	CreateObject(1660,768.3300200,-3300.2002000,634.9099700,343.9980000,0.0000000,0.0000000); //object(ramp) (10)
	CreateObject(1660,752.7998000,-3300.2002000,634.9099700,343.9980000,0.0000000,0.0000000); //object(ramp) (11)
	CreateObject(18092,775.0000000,-3396.6399000,634.0000000,0.0000000,0.0000000,270.0000000); //object(ammun3_counter) (1)
	CreateObject(1954,775.2000100,-3395.2000000,634.5999800,0.0000000,0.0000000,0.0000000); //object(turn_table_r) (1)
	CreateObject(1954,775.2099600,-3398.2000000,634.5999800,0.0000000,0.0000000,0.0000000); //object(turn_table_r) (2)
	CreateObject(14820,775.2000100,-3396.7002000,634.5999800,0.0000000,0.0000000,90.0000000); //object(dj_stuff) (2)
	CreateObject(19129,804.0510,-3389.7026,633.4744,0,0,0);
	CreateObject(19129,784.0206,-3389.7026,633.4807,0,0,0);
	CreateObject(19129,784.0206,-3409.5479,633.4744,0,0,0);
	CreateObject(19129,804.0510,-3409.5479,633.4744,0,0,0);
	CreateObject(18655, 807.22858, -3380.00024, 636.47668,   0.00000, 0.00000, 40.39567);
	CreateObject(16101, 807.21863, -3380.00024, 626.26892,   0.00000, 0.00000, 359.18790);
	CreateObject(16101, 806.95441, -3416.60962, 626.26892,   0.00000, 0.00000, 359.18790);
	CreateObject(18653, 806.96411, -3416.60229, 636.47675,   0.00000, 0.00000, 310.58466);
	CreateObject(16101, 775.89722, -3416.52002, 626.26892,   0.00000, 0.00000, 359.18790);
	CreateObject(18655, 775.91718, -3416.51001, 636.47668,   0.00000, 0.00000, 226.19406);
	CreateObject(16101, 775.58160, -3380.05566, 626.26892,   0.00000, 0.00000, 359.18790);
	CreateObject(18653, 775.59662, -3380.05664, 636.47668,   0.00000, 0.00000, 135.46635);
	CreateObject(18102,780.7000100,-3400.5000000,632.7000100,160.0000000,0.0000000,270.0000000); //object(light_box1) (1)
	SetObjectMaterialText(BFboard, "Battlefield \n{7300B7}4{FFFFFF}\n Vengeance {BA9501} \nVIP Club!", 0, 90, "Dock 51", 25, 0, 0xFFFFFFFF, 0xFF000000, 1);
//-------------------------------End of VIP Club-------------------------------------------------------------------//
	AttachObjectToVehicle(USTBM1, USTB1, 3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(USTBM2, USTB1, -3.31,-0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(USTBM3, USTB2, 3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(USTBM4, USTB2, -3.31,-0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(USMSAMM, USMSAM, 0,-0.1,-0.7, 0,0, 270);
	AttachObjectToVehicle(USMRLH1, USMRL, 0, 0.1, -0.5, 0, 30, 90);
	AttachObjectToVehicle(USMRLH2, USMRL, 0, -2.1, -0.5, 0, 30, 90);
	AttachObjectToVehicle(USMRLM1, USMRL, -0.3, 1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(USMRLM2, USMRL, 0.3, 1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(USMRLM3, USMRL, -0.3, 1.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(USMRLM4, USMRL, 0.3, 1.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(USMRLM5, USMRL, -0.3, -0.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(USMRLM6, USMRL, 0.3, -0.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(USMRLM7, USMRL, -0.3, -1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(USMRLM8, USMRL, 0.3, -1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(EUTBM1, EUTB1, 3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(EUTBM2, EUTB1, -3.31,-0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(EUTBM3, EUTB2, 3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(EUTBM4, EUTB2, -3.31,-0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(EUMSAMM, EUMSAM, 0,-0.1,-0.7, 0,0, 270);
	AttachObjectToVehicle(EUMRLH1, EUMRL, 0, 0.1, -0.5, 0, 30, 90);
	AttachObjectToVehicle(EUMRLH2, EUMRL, 0, -2.1, -0.5, 0, 30, 90);
	AttachObjectToVehicle(EUMRLM1, EUMRL, -0.3, 1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(EUMRLM2, EUMRL, 0.3, 1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(EUMRLM3, EUMRL, -0.3, 1.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(EUMRLM4, EUMRL, 0.3, 1.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(EUMRLM5, EUMRL, -0.3, -0.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(EUMRLM6, EUMRL, 0.3, -0.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(EUMRLM7, EUMRL, -0.3, -1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(EUMRLM8, EUMRL, 0.3, -1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(INTBM1, INTB1, 3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(INTBM2, INTB1, -3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(INTBM3, INTB2, 3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(INTBM4, INTB2, -3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(INMSAMM, INMSAM, 0,-0.1,-0.7, 0,0, 270);
	AttachObjectToVehicle(INMRLH1, INMRL, 0, 0.1, -0.5, 0, 30, 90);
	AttachObjectToVehicle(INMRLH2, INMRL, 0, -2.1, -0.5, 0, 30, 90);
	AttachObjectToVehicle(INMRLM1, INMRL, -0.3, 1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(INMRLM2, INMRL, 0.3, 1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(INMRLM3, INMRL, -0.3, 1.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(INMRLM4, INMRL, 0.3, 1.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(INMRLM5, INMRL, -0.3, -0.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(INMRLM6, INMRL, 0.3, -0.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(INMRLM7, INMRL, -0.3, -1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(INMRLM8, INMRL, 0.3, -1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(RUTBM1, RUTB1, 3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(RUTBM2, RUTB1, -3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(RUTBM3, RUTB2, 3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(RUTBM4, RUTB2, -3.31, -0.1, -1.1, 0,0,270);
	AttachObjectToVehicle(RUMSAMM, RUMSAM, 0,-0.1,-0.7, 0,0, 270);
	AttachObjectToVehicle(RUMRLH1, RUMRL, 0, 0.1, -0.5, 0, 30, 90);
	AttachObjectToVehicle(RUMRLH2, RUMRL, 0, -2.1, -0.5, 0, 30, 90);
	AttachObjectToVehicle(RUMRLM1, RUMRL, -0.3, 1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(RUMRLM2, RUMRL, 0.3, 1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(RUMRLM3, RUMRL, -0.3, 1.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(RUMRLM4, RUMRL, 0.3, 1.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(RUMRLM5, RUMRL, -0.3, -0.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(RUMRLM6, RUMRL, 0.3, -0.6, 1.8, 0, 60, -90);
	AttachObjectToVehicle(RUMRLM7, RUMRL, -0.3, -1.1, 1.8, 0, 60, -90);
	AttachObjectToVehicle(RUMRLM8, RUMRL, 0.3, -1.1, 1.8, 0, 60, -90);
	//-----------------------------------------MRLHs Color Change----------------------------------------------------//
	SetObjectMaterial(USMRLH1, 0, -1, "none","none", 0xFF4B4B4B);
	SetObjectMaterial(USMRLH2, 0, -1, "none","none", 0xFF4B4B4B);
	SetObjectMaterial(EUMRLH1, 0, -1, "none","none", 0xFF4B4B4B);
	SetObjectMaterial(EUMRLH2, 0, -1, "none","none", 0xFF4B4B4B);
	SetObjectMaterial(INMRLH1, 0, -1, "none","none", 0xFF4B4B4B);
	SetObjectMaterial(INMRLH2, 0, -1, "none","none", 0xFF4B4B4B);
	SetObjectMaterial(RUMRLH1, 0, -1, "none","none", 0xFF4B4B4B);
	SetObjectMaterial(RUMRLH2, 0, -1, "none","none", 0xFF4B4B4B);
	//------------------------------------End of MRLHs Color Change------------------------------------------------------//
	//------------------------------Random Vehs------------------------------------//
	AddStaticVehicleEx(433,-43.1000000,2365.3999000,24.6000000,90.0000000,95,10,120); //Barracks
	AddStaticVehicleEx(468,-5.4000000,2349.7000000,23.9000000,0.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(470,-543.7999900,2616.8999000,53.6000000,220.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(468,-781.5000000,2748.0000000,45.4000000,90.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(470,-900.0000000,2708.3000000,42.5000000,140.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(433,-1311.6000000,2699.7000000,50.6000000,5.0000000,95,10,120); //Barracks
	AddStaticVehicleEx(433,-1291.5996000,2713.9004000,50.6000000,0.0000000,95,10,120); //Barracks
	AddStaticVehicleEx(468,-1431.2000000,2174.5000000,49.9000000,0.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(470,-1232.7000000,1831.7000000,41.7000000,50.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(470,-903.7000100,1983.4000000,61.0000000,315.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(468,-788.0000000,1610.2000000,26.9000000,0.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(468,-733.7000100,1439.3000000,16.6000000,0.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(468,-908.5999800,1507.4000000,25.7000000,90.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(470,-686.7000100,966.0999800,12.2000000,90.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(468,-254.8000000,991.5999800,20.0000000,0.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(468,-143.4003900,934.7002000,19.3000000,0.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(470,-361.7999900,1181.4000000,19.9000000,230.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(468,-25.4000000,1360.4000000,8.9000000,0.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(470,12.9000000,1180.0000000,19.6000000,90.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(433,550.5999800,1235.1000000,12.3000000,0.0000000,95,10,120); //Barracks
	AddStaticVehicleEx(433,191.2002000,1393.7998000,11.2000000,0.0000000,95,10,120); //Barracks
	AddStaticVehicleEx(470,1003.4000000,1075.0000000,10.9000000,0.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(470,1156.6000000,1530.5000000,5.9000000,0.0000000,95,10,120); //Patriot
	AddStaticVehicleEx(468,-337.7999900,1541.5000000,75.3000000,0.0000000,104,1,120); //Sanchez
	AddStaticVehicleEx(470,497.5000000,802.5000000,-21.8000000,200.0000000,95,10,120); //Patriot
	//-------------------End of Random Vehs---------------------------------------//
	return 1;
}

public OnGameModeExit()
{
	mysql_close(mysqldb);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(!Logged{playerid}) return 1;
	if(!DSP{playerid})
	{
		  //  TextDrawShowForPlayer(playerid, SAmap);
		  //  TextDrawShowForPlayer(playerid, SAmap1);
		  	TextDrawHideForPlayer(playerid, HUDbg);
			PlayerTextDrawHide(playerid, Magdraw[playerid]);
			PlayerTextDrawHide(playerid, Ammodraw[playerid]);
			PlayerTextDrawHide(playerid, Armrdraw[playerid]);
			PlayerTextDrawHide(playerid, Hdraw[playerid]);
			PlayerTextDrawHide(playerid, Wstate[playerid]);
			PlayerTextDrawHide(playerid, Rankdraw[playerid]);
			PlayerTextDrawHide(playerid, Scoredraw[playerid]);
			TextDrawHideForPlayer(playerid, Logodraw);
		  	TextDrawBoxColor(Teambutton[0], 0xFFFFFFBB);
			TextDrawColor(Teambutton[0], 0x000000FF);
			TextDrawSetOutline(Teambutton[0], 0);
			TextDrawBoxColor(Teambutton[1], 0x15151577);
			TextDrawColor(Teambutton[1], -1);
			TextDrawSetOutline(Teambutton[1], 1);
			TextDrawBoxColor(Teambutton[2], 0x15151577);
			TextDrawColor(Teambutton[2], -1);
			TextDrawSetOutline(Teambutton[2], 1);
			TextDrawBoxColor(Teambutton[3], 0x15151577);
			TextDrawColor(Teambutton[3], -1);
			TextDrawSetOutline(Teambutton[3], 1);
			TextDrawBoxColor(Classicon[0], 0xFFFFFFBB);
			TextDrawColor(Classicon[0], 0x000000FF);
			TextDrawSetOutline(Classicon[0], 0);
			TextDrawBoxColor(Classicon[1], 0x15151555);
			TextDrawColor(Classicon[1], 0xFFFFFFFF);
			TextDrawSetOutline(Classicon[1], 1);
			TextDrawBoxColor(Classicon[2], 0x15151555);
			TextDrawColor(Classicon[2], 0xFFFFFFFF);
			TextDrawSetOutline(Classicon[2], 1);
			TextDrawBoxColor(Classicon[3], 0x15151555);
			TextDrawColor(Classicon[3], 0xFFFFFFFF);
			TextDrawSetOutline(Classicon[3], 1);
			TextDrawBoxColor(Classicon[4], 0x15151555);
			TextDrawColor(Classicon[4], 0xFFFFFFFF);
			TextDrawSetOutline(Classicon[4], 1);
			TextDrawBoxColor(Classicon[5], 0x15151555);
			TextDrawColor(Classicon[5], 0xFFFFFFFF);
			TextDrawSetOutline(Classicon[5], 1);
			TextDrawBoxColor(Classicon[6], 0x15151555);
			TextDrawColor(Classicon[6], 0xFFFFFFFF);
			TextDrawSetOutline(Classicon[6], 1);
			TextDrawBoxColor(Classicon[7], 0x15151555);
			TextDrawColor(Classicon[7], 0xFFFFFFFF);
			TextDrawSetOutline(Classicon[7], 1);
			TextDrawColor(SnipeIcon, 0xFFFFFFFF);
			TextDrawSetOutline(SnipeIcon, 1);
			PlayerTextDrawSetString(playerid,Spawnclass[playerid], "ASSAULT");
			PlayerTextDrawSetString(playerid,ClassStats[playerid],"   M4A1      D-EAGLE      MP5      No Perk~n~ ~n~");
			PlayerTextDrawSetString(playerid, SpawnNotice[playerid],"~n~");
		    TextDrawShowForPlayer(playerid, Teamdraw);
		    TextDrawShowForPlayer(playerid, Teambutton[0]);
		    TextDrawShowForPlayer(playerid, Teambutton[1]);
		    TextDrawShowForPlayer(playerid, Teambutton[2]);
		    TextDrawShowForPlayer(playerid, Teambutton[3]);
		    TextDrawShowForPlayer(playerid, Deploydrawbg);
		    TextDrawShowForPlayer(playerid, Deploydraw);
		    TextDrawShowForPlayer(playerid, Basebox);
		    TextDrawShowForPlayer(playerid, BaseDepdrawbg);
		    TextDrawShowForPlayer(playerid, BaseDepdraw);
		    TextDrawShowForPlayer(playerid, DeployAsdraw);
		    TextDrawShowForPlayer(playerid, Classicon[0]);
		    TextDrawShowForPlayer(playerid, Classicon[1]);
		    TextDrawShowForPlayer(playerid, Classicon[4]);
		    TextDrawShowForPlayer(playerid, SnipeIcon);
		    TextDrawShowForPlayer(playerid, Classicon[2]);
		    TextDrawShowForPlayer(playerid, Classicon[6]);
		    TextDrawShowForPlayer(playerid, Classicon[3]);
		    TextDrawShowForPlayer(playerid, Classicon[5]);
		    if(GetPVarInt(playerid,"Viplevel") > 1)TextDrawShowForPlayer(playerid, Classicon[7]);
		    TextDrawShowForPlayer(playerid, DeployButton);
		    PlayerTextDrawShow(playerid, Spawnclass[playerid]);
		    PlayerTextDrawShow(playerid, SpawnNotice[playerid]);
			TextDrawShowForPlayer(playerid, Spawnbg);
			TextDrawShowForPlayer(playerid, ClassStatsbg);
			PlayerTextDrawShow(playerid, ClassStats[playerid]);
			SelectTextDraw(playerid, 0xFFFFFF55);
			TogglePlayerSpectating(playerid, 1);
			SetTimerEx("SpectateDebug", 100, 0, "i", playerid);
			PlayAudioStreamForPlayer(playerid,"http://k007.kiwi6.com/hotlink/0i3ec1jcvb/Switch-SFX.mp3",0,0,0,0,0);
			for(new i = 0; i < 10; i++)
			{
			    SendClientMessage(playerid, -1, " ");
			}
			for(new i =0; i < MAX_TEAM_PLAYERS; i++)
			{
			    if(Tplayers[gTeam[playerid]][i] == playerid)
				{
				 	Tplayers[gTeam[playerid]][i] = INVALID_PLAYER_ID;
			    	break;
				}
			}
			TeamTime[playerid] = gettime() - TeamTime[playerid];
			ClassTime[playerid] = gettime() - ClassTime[playerid];
			new query[120];
			mysql_format(mysqldb, query, sizeof(query),"UPDATE SRVRPlayers SET T%dTime = T%dTime + %d, C%dTime = C%dTime + %d WHERE ID = %d", gTeam[playerid], gTeam[playerid], TeamTime[playerid], Pclass[playerid], Pclass[playerid], ClassTime[playerid], Playerinfo[playerid][dbID]);
			mysql_tquery(mysqldb, query);
		 	gTeam[playerid] = TEAM_US;
		    Pclass[playerid] = ASSAULT_CLASS;
	}
	else if(DSP{playerid} == 1)
	{
			for(new i =0; i < MAX_TEAM_PLAYERS; i++)
			{
			    if(Tplayers[gTeam[playerid]][i] == playerid)
				{
				 	Tplayers[gTeam[playerid]][i] = INVALID_PLAYER_ID;
			    	break;
				}
			}
			gTeam[playerid] = TEAM_NULL;
			Pclass[playerid] = ASSAULT_CLASS;
        	SetSpawnInfo(playerid, 4, Teaminfo[4][Skin],Teaminfo[4][TX],Teaminfo[4][TY],Teaminfo[4][TZ],Teaminfo[4][TAngle],0,0,0,0,0,0);
        	SetPlayerSkin(playerid, GetPVarInt(playerid, "VIPskin"));
        	SpawnPlayer(playerid);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    new pname[MAX_PLAYER_NAME], string[22 + MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof(pname));
	format (string, sizeof(string), "%s has joined the server", pname);
	SendClientMessageToAll(0xACACACFF, string);
	SetPlayerMapIcon(playerid, 0, 208.0087,1940.9708,17.6406, 19, 0, MAPICON_LOCAL); //US
	SetPlayerMapIcon(playerid, 1, -242.3999,2690.9917,62.6875, 19, 0, MAPICON_LOCAL); //IN
	SetPlayerMapIcon(playerid, 2, 845.3034,2184.4465,10.8203, 19, 0, MAPICON_LOCAL); //RU
	SetPlayerMapIcon(playerid, 3, -1476.5688,1624.2649,-0.0008, 19, 0, MAPICON_LOCAL); // EU
	TogglePlayerSpectating(playerid, 1);
	SetTimerEx("CameraSceneForPlayer", 100, 0,"i", playerid);
	Cdraw[playerid] = CreatePlayerTextDraw(playerid, 320, 320, " ");
	PlayerTextDrawUseBox(playerid, Cdraw[playerid], 1);
	PlayerTextDrawSetShadow(playerid, Cdraw[playerid], 0);
	PlayerTextDrawAlignment(playerid, Cdraw[playerid], 2);
	PlayerTextDrawTextSize(playerid, Cdraw[playerid], 20, 120);
	PlayerTextDrawBoxColor(playerid, Cdraw[playerid], 0x000000AA);
	PlayerTextDrawFont(playerid, Cdraw[playerid], 3);
	Magdraw[playerid] = CreatePlayerTextDraw(playerid, 554, 339, " ");
	PlayerTextDrawSetShadow(playerid, Magdraw[playerid], 0);
	PlayerTextDrawFont(playerid, Magdraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, Magdraw[playerid], 0.6, 4.5);
	PlayerTextDrawColor(playerid, Magdraw[playerid], 0x747474CC);
	Ammodraw[playerid] = CreatePlayerTextDraw(playerid, 592, 345, " ");
	PlayerTextDrawSetShadow(playerid, Ammodraw[playerid], 0);
	PlayerTextDrawFont(playerid, Ammodraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, Ammodraw[playerid], 0.4, 1.7);
	PlayerTextDrawColor(playerid, Ammodraw[playerid], 0x747474CC);
	Hdraw[playerid] = CreatePlayerTextDraw(playerid, 592, 375, "----------~n~+ 100~n~----------");
	PlayerTextDrawSetShadow(playerid, Hdraw[playerid], 0);
	PlayerTextDrawFont(playerid, Hdraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, Hdraw[playerid], 0.4, 0.8);
	PlayerTextDrawColor(playerid, Hdraw[playerid], 0x747474CC);
	Armrdraw[playerid] = CreatePlayerTextDraw(playerid, 532, 375, "-----------------~n~Armr. 000~n~-----------------");
	PlayerTextDrawSetShadow(playerid, Armrdraw[playerid], 0);
	PlayerTextDrawFont(playerid, Armrdraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, Armrdraw[playerid], 0.25, 0.8);
	PlayerTextDrawColor(playerid, Armrdraw[playerid], 0x747474CC);
	Wstate[playerid] = CreatePlayerTextDraw(playerid, 616, 366," ");
	PlayerTextDrawSetShadow(playerid, Wstate[playerid], 0);
	PlayerTextDrawAlignment(playerid, Wstate[playerid], 2);
	PlayerTextDrawFont(playerid, Wstate[playerid], 2);
	PlayerTextDrawLetterSize(playerid, Wstate[playerid], 0.25, 1.0);
	PlayerTextDrawColor(playerid, Wstate[playerid], 0x747474CC);
	Rankdraw[playerid] = CreatePlayerTextDraw(playerid, 550, 80," ");
	PlayerTextDrawSetShadow(playerid, Rankdraw[playerid], 0);
	PlayerTextDrawAlignment(playerid, Rankdraw[playerid], 2);
	PlayerTextDrawUseBox(playerid, Rankdraw[playerid], 1);
	PlayerTextDrawBoxColor(playerid, Rankdraw[playerid], 0x000000FF);
	PlayerTextDrawFont(playerid, Rankdraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, Rankdraw[playerid], 0.16, 1.8);
	PlayerTextDrawTextSize(playerid, Rankdraw[playerid], 4.25, 110);
	Scoredraw[playerid] = CreatePlayerTextDraw(playerid, 548, 46, " ");
	PlayerTextDrawSetShadow(playerid, Scoredraw[playerid], 0);
	PlayerTextDrawUseBox(playerid, Scoredraw[playerid], 1);
	PlayerTextDrawBoxColor(playerid, Scoredraw[playerid], 0x000000FF);
	PlayerTextDrawFont(playerid, Scoredraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, Scoredraw[playerid], 0.15, 1.4);
	PlayerTextDrawTextSize(playerid, Scoredraw[playerid], 613, 10);
	Mainreward[playerid] = CreatePlayerTextDraw(playerid, 320, 350, " ");
	PlayerTextDrawFont(playerid, Mainreward[playerid], 2);
	PlayerTextDrawAlignment(playerid, Mainreward[playerid], 2);
	PlayerTextDrawLetterSize(playerid, Mainreward[playerid], 0.18, 2.3);
	PlayerTextDrawSetShadow(playerid, Mainreward[playerid], 0);
	Secondaryreward[playerid] = CreatePlayerTextDraw(playerid, 320, 365, " ");
	PlayerTextDrawFont(playerid, Secondaryreward[playerid], 2);
	PlayerTextDrawAlignment(playerid, Secondaryreward[playerid], 2);
	PlayerTextDrawSetShadow(playerid, Secondaryreward[playerid], 0);
	PlayerTextDrawLetterSize(playerid, Secondaryreward[playerid], 0.135, 1.7);
	ClassStats[playerid] = CreatePlayerTextDraw(playerid,328, 317,"~n~ ~n~");
	PlayerTextDrawSetShadow(playerid,ClassStats[playerid], 0);
	PlayerTextDrawFont(playerid,ClassStats[playerid], 2);
	PlayerTextDrawTextSize(playerid,ClassStats[playerid], 590, 5);
	PlayerTextDrawLetterSize(playerid,ClassStats[playerid], 0.25, 1.75);
	PlayerTextDrawBackgroundColor(playerid,ClassStats[playerid], 0x3D87DA33);
	PlayerTextDrawSetOutline(playerid,ClassStats[playerid], 1);
	PlayerTextDrawUseBox(playerid,ClassStats[playerid], 1);
	PlayerTextDrawBoxColor(playerid,ClassStats[playerid], 0xFFFFFF22);
	SpawnNotice[playerid] = CreatePlayerTextDraw(playerid,459, 300, "~n~");
	PlayerTextDrawSetShadow(playerid,SpawnNotice[playerid], 0);
	PlayerTextDrawFont(playerid,SpawnNotice[playerid], 2);
	PlayerTextDrawUseBox(playerid,SpawnNotice[playerid], 1);
	PlayerTextDrawBoxColor(playerid,SpawnNotice[playerid], 0x000000AA);
	PlayerTextDrawAlignment(playerid,SpawnNotice[playerid], 2);
	PlayerTextDrawTextSize(playerid,SpawnNotice[playerid], 2,262);
	PlayerTextDrawLetterSize(playerid,SpawnNotice[playerid], 0.25, 1.4);
	PlayerTextDrawColor(playerid,SpawnNotice[playerid], -1);
	Spawnclass[playerid] = CreatePlayerTextDraw(playerid,115, 300," ");
	PlayerTextDrawSetShadow(playerid,Spawnclass[playerid], 0);
	PlayerTextDrawFont(playerid,Spawnclass[playerid], 2);
	PlayerTextDrawLetterSize(playerid,Spawnclass[playerid], 0.25, 1.4);
//-------------------------------------------Paysadas Removed Buildings-------------------------------------//
	RemoveBuildingForPlayer(playerid, 16776, -237.1, 2662.8, 62.9, 3);
	RemoveBuildingForPlayer(playerid, 669, -207,2729.1,62.3, 170);
	RemoveBuildingForPlayer(playerid, 672, -207,2729.1,62.3, 100);
	RemoveBuildingForPlayer(playerid, 1223, -239.8, 2700.4, 61.5, 100);
	RemoveBuildingForPlayer(playerid, 1340, -197.4, 2659.4, 63.2, 3);
	RemoveBuildingForPlayer(playerid, 16062, -222.7, 2663.3, 66.4, 3);
	RemoveBuildingForPlayer(playerid, 16401, -272.2, 2662.6, 60.8, 3);
	RemoveBuildingForPlayer(playerid, 3242, -147.5, 2686.1, 63.7, 230);
	RemoveBuildingForPlayer(playerid, 3297, -147.5, 2686.1, 63.7, 230);// 3242 LOD
	RemoveBuildingForPlayer(playerid, 3241, -165.3, 2707.8, 62.4, 230);
	RemoveBuildingForPlayer(playerid, 3298, -165.3, 2707.8, 62.4, 230);//3241 LOD
	RemoveBuildingForPlayer(playerid, 3285, -165.9, 2731.5, 63.1, 230);
	RemoveBuildingForPlayer(playerid, 3300, -165.9, 2731.5, 63.1, 230);//3285 LOD
	RemoveBuildingForPlayer(playerid, 3172, -167.3, 2767.4, 61.9, 3);
	RemoveBuildingForPlayer(playerid, 3345, -167.3, 2767.4, 61.9, 3);//3172 LOD
	RemoveBuildingForPlayer(playerid, 3168, -154.6, 2761.4, 61.7, 3);
	RemoveBuildingForPlayer(playerid, 3343, -154.6, 2761.4, 61.7, 3);//3168 LOD
	RemoveBuildingForPlayer(playerid, 3283, -195.7, 2768.5, 61.5, 300);
	RemoveBuildingForPlayer(playerid, 3299, -195.7, 2768.5, 61.5, 300);//3283 LOD
	RemoveBuildingForPlayer(playerid, 3284, -216.9, 2769.7, 63.7, 170);
	RemoveBuildingForPlayer(playerid, 3301, -216.9, 2769.7, 63.7, 170);//3284 LOD
	RemoveBuildingForPlayer(playerid, 3170,-289.8, 2758.3, 61.1, 3);
	RemoveBuildingForPlayer(playerid, 3341,-289.8, 2758.3, 61.1, 3);//3170 LOD
	RemoveBuildingForPlayer(playerid, 3173, -275.2, 2738.5, 61.3, 3);
	RemoveBuildingForPlayer(playerid, 3342, -275.2, 2738.5, 61.3, 3);//3173 LOD
	RemoveBuildingForPlayer(playerid, 16011, -227.1, 2716.1, 62.9, 3);
	RemoveBuildingForPlayer(playerid, 16765, -227.1, 2716.1, 62.9, 3);//16011 LOD
//---------------------------------End of Removed Paysadas Buildings----------------------------------------//
	Playerinfo[playerid][lastpm] = INVALID_PLAYER_ID;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    new pname [MAX_PLAYER_NAME], msg[32 + MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof(pname));
	switch(reason)
	{
	    case 0: format(msg, sizeof(msg), "%s has left the server. (Timeout)", pname);
	    case 1: format(msg, sizeof(msg), "%s has left the server.(Left)", pname);
	    case 2: format(msg, sizeof(msg), "%s has left the server. (Kicked)", pname);
	}
	SendClientMessageToAll(0xACACACFF, msg);
	if(Playerinfo[playerid][Capzone] != 0 ) CapturingPlayers[Playerinfo[playerid][Capzone]] -= 1;
	Playerinfo[playerid][Capzone] = 0;
	if(gTeam[playerid] < 4)
	{
		for(new i = 0; i < MAX_TEAM_PLAYERS; i++)
		{
		    if(Tplayers[gTeam[playerid]][i] == playerid) Tplayers[gTeam[playerid]][i] = INVALID_PLAYER_ID;
		}
	}
	if(Logged{playerid} == 1)
	{
	    TeamTime[playerid] = gettime() - TeamTime[playerid];
	    ClassTime[playerid] = gettime() - ClassTime[playerid];
		new query[285], viplevel = GetPVarInt(playerid, "Viplevel");
		format(query, sizeof(query), "UPDATE SRVRPlayers SET Kills = %d, Deaths = %d, Captures = %d, Score = %d", Playerinfo[playerid][Kills], Playerinfo[playerid][Deaths], Playerinfo[playerid][Captures], Playerinfo[playerid][Score]);
		mysql_format(mysqldb, query, sizeof(query),"%s, Adlevel = %d, Tokens = %d, DSP = %d, T%dTime = T%dTime + %d, C%dTime = C%dTime + %d WHERE `ID` = %d",query, Playerinfo[playerid][Adminlevel], Playerinfo[playerid][Tokens], DSP{playerid}, gTeam[playerid], gTeam[playerid], TeamTime[playerid], Pclass[playerid], Pclass[playerid], ClassTime[playerid], Playerinfo[playerid][dbID]);
		mysql_tquery(mysqldb, query, "OnAccountSaveStats", "ii", playerid, viplevel);
		if(viplevel > 0)
		{
		    mysql_format(mysqldb, query, sizeof(query), "UPDATE VIPs SET Viplevel = %d, Vipskin = %d WHERE ID = %d", GetPVarInt(playerid, "Viplevel"), GetPVarInt(playerid, "VIPskin"), Playerinfo[playerid][dbID]);
		    mysql_tquery(mysqldb, query);
			for(new i = 3; i < 10; i++)
			{
			    new string[15];
			    format(string ,sizeof(string), "AttachObj%d", i);
			    if(GetPVarInt(playerid, string) > 0)
			    {
       				new model, bone, Float:RotX, Float:RotY, Float:RotZ, Float:OffX, Float:OffY, Float:OffZ;
					model = GetPVarInt(playerid, string);
					format(string, sizeof(string),"ObjBone%d", i);
				 	bone = GetPVarInt(playerid, string);
					format(string, sizeof(string),"ObjRotX%d", i);
					RotX = GetPVarFloat(playerid, string);
					format(string, sizeof(string),"ObjRotY%d", i);
					RotY = GetPVarFloat(playerid, string);
					format(string, sizeof(string),"ObjRotZ%d", i);
					RotZ = GetPVarFloat(playerid, string);
					format(string, sizeof(string),"ObjOffX%d", i);
					OffX = GetPVarFloat(playerid, string);
					format(string, sizeof(string),"ObjOffY%d", i);
					OffY = GetPVarFloat(playerid, string);
					format(string, sizeof(string),"ObjOffZ%d", i);
					OffX = GetPVarFloat(playerid, string);
			        mysql_format(mysqldb, query, sizeof(query), "INSERT INTO AttachObjs (ID, ObjIndex, Bone, RotX, RotY, RotZ, OffX, OffY, OffZ, ObjID) Values(%d, %d, %d, %f, %f, %f, %f, %f, %f, %d)", Playerinfo[playerid][dbID], i, bone, RotX, RotY, RotZ, OffZ, OffY, OffX, model);
			        mysql_tquery(mysqldb, query);
			    }
			}
			Playerinfo[playerid][dbID] = 0;
		}
	}
	else
	{
		Playerinfo[playerid][Adminlevel] = 0;
		Playerinfo[playerid][Capzone] = 0;
		Czone[playerid] = 0;
		Playerinfo[playerid][pmreject] = false;
		Playerinfo[playerid][pjammed] = false;
		Playerinfo[playerid][Tokens] = 0;
		Playerinfo[playerid][Kills] = 0;
	 	Playerinfo[playerid][Deaths] = 0;
	 	Playerinfo[playerid][Score] = 0;
	 	Playerinfo[playerid][Captures] = 0;
	 	Playerinfo[playerid][jammed] = false;
	 	Playerinfo[playerid][muted] = false;
	 	Playerinfo[playerid][dbID] = 0;
	 	LoginAttempts{playerid} = 0;
	 	DSP{playerid} = 0;
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	//Spawned[playerid] = gettime()+3;
	SetPlayerHealth(playerid, 99.0);
	TextDrawShowForPlayer(playerid, HUDbg);
	PlayerTextDrawShow(playerid, Magdraw[playerid]);
	PlayerTextDrawShow(playerid, Ammodraw[playerid]);
	PlayerTextDrawShow(playerid, Armrdraw[playerid]);
	PlayerTextDrawShow(playerid, Hdraw[playerid]);
	PlayerTextDrawShow(playerid, Wstate[playerid]);
	PlayerTextDrawShow(playerid, Rankdraw[playerid]);
	PlayerTextDrawShow(playerid, Scoredraw[playerid]);
	TextDrawShowForPlayer(playerid, Logodraw);
	for(new i=0; i < sizeof(ZoneInfo); i++)
	{
    	GangZoneShowForPlayer(playerid, ZoneID[i], GetTeamZoneColor(ZoneInfo[i][zTeam]));
	}
	if(!Playerinfo[playerid][jammed])
	{
		switch(gTeam[playerid])
		{
	    	case 0:	SetPlayerColor(playerid, 0x0000E1FF), SetPlayerTeam(playerid, 0);
	    	case 1:	SetPlayerColor(playerid, 0x00E100FF), SetPlayerTeam(playerid, 1);
	    	case 2:
			{
				SetPlayerColor(playerid, 0xEC8D00FF);
				SetPlayerAttachedObject(playerid, 0, 19108, 2, 0.15,0.01,0,0,0,0,1.1,1.1,1.3);
				SetPlayerAttachedObject(playerid, 1, 19142, 1, 0.04,0.044,0,0,0,0,1.1,1.31,1.13);
				SetPlayerTeam(playerid, 2);
			}
	    	case 3:	SetPlayerColor(playerid, 0xF00006FF), SetPlayerTeam(playerid, 3);
		}
	}
	if(!DSP{playerid}) GivePlayerPack(playerid, Pclass);
	else StopAudioStreamForPlayer(playerid), PlayAudioStreamForPlayer(playerid, "http://icy3.abacast.com/pulse87-pulse87mp3-64",0,0,0,0,0), SetPlayerColor(playerid, 0x414141FF), SetPlayerCheckpoint(playerid, 799.4636,-3364.6323,635.7541, 3), SetPlayerSkin(playerid, GetPVarInt(playerid, "VIPskin"));
	PlayerTextDrawSetString(playerid, Hdraw[playerid], "----------~n~+ 100~n~----------");
	PlayerTextDrawSetString(playerid, Armrdraw[playerid], "-----------------~n~Armr. 000~n~-----------------");
 	if(GetPVarInt(playerid, "Viplevel") > 0)
 	{
		    for(new i = 3; i < 10; i++)
		    {
		        new string[15];
		        format(string, sizeof(string),"AttachObj%d", i);
		        if(GetPVarInt(playerid, string) != 0)
		        {
		            new model, bone, Float:RotX, Float:RotY, Float:RotZ, Float:OffX, Float:OffY, Float:OffZ;
					model = GetPVarInt(playerid, string);
					format(string, sizeof(string),"ObjBone%d", i);
				 	bone = GetPVarInt(playerid, string);
					format(string, sizeof(string),"ObjRotX%d", i);
					RotX = GetPVarFloat(playerid, string);
					format(string, sizeof(string),"ObjRotY%d", i);
					RotY = GetPVarFloat(playerid, string);
					format(string, sizeof(string),"ObjRotZ%d", i);
					RotZ = GetPVarFloat(playerid, string);
					format(string, sizeof(string),"ObjOffX%d", i);
					OffX = GetPVarFloat(playerid, string);
					format(string, sizeof(string),"ObjOffY%d", i);
					OffY = GetPVarFloat(playerid, string);
					format(string, sizeof(string),"ObjOffZ%d", i);
					OffX = GetPVarFloat(playerid, string);
					SetPlayerAttachedObject(playerid, i, model, bone, OffX, OffY , OffZ, RotX, RotY, RotZ,1,1,1,0);
		        }
		    }
 	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SendDeathMessage(killerid, playerid, reason);
	if(killerid != INVALID_PLAYER_ID)
	{
	    new string[50];
		Playerinfo[killerid][Kills] += 1;
		Playerinfo[killerid][Score] += 5;
		Playerinfo[killerid][Tokens] += 1;
		SetPlayerScore(killerid, Playerinfo[killerid][Score]);
		SetPlayerRankFromScore(killerid, Playerinfo[killerid][Score]);
		Update3DTextLabelText(Labels[killerid], 0xD7D7D7FF, GetRankNameFromID(Playerinfo[killerid][RankID]));
		PlayerTextDrawSetString(killerid, Rankdraw[killerid], GetRankNameFromID(Playerinfo[killerid][RankID]));
		format(string, sizeof(string),"Score: %d~n~BattlePoints: %d", Playerinfo[killerid][Score], Playerinfo[killerid][Tokens]);
		PlayerTextDrawSetString(killerid, Scoredraw[killerid], string);
		PlayerTextDrawSetString(killerid, Mainreward[killerid], "ENEMY  KILLED    5XP  1BP");
		PlayerTextDrawShow(killerid, Mainreward[killerid]);
		Rewardtime[killerid] = SetTimerEx("Rewardhide", 2000, 0, "i", killerid);
		
	}
	if(!DSP{playerid}) Playerinfo[playerid][Deaths] += 1;
 	if(Playerinfo[playerid][Capzone] != 0)
  	{
	        CapturingPlayers[Playerinfo[playerid][Capzone]] -= 1;
	        SetPlayerWorldBounds(playerid, 20000, -20000, 20000, -20000);
	        PlayerTextDrawHide(playerid, Cdraw[playerid]);
	}
	Playerinfo[playerid][Capzone] = 0;
	if(Playerinfo[playerid][pjammed])
	{
	    Playerinfo[playerid][pjammed] = false;
	    SetPlayerColor(playerid, Tcolor[gTeam[playerid]]);
	}
	for(new w = 0; w < 4; w++)
	{
		magdifference[playerid][w] = 0;
	}
	DisablePlayerCheckpoint(playerid);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	switch(vehicleid)
	{
	    case 14:
	    {
	        AttachObjectToVehicle(USMRLH1, USMRL, 0, 0.1, -0.5, 0, 30, 90);
			AttachObjectToVehicle(USMRLH2, USMRL, 0, -2.1, -0.5, 0, 30, 90);
			AttachObjectToVehicle(USMRLM1, USMRL, -0.3, 1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(USMRLM2, USMRL, 0.3, 1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(USMRLM3, USMRL, -0.3, 1.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(USMRLM4, USMRL, 0.3, 1.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(USMRLM5, USMRL, -0.3, -0.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(USMRLM6, USMRL, 0.3, -0.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(USMRLM7, USMRL, -0.3, -1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(USMRLM8, USMRL, 0.3, -1.1, 1.8, 0, 60, -90);
		}
		case 15:
		{
		    AttachObjectToVehicle(EUMRLH1, EUMRL, 0, 0.1, -0.5, 0, 30, 90);
			AttachObjectToVehicle(EUMRLH2, EUMRL, 0, -2.1, -0.5, 0, 30, 90);
			AttachObjectToVehicle(EUMRLM1, EUMRL, -0.3, 1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(EUMRLM2, EUMRL, 0.3, 1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(EUMRLM3, EUMRL, -0.3, 1.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(EUMRLM4, EUMRL, 0.3, 1.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(EUMRLM5, EUMRL, -0.3, -0.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(EUMRLM6, EUMRL, 0.3, -0.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(EUMRLM7, EUMRL, -0.3, -1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(EUMRLM8, EUMRL, 0.3, -1.1, 1.8, 0, 60, -90);
		}
		case 17:
		{
		    AttachObjectToVehicle(RUMRLH1, RUMRL, 0, 0.1, -0.5, 0, 30, 90);
			AttachObjectToVehicle(RUMRLH2, RUMRL, 0, -2.1, -0.5, 0, 30, 90);
			AttachObjectToVehicle(RUMRLM1, RUMRL, -0.3, 1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(RUMRLM2, RUMRL, 0.3, 1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(RUMRLM3, RUMRL, -0.3, 1.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(RUMRLM4, RUMRL, 0.3, 1.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(RUMRLM5, RUMRL, -0.3, -0.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(RUMRLM6, RUMRL, 0.3, -0.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(RUMRLM7, RUMRL, -0.3, -1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(RUMRLM8, RUMRL, 0.3, -1.1, 1.8, 0, 60, -90);
		}
		case 16:
		{
		    AttachObjectToVehicle(INMRLH1, INMRL, 0, 0.1, -0.5, 0, 30, 90);
			AttachObjectToVehicle(INMRLH2, INMRL, 0, -2.1, -0.5, 0, 30, 90);
			AttachObjectToVehicle(INMRLM1, INMRL, -0.3, 1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(INMRLM2, INMRL, 0.3, 1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(INMRLM3, INMRL, -0.3, 1.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(INMRLM4, INMRL, 0.3, 1.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(INMRLM5, INMRL, -0.3, -0.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(INMRLM6, INMRL, 0.3, -0.6, 1.8, 0, 60, -90);
			AttachObjectToVehicle(INMRLM7, INMRL, -0.3, -1.1, 1.8, 0, 60, -90);
			AttachObjectToVehicle(INMRLM8, INMRL, 0.3, -1.1, 1.8, 0, 60, -90);
		}
	    case 9: AttachObjectToVehicle(USMSAMM, USMSAM, 0,-0.1,-0.7, 0,0, 270);
	    case 10: AttachObjectToVehicle(EUMSAMM, EUMSAM, 0,-0.1,-0.7, 0,0, 270);
	    case 12: AttachObjectToVehicle(RUMSAMM, RUMSAM, 0,-0.1,-0.7, 0,0, 270);
	    case 11: AttachObjectToVehicle(INMSAMM, INMSAM, 0,-0.1,-0.7, 0,0, 270);
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(Playerinfo[playerid][muted])
	{
		 SendClientMessage(playerid, COLOUR_RED, "You are still muted, you cannot use the chat!");
		 return 0;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

CMD:dbmove(playerid, params[])
{
	new name[30], pname[30], query[600], password[140], kills, captures, tokens, deaths, score, adlevel, path[50], pwlength;
	for(new i = 0; i < 330; i++)
	{
	    new str[4];
		valstr(str, i, false);
     	strmid(name, dini_Get("names.ini", str), 0, strlen(dini_Get("names.ini", str)), sizeof(name));
     	strmid(pname, dini_Get("names.ini", str), 0, strlen(dini_Get("names.ini", str))-4, sizeof(name));
	    format(path, sizeof(path), "/PlayersDBv2/%s", name);
	    kills = dini_Int(path, "kills");
	    captures = dini_Int(path, "captures");
	    deaths = dini_Int(path, "deaths");
	    score = dini_Int(path, "score");
	    adlevel = dini_Int(path, "adlevel");
	   	strmid(password, dini_Get(path, "password"), 0, strlen(dini_Get(path, "password")), sizeof(password));
	    tokens = dini_Int(path, "tokens");
	    pwlength = strlen(password);
     	for(new j = 0; j < pwlength; j++)
		{
	 		password[j] = password[j] + 10;
		}
		WP_Hash(password, 140, password);
		new ran[4];
		for(new j = 0; j < 3; j++)
		{
					   ran[j] = random(25) +65;
		}
		strins(password, ran, 0, 3);
		for(new j = 0;j < 3; j++)
		{
					    ran[j] = random(25) +65;
		}
		strins(password, ran, 34, 3);
  		mysql_format(mysqldb, query, sizeof(query), "INSERT INTO SRVRPlayers (Username,Password, Kills, Captures, Deaths, Score, Adlevel, Tokens) Values('%e','%e', %d, %d, %d, %d, %d, %d)", pname, password, kills, captures, deaths, score, adlevel, tokens);
  		mysql_query(mysqldb, query, false);
		printf("Query Completed: Itteration %d", i);
	}
	return 1;
}

CMD:check(playerid, params[])
{
	new fd, sd, string[15];
	if(sscanf(params,"ii",fd, sd)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /check [fd] [sd]");
	format(string, sizeof(string),"TID: %d", Tplayers[fd][sd]);
	SendClientMessage(playerid, COLOUR_GREEN, string);
	return 1;
}

CMD:refer(playerid, params[])
{
	new path[95];
	if(isnull(params))
	{
	 	format(path, sizeof(path),"Usage: /refer [referrer-username]");
	 	return SendClientMessage(playerid, COLOUR_GREY, path);
	}
	if(Playerinfo[playerid][RankID] < 2)
	{
         format(path, sizeof(path),"You need to reach 'Corporal' rank so that you can get referred!");
		 return SendClientMessage(playerid, COLOUR_RED,path);
	}
	GetPlayerName(playerid, path, sizeof(path));
	if(!strcmp(path, params, 0))
	{
	    format(path, sizeof(path),"You can not be referred by yourself!");
	    return SendClientMessage(playerid, COLOUR_RED, path);
	}
	mysql_format(mysqldb, path, sizeof(path), "SELECT ID,Referred,Refers FROM SRVRPlayers WHERE ID = %d OR Username = '%e' LIMIT 2", Playerinfo[playerid][dbID], params);
	mysql_tquery(mysqldb, path, "OnReferredCheck", "iss", playerid, path, params);
	return 1;
}

CMD:tele(playerid, params[])
{
	SetPlayerPos(playerid, 1487.9202000,-3596.5996000,60);
	SetPlayerSkin(playerid, 98);
	return 1;
}

CMD:tele2(playerid, params[])
{
	SetPlayerPos(playerid, 769.8000500,-3344.1001000,637.0999800);
	SetPlayerSkin(playerid, 98);
	StopAudioStreamForPlayer(playerid);
	PlayAudioStreamForPlayer(playerid, "http://icy3.abacast.com/pulse87-pulse87mp3-64",0,0,0,0,0);
	return 1;
}

/*CMD:prodfile(playerid, params[])
{
	if(!dini_Exists("passwords.txt")) dini_Create("passwords.txt");
	new File:passwords = fopen("passwords.txt", io_append);
	new string[20] = "aaaaaaaaaaaaaaaa\r\n";
	new op;
	for(new i = 0; i < 10000; i++)
	{
	    for(new j = 0; j < 16; j++)
	    {
	        op = random(2);
	        if(!op) string[j] = random(26)+65;
			else string[j] = random(26)+97;
	    }
	    fwrite(passwords, string);
	}
	fclose(passwords);
	return 1;
}*/

CMD:about(playerid, params[])
{
	ShowPlayerDialog(playerid, 15, DIALOG_STYLE_MSGBOX,"About","Battlefield 4 Vengeance is currently running on V1.2\nOwned By: Preet\nScripted and Co-owned by: [NbZ]BlackM\nBeta testers: Yousef_Mohamed, Maverick and Charlie\nSpecial Thanks to:\nMVagueOfficial, for the intro song.\nIncognito, for the IRC plugin\nMauzen, for the MapAndreas plugin","Exit","");
	return 1;
}

CMD:changeusername(playerid, params[])
{
	new inputpassword[31], nname[25], query[100];
	if(!Logged{playerid}) return SendClientMessage(playerid, COLOUR_RED,"You are not logged in");
	if(sscanf(params, "s[31]s[25]",inputpassword, nname)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /changeusername [password] [new name]");
	if(!(4 < strlen(nname) < 20)) return SendClientMessage(playerid, COLOUR_RED, "New username is too short or too long!");
	SetPVarString(playerid, "NewUsername", nname);
	mysql_format(mysqldb, query, sizeof(query), "SELECT Password FROM SRVRPlayers WHERE ID = %d OR Username = '%e' LIMIT 2", Playerinfo[playerid][dbID], nname);
	mysql_tquery(mysqldb, query, "OnPlayerRequestNewUsername", "is", playerid, inputpassword);
	return 1;
}

CMD:changepassword(playerid, params[])
{
	if(!Logged{playerid}) return SendClientMessage(playerid, COLOUR_RED, "Your are not logged in!");
	new oldpassword[31], newpassword[31], query[56];
	if(sscanf(params,"s[31]s[31]", oldpassword, newpassword)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /changepassword [oldpass] [newpass]");
	if(!(4 <strlen(newpassword) < 39)) return SendClientMessage(playerid, COLOUR_GREY,"Your new password is either too short or too long!");
	SetPVarString(playerid, "OldPass", oldpassword);
	mysql_format(mysqldb,query, sizeof(query),"SELECT Password FROM SRVRPlayers WHERE ID = %d LIMIT 1", Playerinfo[playerid][dbID]);
	mysql_tquery(mysqldb, query, "OnPlayerRequestNewPass", "is", playerid, newpassword);
	return 1;
}

CMD:help(playerid, params[])
{
	ShowPlayerDialog(playerid, 5, DIALOG_STYLE_LIST, "Choose a Topic", "Ranks \n Special Vehicles \n Capturable Zones \n Special Zones \n Unlockables \n Capturing System \n Commands", "Select", "Cancel"); // Help Dialog
 	return 1;
}

CMD:nuke(playerid, params[])
{
 	new zone;
 	if(sscanf(params,"d", zone)) return SendClientMessage(playerid, 0x606060FF, "Usage: /nuke [Zone ID] . List of zone IDs can be found in /help > Capturable Zones");
 	if(gTeam[playerid] != ZoneInfo[15][zTeam]) return SendClientMessage(playerid,0x910000FF, "Your team does not own the Nuclear Silo Station!");
 	new Team = gTeam[playerid];
 	if(NukeTime[Team] > gettime()) return SendClientMessage(playerid, 0x910000FF, "The Nuke can be only used every 30 minutes");
	if(zone < 4 || zone == 15 || zone > 16) return SendClientMessage(playerid, 0x910000FF, "You can not launch a nuke on this zone (Base, Nuclear Launch Station or Invalid)");
	for(new i =0; i < MAX_TEAM_PLAYERS; i++)
	{
		if(Tplayers[Team][i] != INVALID_PLAYER_ID)
 		{
				if(Playerinfo[Tplayers[Team][i]][Score] > Playerinfo[playerid][Score]) return SendClientMessage(playerid, 0x910000FF, "You are not the leader of the team (has highest score)");
		}
	}
	new string[70];
	format(string,sizeof(string),"%s has launched a Nuke on %s",GetTeamName(Team), ZoneInfo[zone][zName]);
	SendClientMessageToAll(0x00469BFF,string);
	NukeTime[Team] = gettime() + 1800;
	new Float:X, Float:Y, Float:Z;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(Playerinfo[i][Capzone] == zone)
		{
			GetPlayerPos(i, X, Y, Z);
			CreateExplosion(X, Y, Z, 7, 10);
		}
	}
  	return 1;
}

CMD:radarjam(playerid, params[])
{
	if(JamTime[gTeam[playerid]] > gettime()) return SendClientMessage(playerid, COLOUR_RED,"Radar Jammers can be only used every 30 minutes!");
	new Team = gTeam[playerid];
	if(ZoneInfo[13][zTeam] != Team) return SendClientMessage(playerid, COLOUR_RED, "Your team does not own the Big Ear to use radar jammers!");
	for(new i = 0; i < MAX_TEAM_PLAYERS; i++)
	{
	    if(Tplayers[Team][i] != INVALID_PLAYER_ID)
	    {
	        if(Playerinfo[Tplayers[Team][i]][Score] > Playerinfo[playerid][Score]) return SendClientMessage(playerid, COLOUR_RED,"You are not the leader of the team (has highest score)");
		}
	}
	new string[70];
	format(string, sizeof(string),"~b~%s has enabled radar jammer!",GetTeamName(Team));
	GameTextForAll(string, 4000, 4);
	JamTime[Team] = gettime() + 1800;
	for(new i = 0; i < MAX_TEAM_PLAYERS; i++)
	{
	    if(Tplayers[Team][i] != INVALID_PLAYER_ID) SetPlayerColor(Tplayers[Team][i], 0xFFFFFF00), Playerinfo[Tplayers[Team][i]][jammed] = true;
	}
	SetTimerEx("JamStop", 300000, 0, "d", Team);
	return 1;
}

CMD:pjam(playerid, params[])
{
	if(Jamcoms{playerid} == 0) return SendClientMessage(playerid, COLOUR_RED,"You do not have any jamcoms to use! Use /shop to buy one");
	Jamcoms{playerid} -= 1;
	Playerinfo[playerid][pjammed] = true;
	SetPlayerColor(playerid, GetSniperColor(gTeam[playerid]));
	SendClientMessage(playerid, COLOUR_GREEN,"Personal Jamcoms enabled");
	return 1;
}

CMD:rac(playerid, params[])
{
	new Scorecount, string[60];
	if(gettime() < ractime[playerid]) return SendClientMessage(playerid, COLOUR_RED,"You can only use Red-Alert-Call every 30 minutes");
	if(RAC{playerid} == 0) return SendClientMessage(playerid, COLOUR_RED,"You do not have any Red-Call-Alerts to use! Use /shop to buy one");
	RAC{playerid} -= 1;
	ractime[playerid] = gettime() + 1800;
	SendClientMessage(playerid, COLOUR_RED,"RED-ALERT: RED-ALERT HAS BEEN CALLED!");
	new Float:X,Float:Y,Float:Z;
	new Float:Xi, Float:Yi, Float:Zi;
	GetPlayerPos(playerid, X, Y, Z);
	for(new i=0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(gTeam[i] != gTeam[playerid])
	        {
	            if(IsPlayerInRangeOfPoint(i, 500, X, Y, Z))
	            {
	                GetPlayerPos(i, Xi, Yi, Zi);
	                SendClientMessage(playerid, COLOUR_RED,"You have been killed by a Red-Call-Alert");
	                SetPlayerHealth(i, 0);
	                CreateExplosion(Xi, Yi, Zi, 11, 5);
	                Playerinfo[playerid][Kills] += 1;
	                Playerinfo[playerid][Score] += 5;
	                Playerinfo[playerid][Tokens] += 1;
	                Scorecount += 5;
				}
			}
		}
	}
	SetPlayerScore(playerid, Playerinfo[playerid][Score]);
	format(string, sizeof(string),"R.A.C score = %d", Scorecount);
	SendClientMessage(playerid, COLOUR_GREEN, string);
	return 1;
}

CMD:stats(playerid, params[])
{
	new Float:KDratio = floatdiv(Playerinfo[playerid][Kills], Playerinfo[playerid][Deaths]);
	new string[100];
 	format(string, sizeof(string),"Kills: %d\nDeaths: %d\nK/D ratio: %.3f\nScore: %d\nRank: %s\nCaptures: %d",Playerinfo[playerid][Kills], Playerinfo[playerid][Deaths], KDratio, Playerinfo[playerid][Score], GetRankNameFromID(Playerinfo[playerid][RankID]), Playerinfo[playerid][Captures]);
	ShowPlayerDialog(playerid, 13, DIALOG_STYLE_MSGBOX,"Stats", string,"Ok","");
	return 1;
}
CMD:kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0);
	return 1;
}
CMD:ranks(playerid, params[])
{
      	SendClientMessage(playerid, 0xEACD00FF, "Ranks:");
		SendClientMessage(playerid, 0xEACD00FF, "Private: < 50XP || Private 1st Class: < 150XP   || Corporal: < 350XP");
	    SendClientMessage(playerid, 0xEACD00FF, "Sergeant: < 700XP || Sergeant 1st Class: < 1400XP || Master Sergeant: < 2200XP");
  		SendClientMessage(playerid, 0xEACD00FF, "Sergeant Major: < 3400XP || Lieutenant: < 4800XP || Captain: < 6000XP");
    	SendClientMessage(playerid, 0xEACD00FF, "Major: < 7750XP || Colonel: < 10000XP || Brigadier General: < 13000XP");
     	SendClientMessage(playerid, 0xEACD00FF, "Major General: < 16000XP || Lieutenant General: < 20000XP || General: 20000XP+");
     	return 1;
}
CMD:shop(playerid, params[])
{
	new Float:X,Float:Y,Float:Z;
	new Zone = gTeam[playerid];
	GetPlayerPos(playerid, X, Y, Z);
	if(X < ZoneInfo[Zone][zMinX] || X > ZoneInfo[Zone][zMaxX] || Y < ZoneInfo[Zone][zMinY] || Y > ZoneInfo[Zone][zMaxY]) return SendClientMessage(playerid, COLOUR_RED,"You are not at your base to use this command!");
	ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST,"Shop","Armour(10BP)\nHealth(7BP)\nPersonal Jamcoms(25BP)\nRed-Call-Alert(50BP)","Buy","Cancel");
	return 1;
}
CMD:heal(playerid, params[])
{
	new targetid;
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /heal [id]");
	if(Pclass[playerid] != 1) return SendClientMessage(playerid, COLOUR_RED,"You are not a medic to use this command");
	if(hTimer[targetid] > gettime()) return SendClientMessage(playerid, COLOUR_RED,"The target player has been healed recently!");
	new Float:X, Float:Y, Float:Z, Float:th;
	GetPlayerPos(playerid, X, Y, Z);
	if(!IsPlayerInRangeOfPoint(targetid, 15, X, Y, Z)) return SendClientMessage(playerid, COLOUR_GREY, "The specified id is not within range");
	GetPlayerHealth(targetid, th);
	if(th > 90) return SendClientMessage(playerid, COLOUR_GREY,"The player does not need to be healed!");
	if(gTeam[targetid] != gTeam[playerid]) return SendClientMessage(playerid, COLOUR_RED,"You can not heal an enemy!");
	SetPlayerHealth(targetid, 99.0);
	PlayerTextDrawSetString(targetid, Hdraw[targetid], "----------~n~+ 100~n~----------");
	hTimer[targetid] = gettime() + 30;
	if(playerid != targetid)
	{
	    new string[70], pname[24];
	    GetPlayerName(playerid, pname, sizeof(pname));
	    format(string, sizeof(string),"Medic %s has healed you!", pname);
	    SendClientMessage(targetid, COLOUR_GREEN, string);
	    Playerinfo[playerid][Score] += 3;
	    SetPlayerScore(playerid, Playerinfo[playerid][Score]);
	    SetPlayerRankFromScore(playerid, Playerinfo[playerid][Score]);
		Update3DTextLabelText(Labels[playerid], 0xD7D7D7FF, GetRankNameFromID(Playerinfo[playerid][RankID]));
		PlayerTextDrawSetString(playerid, Rankdraw[playerid], GetRankNameFromID(Playerinfo[playerid][RankID]));
		PlayerTextDrawSetString(playerid, Secondaryreward[playerid], "Heal  3XP");
		PlayerTextDrawShow(playerid, Secondaryreward[playerid]);
		Rewardtime[playerid] = SetTimerEx("Rewardhide", 2000, 0, "i", playerid);
	}
	return 1;
}

CMD:rammo(playerid, params[])
{
	new targetid;
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /rammo [id]");
	if(Pclass[playerid] != 4) return SendClientMessage(playerid, COLOUR_RED,"You are not a Support unit to use this command");
	if(rTimer[targetid] > gettime()) return SendClientMessage(playerid, COLOUR_RED,"The target player had his ammo refilled recently!");
	new Float:X, Float:Y,Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(!IsPlayerInRangeOfPoint(targetid, 15, X, Y, Z)) return SendClientMessage(playerid, COLOUR_GREY,"The id specified is not within range");
	if(gTeam[playerid] != gTeam[targetid]) return SendClientMessage(playerid, COLOUR_RED,"You can not restore ammo for an enemy!");
    ResetPlayerWeapons(targetid);
   	GivePlayerPack(targetid, Pclass);
   	rTimer[targetid] = gettime() + 40;
    if(targetid != playerid)
    {
		new string[70], pname[24];
		GetPlayerName(playerid, pname, sizeof(pname));
		format(string, sizeof(string),"Your ammo has been refilled by %s", pname);
		SendClientMessage(targetid, COLOUR_GREEN, string);
		Playerinfo[playerid][Score] += 4;
		SetPlayerScore(playerid, Playerinfo[playerid][Score]);
		SetPlayerRankFromScore(playerid, Playerinfo[playerid][Score]);
		Update3DTextLabelText(Labels[playerid], 0xD7D7D7FF, GetRankNameFromID(Playerinfo[playerid][RankID]));
		PlayerTextDrawSetString(playerid, Rankdraw[playerid], GetRankNameFromID(Playerinfo[playerid][RankID]));
		PlayerTextDrawSetString(playerid, Secondaryreward[playerid], "Ammo Resupply   4XP");
		PlayerTextDrawShow(playerid, Secondaryreward[playerid]);
		Rewardtime[playerid] = SetTimerEx("Rewardhide", 2000, 0, "i", playerid);
	}
	return 1;
}
CMD:capture(playerid, params[])
{
    new Float:X,Float:Y,Float:Z;
    new Zone;
    new Team = gTeam[playerid];
	GetPlayerPos(playerid, X,Y,Z);
	for(new i = 4; i < 17; i++)
	{
 		if(X > ZoneInfo[i][zMinX] && X < ZoneInfo[i][zMaxX] && Y > ZoneInfo[i][zMinY] && Y < ZoneInfo[i][zMaxY])
 		{
 		   Zone = i;
 		   break;
		}
	}
	Czone[playerid] = Zone;
	if(Zone > 3)
	{
		if(ZoneInfo[Zone][attacked] == false)
		{
			if(ZoneInfo[Zone][zTeam] != Team)
			{
			    new Float:mX[13],Float:mY[13], Float:mZ[13];
			    new Float:ZmaxX = ZoneInfo[Zone][zMaxX], Float:ZminX = ZoneInfo[Zone][zMinX], Float:ZminY = ZoneInfo[Zone][zMinY], Float:ZmaxY = ZoneInfo[Zone][zMaxY];
 				for(new i = 0; i < MAX_TEAM_PLAYERS; i++)
	    		{
	    		    	new mateid = Tplayers[Team][i];
	    	        	GetPlayerPos(mateid, mX[i], mY[i], mZ[i]);
	        			if(ZoneInfo[Zone][zMaxX] > mX[i] > ZoneInfo[Zone][zMinX] && ZoneInfo[Zone][zMaxY] > mY[i] > ZoneInfo[Zone][zMinY])
	        			{
	        			    new string[40];
	            			CapturingPlayers[Zone] += 1;
	            			SetPlayerWorldBounds(mateid, ZmaxX, ZminX, ZmaxY, ZminY);
	            			Playerinfo[mateid][Capzone] = Zone;
							format(string, sizeof(string),"%s ~n~%d", ZoneInfo[Zone][zName], ZoneInfo[Zone][zTime]/1000);
							PlayerTextDrawSetString(mateid, Cdraw[mateid], string);
							PlayerTextDrawShow(mateid, Cdraw[mateid]);
						}
				}
				if(CapturingPlayers[Zone] >= ZoneInfo[Zone][Playersreq])
				{
		    		new string[150];
		    		format(string,sizeof(string),"~r~%s is being captured by %s!", ZoneInfo[Zone][zName], GetTeamName(gTeam[playerid]));
		    		GameTextForAll(string, 4000, 4);
	    			//Start Capture
	    			ZoneInfo[Zone][attacked] = true;
	    			cTime[Zone] = ZoneInfo[Zone][zTime]/1000;
	    			zSetter[Zone] = SetTimerEx("SetGangZoneTeam", ZoneInfo[Zone][zTime]+300, 0, "i",playerid);
	    			zTimer[Zone] = SetTimerEx("ZoneTimer", 1000, 1, "i", playerid);
					GangZoneFlashForAll(ZoneID[Zone], GetTeamZoneColor(Team));
				}
				else
				{
    					new string3[150];
						format(string3, sizeof(string3),"This area requires %d players to be captured!", ZoneInfo[Zone][Playersreq]);
						SendClientMessage(playerid,0x6F0000FF, string3);
						CapturingPlayers[Zone] = 0;
						Czone[playerid] = 0;
						for(new i = 0; i < MAX_TEAM_PLAYERS; i++)
						{
							new mateid = Tplayers[Team][i];
							if(mateid != INVALID_PLAYER_ID)
							{
								if(Playerinfo[mateid][Capzone] == Zone)
  								{
	        						SetPlayerWorldBounds(mateid, 20000,-20000,20000,-20000);
	        						PlayerTextDrawHide(mateid, Cdraw[mateid]);
								}
							}
						}
						return 1;
				}
			}
			else
			{
	    		SendClientMessage(playerid, 0x6F0000FF, "You can not capture an area that belongs to your team!");
	    		Czone[playerid] = 0;
			}
		}
		else
		{
		    SendClientMessage(playerid, 0x6F0000FF, "Zone is already being captured!");
		    Czone[playerid] = 0;
		}
	}
	else
	{
		SendClientMessage(playerid,0x6F0000FF, "You are not in a capturable zone!");
		Czone[playerid] = 0;
	}
	return 1;
}

CMD:scan(playerid, params[])
{
	new tid;
	if(sscanf(params,"u", tid)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /scan [playerid]");
	if(!IsPlayerConnected(tid)) return SendClientMessage(playerid, COLOUR_GREY,"The specified ID is offline!");
	new Float:th, Float:Vx, Float:Vy, Float:Vz;
	new tvid = GetPlayerVehicleID(tid);
	new tweapon7,tweapon4,tweapon3,tweapon2,tweapon1,tweapon8, nulla;
	GetPlayerHealth(tid, th);
	GetPlayerVelocity(tid, Vx, Vy, Vz);
	new tname[24], string[128];
	GetPlayerName(tid, tname, sizeof(tname));
	GetPlayerWeaponData(tid, 7, tweapon7, nulla);
	GetPlayerWeaponData(tid, 4, tweapon4, nulla);
	GetPlayerWeaponData(tid, 3, tweapon3, nulla);
	GetPlayerWeaponData(tid, 2, tweapon2, nulla);
	GetPlayerWeaponData(tid, 1, tweapon1, nulla);
	GetPlayerWeaponData(tid, 8, tweapon8, nulla);
	if(th >= 100)
	{
	    format(string, sizeof(string),"A.C.S has banned player %s for Health Hacks!", tname);
	    SendClientMessageToAll(COLOUR_RED, string);
		Ban(tid);
	}
	else if(tweapon7 == 38 || tweapon7 == 35 || tweapon7 == 37)
 	{
 	   	format(string, sizeof(string),"A.C.S has banned player %s for Weapon Hacks!", tname);
	    SendClientMessageToAll(COLOUR_RED, string);
		Ban(tid);
 	}
 	else if((tweapon4 != 29 && tweapon4 != 0) || (tweapon3 != 27 && tweapon3 != 0) || (tweapon2 != 24 && tweapon2 != 0) || tweapon1 != 0 || tweapon8 != 0)
	{
		format(string, sizeof(string),"A.C.S has banned player %s for Weapon Hacks!", tname);
	    SendClientMessageToAll(COLOUR_RED, string);
		Ban(tid);
 	}
	else if(GetPlayerScore(tid) > Playerinfo[tid][Score])
	{
	    format(string, sizeof(string),"A.C.S has banned player %s for Status Hacks(Score)!", tname);
	    SendClientMessageToAll(COLOUR_RED, string);
	    Ban(tid);
	}
	else if(GetPlayerWeapon(tid) == 36 && GetPlayerAmmo(tid) > 5)
	{
	    format(string, sizeof(string),"A.C.S has banned player %s for Weapon Hacks!", tname);
	    SendClientMessageToAll(COLOUR_RED, string);
		Ban(tid);
	}
	else if((floatsqroot(((Vx*Vx)+(Vy*Vy))+(Vz*Vz))*136.666667) > 250.0)
	{
 		format(string, sizeof(string),"A.C.S has banned player %s for Speed Hacks!", tname);
	    SendClientMessageToAll(COLOUR_RED, string);
		Ban(tid);
	}
	else if((GetVehicleModel(tvid) == 578 && Playerinfo[tid][RankID] < 6) || (GetVehicleModel(tvid) == 432 && Playerinfo[tid][RankID] < 7) || ((GetVehicleModel(tvid) == 519 || GetVehicleModel(tvid) == 447) && Playerinfo[tid][RankID] < 8) || (GetVehicleModel(tvid) == 425 && Playerinfo[tid][RankID] < 9) || (GetVehicleModel(tvid) == 520 && Playerinfo[tid][RankID] < 10))
	{
	    format(string, sizeof(string),"A.C.S has banned player %s for Status Hacks(Rank)!", tname);
	    SendClientMessageToAll(COLOUR_RED, string);
		Ban(tid);
	}
	else SendClientMessage(playerid, COLOUR_GREY,"A.C.S was unable to detect any hacks by the player specified, if you insist please use /report");
	return 1;
}

CMD:rules(playerid, params[])
{
	ShowPlayerDialog(playerid, 11, DIALOG_STYLE_MSGBOX,"Rules","1. No drive-by with Desert-Eagle or SPAS12\n2. No Heli-blade killing\n3. You are not allowed to be afk for more than 10 seconds while in MRL\n4. No hacks and no insults\n5. Don't be hostile to your teammates\n6. Don't false report to annoy admins\n7. Don't be paused in capture zones","Ok","");
	return 1;
}
//--------------------------------------VIP Commands----------------------------------------------//
CMD:vipclub(playerid, params[])
{
	if(GetPVarInt(playerid, "Viplevel") < 1) return SendClientMessage(playerid, COLOUR_RED,"You are not a VIP to use this command!");
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerInRangeOfPoint(i, 100, X, Y, Z) && (i != playerid)) return SendClientMessage(playerid, COLOUR_RED,"You can not leave the battlefield now, there is an enemy nearby!");
	}
	DSP{playerid} = 1;
	for(new i =0; i < MAX_TEAM_PLAYERS; i++)
	{
			    if(Tplayers[gTeam[playerid]][i] == playerid)
				{
				 	Tplayers[gTeam[playerid]][i] = INVALID_PLAYER_ID;
			    	break;
				}
	}
	gTeam[playerid] = TEAM_NULL;
	SetSpawnInfo(playerid, 4, Teaminfo[4][Skin],Teaminfo[4][TX],Teaminfo[4][TY],Teaminfo[4][TZ],Teaminfo[4][TAngle],0,0,0,0,0,0);
	SetPlayerSkin(playerid, GetPVarInt(playerid, "VIPskin"));
	SetPlayerHealth(playerid, 0);
	return 1;
}

CMD:radio(playerid, params[])
{
	if(GetPVarInt(playerid,"Viplevel") < 1) return SendClientMessage(playerid, COLOUR_RED,"You need to have a Bronze VIP status or above to use this command!");
	ShowPlayerDialog(playerid, 14, DIALOG_STYLE_LIST,"Choose Radio/Playlist","{004AD5}Radio:{FFFFFF}\nPulse87NY\nFRISKY\nDubbase.FM\nBeat FM\nAmsterdam Trance\nABSOLUTE TOP40\nRadiospak\n{14CC00}Playlists:{FFFFFF}\nMonstercat-Bestof 2013","Play","Close");
	return 1;
}

CMD:manageattachedobject(playerid, parmas[])
{
	new string[160];
 	format(string, sizeof(string),"Slot 0:%s\nSlot 1:%s\nSlot 2:%s\nSlot 3:%s\nSlot 4:%s\nSlot 5:%s\nSlot 6:%s\nSlot 7:%s\nSlot 8:%s\nSlot 9:%s",SlotIO(playerid, 0),SlotIO(playerid, 1),SlotIO(playerid, 2),SlotIO(playerid, 3),SlotIO(playerid, 4),SlotIO(playerid, 5),SlotIO(playerid, 6),SlotIO(playerid, 7),SlotIO(playerid, 8),SlotIO(playerid, 9));
   	ShowPlayerDialog(playerid, 22,DIALOG_STYLE_LIST,"Choose USED Slot",string,"Select","Cancel");
	return 1;
}
//------------------------------End of VIP Commands-----------------------------------------------//
//--------------------------------Admin Commands--------------------------------------------------//
CMD:restart(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 5) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 5 to use this command!");
	SendRconCommand("gmx");
	return 1;
}

CMD:clearchat(playerid, params[])
{
	new pname[24], string[50];
	if(Playerinfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 2 to use this command!");
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string),"Admin %s has cleared the chat!", pname);
	for(new i = 0;i < 10; i++)
	{
	    SendClientMessageToAll(COLOUR_GREEN," ");
	}
	SendClientMessageToAll(COLOUR_GREEN, string);
	return 1;
}

CMD:viplevelset(playerid, params[])
{
	new targetid, viplevel;
	if(Playerinfo[playerid][Adminlevel] < 5) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 5 to use this command!");
	if(sscanf(params,"dd", targetid, viplevel)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /viplevelset [ID] [VIPLevel]");
	new query[65];
	if(GetPVarInt(targetid, "Viplevel") > 0)
	{
	    mysql_format(mysqldb, query, sizeof(query), "UPDATE VIPs SET Viplevel = %d WHERE ID = %d", viplevel, Playerinfo[targetid][dbID]);
	    mysql_tquery(mysqldb, query);
	}
	else
	{
	    mysql_format(mysqldb, query, sizeof(query), "INSERT INTO VIPs Values(%d, %d, 98, 0.0)", Playerinfo[targetid][dbID], viplevel);
	    mysql_tquery(mysqldb, query);
	}
	SetPVarInt(targetid, "Viplevel", viplevel);
	SendClientMessage(playerid, COLOUR_GREEN, "Player's vip level has been updated");
	GetPlayerName(playerid, query, sizeof(query));
	format(query, sizeof(query), "Your VIP level is set to %d by Admin %s", viplevel, query);
	SendClientMessage(targetid, COLOUR_GREEN, query);
	return 1;
}

CMD:resetboundary(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 4) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 4 to use this command!");
	new targetid;
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /resetboundary [playerid]");
	SetPlayerWorldBounds(targetid, 20000, -20000, 20000, -20000);
	SendClientMessage(playerid, COLOUR_GREEN,"Bounds have been reset successfully!");
	SendClientMessage(targetid, COLOUR_GREEN,"Your bounds have been reset by an Admin");
	return 1;
}

CMD:time(playerid,params[])
{
	if(Playerinfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid, COLOUR_RED, "You need to be an admin of level 2 to use this command!");
	new time, pname[24], string[60];
	if(sscanf(params,"d", time)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /time [hh] , for example: /time 12 makes time 12:00");
	if(time < 0 || time > 23) return SendClientMessage(playerid, COLOUR_GREY, "The time must be between 00 and 23");
	SetWorldTime(time);
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string), "Admin %s has changed the game time", pname);
	SendClientMessageToAll(COLOUR_GREEN, string);
	return 1;
}

CMD:announce(playerid, params[])
{
	new msg[128];
	if(Playerinfo[playerid][Adminlevel] < 3) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 3 to use this command!");
	if(sscanf(params,"s[128]", msg)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /announce [message]");
	GameTextForAll(msg, 5000, 4);
	return 1;
}

CMD:setscore(playerid, params[])
{
	new targetid, score, pname[24], string[100];
	if(Playerinfo[playerid][Adminlevel] < 5) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 5 to use this command!");
	if(sscanf(params,"ui", targetid, score)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /setscore [playerid][score]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOUR_GREY,"The ID specified is offline!");
	SetPlayerScore(targetid, score);
	Playerinfo[targetid][Score] = score;
	SetPlayerRankFromScore(targetid, score);
	Update3DTextLabelText(Labels[targetid], 0xD7D7D7FF, GetRankNameFromID(Playerinfo[targetid][RankID]));
	PlayerTextDrawSetString(targetid, Rankdraw[targetid], GetRankNameFromID(Playerinfo[targetid][RankID]));
	format(string, sizeof(string),"Score: %d~n~BattlePoints: %d", Playerinfo[targetid][Score], Playerinfo[targetid][Tokens]);
	PlayerTextDrawSetString(targetid, Scoredraw[targetid], string);
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string),"Admin %s has changed your score to %d", pname, score);
	SendClientMessage(targetid, COLOUR_GREY,string);
	SendClientMessage(playerid, COLOUR_GREEN,"Score set successfully!");
	return 1;
}

CMD:gethere(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 4) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 4 to use this command!");
	new targetid;
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid,COLOUR_GREY,"Usage: /gethere [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOUR_GREY,"The ID specified is offline!");
	new Float:X, Float:Y, Float:Z, string[80], pname[24];
	GetPlayerPos(playerid, X, Y, Z);
	SetPlayerPos(targetid, X+2, Y, Z);
	GetPlayerName(playerid, pname, sizeof(pname));
	SendClientMessage(playerid, COLOUR_GREEN,"Player specified has been teleported successfully");
	format(string, sizeof(string),"You have been teleported to admin %s", pname);
	SendClientMessage(targetid, COLOUR_GREEN,string);
	return 1;
}

CMD:goto(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 4) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 4 to use this command!");
	new targetid;
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /goto [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOUR_GREY,"The ID specified is offline!");
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(targetid, X, Y, Z);
	SetPlayerPos(playerid, X+3, Y, Z);
	SendClientMessage(playerid, COLOUR_GREEN,"Successfully teleported to target-id");
	return 1;
}

CMD:kick(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 3) return SendClientMessage(playerid, COLOUR_RED, "You need to be an admin of level 3 to use this command!");
	new pname[24], tname[24], string[200], reason[70], tid;
	if(sscanf(params,"us[70]", tid, reason)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /kick [playerid] [reason]");
	if(!IsPlayerConnected(tid)) return SendClientMessage(playerid, COLOUR_GREY, "The ID specified is offline!");
	GetPlayerName(playerid, pname, sizeof(pname)), GetPlayerName(tid, tname, sizeof(tname));
	format(string, sizeof(string), "Admin %s has kicked player %s for: %s", pname, tname, reason);
	SendClientMessageToAll(COLOUR_RED, string);
	SetTimerEx("pKick", 400, 0, "d", tid);
	return 1;
}

CMD:ban(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 4) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 4 to use this command!");
	new pname[24], tname[24], string[200], reason[70], tid;
	if(sscanf(params,"us[70]", tid, reason)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /ban [playerid] [reason]");
	if(!IsPlayerConnected(tid)) return SendClientMessage(playerid, COLOUR_GREY, "The ID specified is offline!");
	if(Playerinfo[tid][Adminlevel] > 4) return SendClientMessage(playerid, COLOUR_RED,"You may NOT ban a level 5 admin");
	GetPlayerName(playerid, pname, sizeof(pname)), GetPlayerName(tid, tname, sizeof(tname));
	format(string, sizeof(string), "Admin %s has banned player %s for: %s", pname, tname, reason);
	SendClientMessageToAll(COLOUR_RED, string);
	SetTimerEx("pBan", 400, 0, "ds", tid, reason);
	return 1;
}

CMD:banip(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 4) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 4 to use this command!");
	new ip[20];
	if(sscanf(params,"s[15]",ip)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /banip [ip]");
	new string[30];
	format(string, sizeof(string),"banip %s", ip);
	SendRconCommand(string);
	SendRconCommand("reloadbans");
	format(string, sizeof(string), "IPBAN: %s", ip);
	SendClientMessage(playerid, COLOUR_GREEN,string);
	return 1;
}

CMD:reloadbans(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 4) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 4 to use this command!");
	SendRconCommand("reloadbans");
	SendClientMessage(playerid, COLOUR_GREEN,"Bans reloaded");
	return 1;
}

CMD:spectate(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid, COLOUR_RED, "You need to be an admin of level 2 to use this command!");
	new targetid;
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /spectate [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOUR_GREY, "The ID specified is offline!");
	TogglePlayerSpectating(playerid, 1);
 	PlayerSpectatePlayer(playerid, targetid, SPECTATE_MODE_NORMAL);
 	return 1;
}

CMD:stopspectate(playerid, params[])
{
	TogglePlayerSpectating(playerid, 0);
	return 1;
}

CMD:freeze(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid, COLOUR_RED, "You need to be an admin of level 2 to use this command!");
	new targetid, pname[24], string[70];
	if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /freeze [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOUR_GREY, "The ID specified is offline!");
	TogglePlayerControllable(targetid, 0);
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string),"You have been frozen by Admin %s", pname);
	SendClientMessage(targetid, COLOUR_RED, string);
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid, COLOUR_RED, "You need to be an admin of level 2 to use this command!");
	new targetid, pname[24], string[70];
	if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /unfreeze [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOUR_GREY, "The ID specified is offline!");
	TogglePlayerControllable(targetid, 1);
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string), "You have been unfrozen by Admin %s", pname);
	SendClientMessage(targetid, COLOUR_GREEN, string);
	return 1;
}

CMD:mute(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid, COLOUR_RED, "You need to be an admin of level 2 to use this command!");
	new targetid, pname[24], string[70];
	if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /mute [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOUR_GREY, "The ID specified is offline!");
	if(Playerinfo[targetid][muted]) return SendClientMessage(playerid, COLOUR_GREY, "Player is already muted");
	Playerinfo[targetid][muted] = true;
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string), "You have been muted for 1 minute by Admin %s", pname);
	SendClientMessage(targetid, COLOUR_RED, string);
	SetTimerEx("Unmute", 60000, 0, "d", targetid);
	return 1;
}

CMD:unmute(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid, COLOUR_RED, "You need to be an admin of level 2 to use this command!");
	new targetid, pname[24], string[70];
	if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /unmute [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOUR_GREY, "The ID specified is offline!");
	Playerinfo[targetid][muted] = false;
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string), "You have been unmuted by Admin %s", pname);
	SendClientMessage(targetid, COLOUR_GREEN, string);
	return 1;
}

CMD:weather(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid, COLOUR_RED,"You need to be an admin of level 2 to use this command!");
	new weather, pname[24], string[70];
	if(sscanf(params, "d", weather)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /weather [weatherid]");
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string),"Admin %s has changed the weather", pname);
	SetWeather(weather), SendClientMessageToAll(COLOUR_GREEN, string);
	return 1;
}

CMD:sal(playerid, params[])
{
	if(Playerinfo[playerid][Adminlevel] < 5) return SendClientMessage(playerid, COLOUR_RED, "You need to be an admin of level 5 to use this command!");
	new targetid, level, pname[24], string[70];
	if(sscanf(params, "ud", targetid, level)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /sal [playerid] [adminlevel 0-4]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOUR_GREY, "The ID specified is offline!");
	if(Playerinfo[targetid][Adminlevel] > 4 && playerid != targetid) return SendClientMessage(playerid, COLOUR_RED,"You may NOT change the admin level of a level 5 admin");
	Playerinfo[targetid][Adminlevel] = level;
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string),"Admin %s has set your admin level to: %d !", pname, level);
	SendClientMessage(targetid, 0x00D9D3FF,string);
	return 1;
}

CMD:ac(playerid, params[])
{
    new  pname[24], message[128], string[180];
    if(Playerinfo[playerid][Adminlevel] == 0) return SendClientMessage(playerid, COLOUR_RED,"You are not allowed to use admin chat");
	if(sscanf(params,"s[128]", message)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /ac [message]");
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string,sizeof(string),"ADMIN CHAT: %s(%d): %s", pname, playerid, message);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(Playerinfo[i][Adminlevel] > 0) SendClientMessage(i, 0xE17600FF, string);
	}
	return 1;
}
//----------------------------------------------End of Admin Commands-----------------------------------------//
CMD:report(playerid, params[])
{
	new id, pname[24], reason[70], string[200];
	if(sscanf(params,"us[70]",id, reason)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /report [id] [reason]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOUR_GREY, "The ID specified is offline!");
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string),"REPORT: %s reports player ID %d for: %s!", pname, id, reason);
	SendClientMessage(playerid, COLOUR_GREEN, "Your report has been sent to all online admins and will be processed soon");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(Playerinfo[i][Adminlevel] > 1) SendClientMessage(i, 0xD96713FF, string);
	}
	return 1;
}

CMD:ask(playerid, params[])
{
	new question[128], pname[24], string[180];
	if(sscanf(params,"s[128]", question)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /ask [question]");
	SendClientMessage(playerid, COLOUR_GREEN, "Your question has been sent to all helpers online and will be processed shortly");
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string),"QUESTION: %s ID(%d) asks: %s ",pname, playerid, question);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(Playerinfo[i][Adminlevel] == 1) SendClientMessage(i, 0xD96713FF, string);
	}
	return 1;
}

CMD:pm(playerid, params[])
{
	new id, pname[24], tname[24], message[128], string[170];
	if(sscanf(params,"us[128]", id, message)) return SendClientMessage(playerid, COLOUR_GREY, "Usage: /pm [id] [message]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOUR_GREY,"The ID specified is offline!");
	if(Playerinfo[id][pmreject]) return SendClientMessage(playerid, COLOUR_GREY,"The id specified does not accept PMs");
	Playerinfo[playerid][lastpm] = id;
	Playerinfo[id][lastpm] = playerid;
	GetPlayerName(id, tname, sizeof(tname)), GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string), "PM sent to %s(%d): %s", tname, id, message);
	SendClientMessage(playerid, 0xFCCA1DFF, string);
	format(string, sizeof(string),"PM from %s(%d): %s", pname, playerid, message);
	SendClientMessage(id, 0xFCCA1DFF, string);
	return 1;
}

CMD:r(playerid, params[])
{
	new pname[24], tname[24], message[128], string[170];
	if(sscanf(params,"s[128]", message)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /r [message]");
	new targetid = Playerinfo[playerid][lastpm];
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOUR_GREY,"The ID specified is offline!");
	if(Playerinfo[targetid][pmreject]) return SendClientMessage(playerid, COLOUR_GREY,"The id specified does not accept PMs");
	GetPlayerName(playerid, pname, sizeof(pname)), GetPlayerName(targetid, tname, sizeof(tname));
	format(string, sizeof(string),"PM sent to %s(%d): %s", tname, targetid, message);
	SendClientMessage(playerid, 0xFCCA1DFF,string);
	format(string, sizeof(string),"PM from %s(%d): %s", pname, playerid, message);
	SendClientMessage(targetid, 0xFCCA1DFF, string);
	return 1;
}

CMD:tc(playerid, params[])
{
	new  pname[24], message[128], string[180];
	if(sscanf(params,"s[128]", message)) return SendClientMessage(playerid, COLOUR_GREY,"Usage: /tc [message]");
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string,sizeof(string),"TEAM CHAT: %s(%d): %s", pname, playerid, message);
	new Team = gTeam[playerid];
	if(Team == 4) return SendClientMessage(playerid, COLOUR_GREY,"You are not in a valid team at the moment!");
	for(new i = 0; i < MAX_TEAM_PLAYERS; i++)
	{
	    if(Tplayers[Team][i] != INVALID_PLAYER_ID) SendClientMessage(Tplayers[Team][i], 0x007AA8FF, string);
	}
	return 1;
}

CMD:togglepm(playerid, params[])
{
	if(!Playerinfo[playerid][pmreject])
	{
	 	Playerinfo[playerid][pmreject] = true;
	 	SendClientMessage(playerid, 0xEACD00FF,"You will now block incoming PMs!");
	}
	else
	{
	 	Playerinfo[playerid][pmreject] = false;
	  	SendClientMessage(playerid, 0xEACD00FF,"You will now accept incoming PMs!");
	}
	return 1;
}

CMD:admins(playerid, params[])
{
	SendClientMessage(playerid, 0xDFCE00FF,"Admins Online:");
	for(new i = 0;i < MAX_PLAYERS; i++)
	{
	    if(Playerinfo[i][Adminlevel] > 1)
	    {
	        new aname[24];
			GetPlayerName(i, aname, sizeof(aname));
			SendClientMessage(playerid, 0xDFCE00FF, aname);
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(GetVehicleModel(vehicleid) == 578)
	{
	    new Float:X, Float:Y,Float:Z;
	    GetVehiclePos(vehicleid, X, Y, Z);
	    SetPlayerPos(playerid, X+2.5, Y, Z);
	}
	/*else if(GetVehicleModel(vehicleid) == 432)
	{
	    new variable;
	    variable = 1 << (vehicleid - 17);
	    TanksOccupied = TanksOccupied ^ variable;
	}*/
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if((oldstate == 1 && newstate == 2) || (oldstate == 1 && newstate == 3))
	{
		PlayerTextDrawSetString(playerid, Magdraw[playerid], "~h~--");
		PlayerTextDrawSetString(playerid, Ammodraw[playerid], "~h~/ ---");
 		if(vehicleid == USMRL || vehicleid == EUMRL || vehicleid == INMRL || vehicleid == RUMRL)
		{
		    if(Playerinfo[playerid][RankID] < 6)
		    {
		        RemovePlayerFromVehicle(playerid);
	        	SendClientMessage(playerid, 0x6F0000FF, "You need to be a Sergeant Major or higher to use MRLs!");
			}
		}
		else if(GetVehicleModel(vehicleid) == 432)
		{
		    if(Playerinfo[playerid][RankID] < 7)
		    {
      			RemovePlayerFromVehicle(playerid);
	        	SendClientMessage(playerid, 0x6F0000FF, "You need to be a Lieutenant or higher to use Tanks!");
			}
			/*else
			{
			    new variable = 1 << (vehicleid - 17);
			    TanksOccupied = TanksOccupied | variable;
			}*/
		}
		else if(GetVehicleModel(vehicleid) == 519 || GetVehicleModel(vehicleid) == 447)
		{
		    if(Pclass[playerid] != AIRFORCE_CLASS)
		    {
		        if(Pclass[playerid] != VIP_CLASS)
		        {
		        	RemovePlayerFromVehicle(playerid);
	        		SendClientMessage(playerid, 0x6F0000FF, "You need to be an airforce unit (or using VIP Class) to use this vehicle!");
				}
			}
		}
	 	else if(GetVehicleModel(vehicleid) == 425 && (Pclass[playerid] != AIRFORCE_CLASS || Playerinfo[playerid][RankID] < 9))
	 	{
   			RemovePlayerFromVehicle(playerid);
			SendClientMessage(playerid, 0x6F0000FF, "You need to be an airforce unit to use this vehicle and be a Major or higher!");
	 	}
	 	else if(GetVehicleModel(vehicleid) == 520 && (Pclass[playerid] != AIRFORCE_CLASS || Playerinfo[playerid][RankID] < 10))
	 	{
	 	    RemovePlayerFromVehicle(playerid);
			SendClientMessage(playerid, 0x6F0000FF, "You need to be an airforce unit to use this vehicle and be a Colonel or higher!");
	 	}
	 	else if(vehicleid == USMSAM || vehicleid == EUMSAM || vehicleid == INMSAM || vehicleid == RUMSAM)
	 	{
	 	    if(Playerinfo[playerid][RankID] < 11)
	 	    {
	 	    	RemovePlayerFromVehicle(playerid);
				SendClientMessage(playerid, 0x6F0000FF, "You need to be a Brigadier General to use the MSAMs!");
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	SetPlayerPos(playerid, 1473.8882,-3600.9065,58.3500);
	SetPlayerFacingAngle(playerid, 359.6806);
	StopAudioStreamForPlayer(playerid);
	SetPlayerVirtualWorld(playerid, playerid);
	DisablePlayerCheckpoint(playerid);
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	SetSpawnInfo(playerid, 4, Teaminfo[4][Skin],Teaminfo[4][TX],Teaminfo[4][TY],Teaminfo[4][TZ],Teaminfo[4][TAngle],0,0,0,0,0,0);
	SpawnPlayer(playerid);
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == VIPattachpickup)
 	{
	        new string[160];
	        format(string, sizeof(string),"Slot 0:%s\nSlot 1:%s\nSlot 2:%s\nSlot 3:%s\nSlot 4:%s\nSlot 5:%s\nSlot 6:%s\nSlot 7:%s\nSlot 8:%s\nSlot 9:%s",SlotIO(playerid, 0),SlotIO(playerid, 1),SlotIO(playerid, 2),SlotIO(playerid, 3),SlotIO(playerid, 4),SlotIO(playerid, 5),SlotIO(playerid, 6),SlotIO(playerid, 7),SlotIO(playerid, 8),SlotIO(playerid, 9));
	        SendClientMessage(playerid, 0xEA6400FF,"NOTE: The objects you attach to Torso or Head, may coflict, or get automatically removed, when you use team India!");
	        ShowPlayerDialog(playerid, 16,DIALOG_STYLE_LIST,"Choose Slot",string,"Select","Cancel");
  	}
  	else if(pickupid == VIPsetpickup)
	{
	        ShowPlayerDialog(playerid, 17, DIALOG_STYLE_LIST,"VIP Options","Go back to the Battlefield(PRESS 'F4' FIRST!)\nSet VIP Skin\nCheck VIP Status","Select","Cancel");
	}
	else if(pickupid == VIPtoclubpickup)
	{
	    SetPlayerPos(playerid, 799.4636,-3368.6323,636.5541);
	    SetPlayerFacingAngle(playerid, 180);
	    PlayAudioStreamForPlayer(playerid, "http://icy3.abacast.com/pulse87-pulse87mp3-64",0,0,0,0,0);
	    SetPlayerVirtualWorld(playerid, 0);
	    SetPlayerCheckpoint(playerid, 799.4636,-3364.6323,635.7541, 3);
	}
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    new string[15];
	if(response)
	{
      		format(string, sizeof(string),"AttachObj%d", index);
			SetPVarInt(playerid, string, modelid);
			format(string, sizeof(string), "ObjBone%d", index);
			SetPVarInt(playerid, string, boneid);
			format(string, sizeof(string), "ObjRotX%d", index);
			SetPVarFloat(playerid, string, fRotX);
			format(string, sizeof(string), "ObjRotY%d", index);
			SetPVarFloat(playerid, string, fRotY);
			format(string, sizeof(string), "ObjRotZ%d", index);
			SetPVarFloat(playerid, string, fRotZ);
			format(string, sizeof(string), "ObjOffX%d", index);
			SetPVarFloat(playerid, string, fOffsetZ);
			format(string, sizeof(string), "ObjOffY%d", index);
			SetPVarFloat(playerid, string, fOffsetY);
			format(string, sizeof(string), "ObjOffZ%d", index);
			SetPVarFloat(playerid, string, fOffsetX);
			SendClientMessage(playerid, COLOUR_GREEN,"Modification is successful!");
			printf("OffX: %f", fOffsetX);
			printf("OffY: %f", fOffsetY);
			printf("OffZ: %f", fOffsetZ);
	}
	else
	{
	    SendClientMessage(playerid, COLOUR_RED,"Object Discarded!");
	    RemovePlayerAttachedObject(playerid, index);
	    format(string, sizeof(string),"AttachObj%d", index);
	    SetPVarInt(playerid, string, 0);
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
//--------------------------------Bombing Scripts-----------------------------------//
	if ((newkeys & KEY_ACTION) && !(oldkeys & KEY_ACTION))
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 519)
 		{
 		    new i = vehicleid;
			new Float:X[9], Float:Y[9], Float:Z[9], Float:Z2[9], Float:Z3[9], Float:RotZ[9];
 	    	if(OutOfBombs[vehicleid] < gettime())
 	    	{
	            	GetVehiclePos(vehicleid, X[i], Y[i], Z[i]);
	            	GetPlayerFacingAngle(playerid, RotZ[i]);
	            	Bomb1[vehicleid] = CreateObject(3786, X[i]+3.31,Y[i]-0.1,Z[i]-2, 0,0,0,RotZ[i]);
	            	Bomb2[vehicleid] = CreateObject(3786, X[i]-3.31, Y[i]-0.1, Z[i]-2, 0,0,0,RotZ[i]);
	            	SetTimerEx("Explosion", 7500, false, "i", playerid);
	            	MapAndreas_FindZ_For2DCoord(X[i]+3.31, Y[i]-0.1, Z2[i]);
	            	MapAndreas_FindZ_For2DCoord(X[i]-3.31, Y[i]-0.1, Z3[i]);
	            	MoveObject(Bomb1[vehicleid], X[i]+3.31, Y[i]-0.1, Z2[i], 20, 0,0,RotZ[i]);
	            	MoveObject(Bomb2[vehicleid], X[i]-3.31, Y[i]-0.1, Z3[i], 20, 0,0,RotZ[i]);
	            	OutOfBombs[vehicleid] = (gettime()+10);
	            	return 1;
			}
			else
			{
		    	if ((newkeys & KEY_ACTION) && !(oldkeys & KEY_ACTION))
		    	{
		    		SendClientMessage(playerid, 0xD70000FF, "Bombs are still being reloaded");
		    		return 0;
		    	}
			}
		}
	}
//--------------------------------------END of Bombing Scripts------------------------//
//----------------------------------MSAM Script(Part1)---------------------------------------//
    if ((newkeys & KEY_ACTION) && !(oldkeys & KEY_ACTION))
    {
		if(IsPlayerInVehicle(playerid, USMSAM) || IsPlayerInVehicle(playerid, EUMSAM) || IsPlayerInVehicle(playerid, INMSAM) || IsPlayerInVehicle(playerid, RUMSAM))
 		{
 	    	for(new targetid = 0; targetid < MAX_PLAYERS; targetid++)
 	    	{
 	    	    if(targetid != playerid && gTeam[playerid] != gTeam[targetid])
 	    	    {
 	    	        new vehicleid = GetPlayerVehicleID(playerid);
 	    			new tvehicleid = GetPlayerVehicleID(targetid);
  					new Float:X[13], Float:Y[13], Float:Z[13];
  					GetVehiclePos(vehicleid, X[vehicleid], Y[vehicleid], Z[vehicleid]);
					if(IsPlayerInRangeOfPoint(targetid, 165, X[vehicleid], Y[vehicleid], Z[vehicleid]))
					{
						if(GetVehicleModel(tvehicleid) == 425 || GetVehicleModel(tvehicleid) == 447 || GetVehicleModel(tvehicleid) == 487 || GetVehicleModel(tvehicleid) == 519 || GetVehicleModel(tvehicleid) == 520)
						{
						    if(MSAMfired[playerid] == false)
						    {
   		   						GetPlayerPos(targetid, USMX[vehicleid], USMY[vehicleid], USMZ[vehicleid]);
	           					SAMMissile[vehicleid] = CreateObject(345, X[vehicleid], Y[vehicleid] - 0.1, Z[vehicleid] + 6, 0,0,0,0);
   								MoveObject(SAMMissile[vehicleid], USMX[vehicleid], USMY[vehicleid], USMZ[vehicleid], 250, 0,0,0);
   								MSAMfired[playerid] = true;
   								SetTimerEx("SAMMissileExplode", 400, 0, "ii", playerid, tvehicleid);
							}
							else
							{
							    SendClientMessage(playerid, 0x868686FF, "You cannot fire more than one missile at a time!");
							}
						}
					}
				}
			}
		}
	}
//--------------------------------------END of MSAM Script(Part1)----------------------------//
	else if((newkeys & KEY_LOOK_BEHIND) && !(oldkeys & KEY_LOOK_BEHIND))
	{
	    if(Pclass[playerid] == VIP_CLASS)//REPALCE WITH: Pclass[playerid] == VIP_CLASS
	    {
	        if(GetPlayerWeapon(playerid) == 31)
	        {
	            if(!IsValidObject(M320g[playerid]))
	            {
	                if(GetPVarInt(playerid, "M320gammo") > 0)
	                {
	                	SetPVarInt(playerid,"M320gammo", GetPVarInt(playerid, "M320gammo")-1);
	            		new Float:fvX, Float:fvY, Float:fvZ, Float:Cx, Float:Cy, Float:Cz;
	            		GetPlayerCameraPos(playerid, Cx, Cy, Cz);
	            		GetPlayerCameraFrontVector(playerid, fvX, fvY, fvZ);
						new Float:Objx = Cx + floatmul(fvX, 4.0);
						new Float:Objy = Cy + floatmul(fvY, 4.0);
						new Float:Objz = Cz + floatmul(fvZ, 4.0) -0.1;
			 			M320g[playerid] = CreateObject(342, Objx, Objy, Objz, 0, 0, 0);
			 			//new Float:calc = floatsqroot(floatmul(Objx, Objx)+floatmul(Objy, Objy)); DONT UNCOMMENT THIS!
			 			if(fvZ < 0) fvZ = fvZ-(fvZ*2.0);
			 			new Float:calc = 25.0-(25.0*fvZ);
						Objx = Cx + floatmul(fvX, calc);
						Objy = Cy + floatmul(fvY, calc);
						MapAndreas_FindZ_For2DCoord(Objx, Objy, Objz);
						MoveObject(M320g[playerid], Objx, Objy, Objz, calc*3.0, 0 ,0 ,0);
						SetTimerEx("M320gexplosion", 333, 0 ,"i", playerid);
					}
					else
					{
					    SendClientMessage(playerid, COLOUR_GREY, "You are out of M320 grenades!");
	 				}
				}
	        }
	    }
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
		Weapon{playerid} = GetPlayerWeapon(playerid);
    	new magammo = (GetPlayerAmmo(playerid)+magdifference[playerid][GetWeaponSlot(Weapon{playerid})]-1) % GetWeaponMag(Weapon{playerid});
		new string[10];
		//if(Spawned[playerid] < gettime())
		//{
		//	}
	 	if(Pclass[playerid] == VIP_CLASS)
   		{
			if(GetPVarInt(playerid, "DeagleUse") == 1 && Weapon{playerid} != 24)
			{
			    SetPVarInt(playerid, "DeagleUse", 0);
			    RemovePlayerAttachedObject(playerid, 2);
			}
			else if(GetPVarInt(playerid, "DeagleUse") == 0 && Weapon{playerid} == 24)
			{
   				SetPVarInt(playerid, "DeagleUse", 1);
			    SetPlayerAttachedObject(playerid, 2, 348, 6, -0.006, -0.003, -0.01, 0, 0, 0, 1.024, 1.125, 1.1, 0xFFCAAC00);
			}
		}
		if(magammo == 0)
		{
    		format(string, sizeof(string),"~h~%02d", GetWeaponMag(Weapon{playerid}));
			PlayerTextDrawSetString(playerid, Magdraw[playerid],string);
			format(string,sizeof(string),"~h~/ %03d", GetPlayerAmmo(playerid)-GetWeaponMag(Weapon{playerid}));
			PlayerTextDrawSetString(playerid, Ammodraw[playerid], string);
			PlayerTextDrawSetString(playerid, Wstate[playerid], GetWeaponNameEx(Weapon{playerid}));
		}
		else
		{
	   	 	if(Weapon{playerid} != GetPVarInt(playerid, "iWeapon"))
			{
				magdifference[playerid][GetWeaponSlot(Weapon{playerid})] += GetWeaponMag(Weapon{playerid}) - magammo;
				PlayerTextDrawSetString(playerid, Wstate[playerid], GetWeaponNameEx(Weapon{playerid}));
				SetPVarInt(playerid,"iWeapon", Weapon{playerid});
				format(string, sizeof(string),"~h~/ %03d", GetPlayerAmmo(playerid)-GetWeaponMag(Weapon{playerid}));
				PlayerTextDrawSetString(playerid, Ammodraw[playerid], string);
			}
  			format(string,sizeof(string),"~h~%02d", magammo);
			PlayerTextDrawSetString(playerid, Magdraw[playerid], string);
		}
	}
//	}
//	else
//	{
//	    SetPVarInt(playerid,"iWeapon", GetPlayerWeapon(playerid));
//		magdifference{playerid} = 0;
//		format(string,sizeof(string),"~h~%02d", magammo);
//		PlayerTextDrawSetString(playerid, Magdraw[playerid], string);
//	}
//-------------------------------------Auto Gates--------------------------------------------//
	if(IsPlayerInRangeOfPoint(playerid, 20,96.4000015,2059.9599609,16.7999992))
	{
	    if(gTeam[playerid] == TEAM_US)
	        {
	            MoveObject(USmovinggate1,96.4000015,2050.9599609,16.7999992, 7,0,0,90);
	            SetTimer("closeUSgate1", 4000, 0);
	            return 1;
			}
	}
	if(IsPlayerInRangeOfPoint(playerid, 20,96.3994141,2073.4599609,16.7999992))
	{
	    if(gTeam[playerid] == TEAM_US)
	        {
	            MoveObject(USmovinggate2,96.3994141,2082.4599609,16.7999992, 7,0,0,90);
	            SetTimer("closeUSgate2", 4000, 0);
	            return 1;
			}
	}
	if(IsPlayerInRangeOfPoint(playerid,20, -1608.3994141,1743.7998047,10.3000002))
	{
	    if(gTeam[playerid] == TEAM_EU)
	    {
	    MoveObject(EUmovinggate, -1613.9,1743.7998047,10.3000002, 7,0.0000000,0.0000000,119.9981689);
	    SetTimer("closeEUgate", 4000, 0);
	    return 1;
	    }
	}
	if(IsPlayerInRangeOfPoint(playerid, 20,  -380.6000061,2694.1999512,63.9000053) && gTeam[playerid] == TEAM_IN)
	{
	    MoveObject(INmovinggate1, -385.79998779297,2691.3000488281,64.199996948242, 7, 0,0, 209.9981689);
	    SetTimer("closeINgate1", 4000, 0);
	    return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 20, -143.5000000,2633.3000488,63.7599983) && gTeam[playerid] == TEAM_IN)
	{
	    MoveObject(INmovinggate2, -143.62, 2639.2998046875, 63.759998321533, 7, 0,0,90);
	    SetTimer("closeINgate2", 4000,0);
	    return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 20, 765.9000200,2288.8999000,11.1000000) && gTeam[playerid] == TEAM_RU)
	{
	    MoveObject(RUmovinggate, 761.09997558594, 2285.6201171875, 11.10000038147, 7,0,0,139.99877929688);
	    SetTimer("closeRUgate", 4000,0);
	    return 1;
	}
//---------------------------------------End of Auto Gates------------------------------------//
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	/*if(GetVehicleModel(vehicleid) == 432)
	{
		new variable = 1 << (vehicleid - 17);
		if(TanksOccupied & variable) return 1;
		else
		{
		    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
		    SetVehicleAngularVelocity(vehicleid, 0.0,0.0,0.0);
		}
	}*/
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
  switch(dialogid)
  {
	case 2:
	{
	    	if(response)
	    	{
	            new pwlength = strlen(inputtext);
	            if(pwlength > 4 && pwlength < 30)
	            {
	                new buff[140], query[300], Ip[16];
                	for(new i = 0; i < pwlength; i++)
					{
	   					 inputtext[i] = inputtext[i] + 10;
					}
					WP_Hash(buff, 140, inputtext);
					new ran[4];
					for(new i = 0; i < 3; i++)
					{
					    ran[i] = random(25) +65;
					}
					strins(buff, ran, 0, 3);
					for(new i = 0;i < 3; i++)
					{
					    ran[i] = random(25) +65;
					}
					strins(buff, ran, 34, 3);
					GetPlayerName(playerid, query, sizeof(query));
					GetPlayerIp(playerid, Ip, sizeof(Ip));
	                mysql_format(mysqldb, query, sizeof(query), "INSERT INTO SRVRPlayers (Username,Password,IP) Values('%e','%e','%e')", query, buff, Ip);
	                mysql_tquery(mysqldb, query, "OnAccountRegister", "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, 0xD70000FF, "Password is too short or too long!");
				    ShowPlayerDialog(playerid, 2, DIALOG_STYLE_PASSWORD,"Register", "You are not registered, please enter your password below to register.","Register","Cancel");
				}
			}
			else
			{
			    Kick(playerid);
			}
	}
	case 3:
	{
		    if(response)
		    {
		        if(inputtext[0] != 0)
		        {
					new query[83];
					mysql_format(mysqldb, query, sizeof(query), "SELECT * FROM SRVRPlayers WHERE `ID` = %d LIMIT 1", Playerinfo[playerid][dbID]);
					mysql_tquery(mysqldb, query, "OnPlayerAttemptLogin", "is", playerid, inputtext);
				}
				else
				{
				    ShowPlayerDialog(playerid, 3,DIALOG_STYLE_PASSWORD,"Login","Please enter your password to proceed","Login","Cancel");
				    SendClientMessage(playerid, 0xD70000FF, "Please enter your password!");
				}
			}
			else
			{
			    Kick(playerid);
			}
	}
	case 4:
	{
	    ShowPlayerDialog(playerid, 3,DIALOG_STYLE_PASSWORD,"Login","Please enter your password to proceed","Login","Cancel");
	}
	case 5:
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                SendClientMessage(playerid, 0xEACD00FF, "Ranks:");
	                SendClientMessage(playerid, 0xEACD00FF, "Private: < 50XP || Private 1st Class: < 150XP   || Corporal: < 350XP");
	                SendClientMessage(playerid, 0xEACD00FF, "Sergeant: < 700XP || Sergeant 1st Class: < 1400XP || Master Sergeant: < 2200XP");
	                SendClientMessage(playerid, 0xEACD00FF, "Sergeant Major: < 3400XP || Lieutenant: < 4800XP || Captain: < 6000XP");
	                SendClientMessage(playerid, 0xEACD00FF, "Major: < 7750XP || Colonel: < 10000XP || Brigadier General: < 13000XP");
	                SendClientMessage(playerid, 0xEACD00FF, "Major General: < 16000XP || Lieutenant General: < 20000XP || General: 20000XP+");
				}
				case 1:
				{
				    SendClientMessage(playerid, 0xEACD00FF, "Special Vehicles:");
				    SendClientMessage(playerid, 0xEACD00FF, "1. MRLs: Mobile Rocket Launchers, are vehicles (DFT-30) that have 2 rocket stations attached to them, each having 4 rockets.");
				    SendClientMessage(playerid, 0xEACD00FF, "   They can be used by going to pause > Map and marking a waypoint there as target,yet, MRLs have a range they can't exceed");
				    SendClientMessage(playerid, 0xEACD00FF, "   and a reload time of 20 seconds.");
				    SendClientMessage(playerid, 0xEACD00FF, "2. Thunderbolts: These are air-to-ground bombing aircrafts (Shamals) that are provided with 2 bombs per round loadout.");
				    SendClientMessage(playerid, 0xEACD00FF, "   The Thunderbolts can be used by pressing the LMB or Numpad 0 on the keyboard. Thunderbolts have a reload time of 10 seconds.");
				    SendClientMessage(playerid, 0xEACD00FF, "3. MSAMs: Mobile SAM sites are vehicles (DFT-30) that have a SAM site attached to them capable of firing 1 rocket per round");
				    SendClientMessage(playerid, 0xEACD00FF, "   against hostile aerial units. MSAMs can be used by pressing LMB or Numpad 0 on the keyboard(Range limited).");
				}
				case 2:
				{
				    new dstring[550];
				    strcat(dstring,"(Note: Bases[marked with a flag on minimap] are not Capturable) \nBase(ID) \t \t \t Time(sec) \t Players Required \nLil Probe Inn(4) \t \t \t 30  \t 1 \nBone County Station(5) \t \t 40 \t 2 \n", sizeof(dstring));
				    strcat(dstring,"Valle Occultado(6) \t \t \t 40 \t 2 \nGreen Palms Factory(7) \t \t 75 \t 5 \nElQuabrados(8) \t \t \t 75 \t 4 \nVerdant Meadows AA(9) \t \t 60 \t 5 \n", sizeof(dstring));
				    strcat(dstring,"Las Barrancas(10) \t \t \t 100 \t 3 \nGreen Glass Col.(11) \t \t \t 90 \t 4 \nThe Quarry(12) \t \t \t \t 90 \t 4 \nThe Big Ear(13) \t \t \t 120 \t 5 \nTorreno's House(14) \t \t \t 50 \t 1 \n", sizeof(dstring));
				    strcat(dstring,"Nuke Silo Station(15) \t \t \t 90 \t 5 \nLV Stadium(16) \t \t \t \t 90 \t 4", sizeof(dstring));
					ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "Capturable Zones", dstring, "Ok", "Cancel");
				}
				case 3:
				{
				    new dstring[250];
				    strcat(dstring,"There are two special zones, The Nuclear Silo Station and The Big Ear, the team that captures either gets a perk \n", sizeof(dstring));
				    strcat(dstring,"The Nuke Station will allow access to /nuke and the Big Ear to /radarjam . Only the leader(highest score) of the team can use them", sizeof(dstring));
					ShowPlayerDialog(playerid, 7, DIALOG_STYLE_MSGBOX, "Special Zones",dstring,"Ok","Cancel");
				}
				case 4:
				{
				    new dstring[440];
				    strcat(dstring," Rank \t \t \t Unlockable \n Private 1st Class \t Medic Class \n Corporal \t \t Support Class \n Sergeant \t \t Sniper Class \n Sergeant 1st Class \t CQ class \n", sizeof(dstring));
				    strcat(dstring," Master Sergeant \t Engineer Class \n Sergeant Major \t MRL \n Lieutenant \t \t Tanks \n Captain \t \t  Airforce (Thunderbolts & S. Sparrow) \n", sizeof(dstring));
				    strcat(dstring," Major \t \t \t Hunter \n Colonel \t \t Hydra \n Bgd. General \t \t MSAM \n Major General \t Drone Unit \n Lieut. General \t Personal Jamcoms \n General \t \t Red Alert Call", sizeof(dstring));
				    ShowPlayerDialog(playerid, 8, DIALOG_STYLE_MSGBOX, "Unlockables", dstring,"Ok","Cancel");
				}
				case 5:
				{
				    new dstring[500];
				    strcat(dstring,"There are many capture zones on the server, each with its own requirement of time to capture and players to capture. A capture can be initiated using /capture \n", sizeof(dstring));
				    strcat(dstring,"Only 1 person needs to do /capture and not all the players in the capture zone. If the amount of players in the capture zone is enough, the capture will begin. \n",sizeof(dstring));
				    strcat(dstring,"You will be enclosed in the capture zone while capturing. If the amount of capturing players drops under the requirement(due to death or disconnection),\n", sizeof(dstring));
				    strcat(dstring,"the capture will fail.", sizeof(dstring));
				    ShowPlayerDialog(playerid, 9, DIALOG_STYLE_MSGBOX, "Capture System", dstring,"Ok","Cancel");
				}
				case 6:
				{
				    ShowPlayerDialog(playerid, 10, DIALOG_STYLE_LIST, "Commands","Main Gameplay \nChat \nAdministration (Admins only) \nOther","Ok","Cancel");
				}
			}
		}
	}
	case 10:
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
				{
					 SendClientMessage(playerid, 0xEACD00FF,"Gameplay cmds(explanation): /heal /rammo (refill ammo) /nuke /radarjam /capture /kill /stats /cchange (change class) ");
					 SendClientMessage(playerid, 0xEACD00FF,"/pjam(Personal Jamcoms) /rac(Red-Alert-Call) /shop");
				}
	            case 1: SendClientMessage(playerid, 0xEACD00FF,"Chat cmds: /pm /r /tc (team chat) /togglepm");
	            case 2:
    			{
					 if(Playerinfo[playerid][Adminlevel] > 0)
					 {
					 	 SendClientMessage(playerid, 0xEACD00FF, "Admin cmds: /time /weather /kick /ban /freeze /unfreeze /spectate /stopspectate /mute /unmute /sal /gethere /ac (admin chat)");
					 	 SendClientMessage(playerid, 0xEACD00FF, "/goto /setscore /announce /clearchat /resetboundary");
					 }
					 else
					 {
					    SendClientMessage(playerid, COLOUR_RED,"Access Denied!");
					 }
				}
	            case 3: SendClientMessage(playerid, 0xEACD00FF,"Other cmds: /help /rules /ask /report /admins /scan /changepassword /changeusername /about");
			}
		}
	}
	case 12:
	{
	    if(response)
	    {
	        new string[50];
	        switch(listitem)
	        {
	            case 0:
	            {
	                if(Playerinfo[playerid][Tokens] < 10) return SendClientMessage(playerid, COLOUR_RED,"You don't have enough BattlePoints to buy this item");
	                SendClientMessage(playerid, 0xFFFFFFFF,"Here is your Armour Soldier! Now get back in the Battlefield!");
	                SetPlayerArmour(playerid, 100);
	                PlayerTextDrawSetString(playerid, Armrdraw[playerid],"-----------------~n~Armr. 100~n~-----------------");
	                Playerinfo[playerid][Tokens] -= 10;
               		format(string, sizeof(string),"Score: %d~n~BattlePoints: %d", Playerinfo[playerid][Score], Playerinfo[playerid][Tokens]);
					PlayerTextDrawSetString(playerid, Scoredraw[playerid], string);
				}
				case 1:
				{
				    if(Playerinfo[playerid][Tokens] < 7) return SendClientMessage(playerid, COLOUR_RED,"You don't have enough BattlePoints to buy this item");
				    SendClientMessage(playerid, COLOUR_GREEN,"You have been healed!");
				    PlayerTextDrawSetString(playerid, Hdraw[playerid], "----------~n~+ 100~n~----------");
				    SetPlayerHealth(playerid, 99);
				    Playerinfo[playerid][Tokens] -= 7;
				   	format(string, sizeof(string),"Score: %d~n~BattlePoints: %d", Playerinfo[playerid][Score], Playerinfo[playerid][Tokens]);
					PlayerTextDrawSetString(playerid, Scoredraw[playerid], string);
				}
				case 2:
				{
				    if(Playerinfo[playerid][RankID] < 13) return SendClientMessage(playerid, COLOUR_RED,"You are not authorised to purchase this item!");
				    if(Playerinfo[playerid][Tokens] < 25) return SendClientMessage(playerid, COLOUR_RED,"You do not have enough BattlePoints to buy this item");
				    SendClientMessage(playerid, COLOUR_GREEN,"Jamcom purchased! Use them with /pjam. It ends upon your death, use it wisely!");
					Jamcoms{playerid} += 1;
					Playerinfo[playerid][Tokens] -= 25;
					format(string, sizeof(string),"Score: %d~n~BattlePoints: %d", Playerinfo[playerid][Score], Playerinfo[playerid][Tokens]);
					PlayerTextDrawSetString(playerid, Scoredraw[playerid], string);
				}
				case 3:
				{
				    if(Playerinfo[playerid][RankID] < 14) return SendClientMessage(playerid, COLOUR_RED,"You are not authorised to purchase this item!");
				    if(Playerinfo[playerid][Tokens] < 50) return SendClientMessage(playerid, COLOUR_RED,"You do not have enough BattlePoints to buy this item");
				    SendClientMessage(playerid, COLOUR_GREEN,"Here is the golden item! Make the best use out of it!(Use it by /rac)");
				    RAC{playerid} += 1;
				    Playerinfo[playerid][Tokens] -= 50;
				    format(string, sizeof(string),"Score: %d~n~BattlePoints: %d", Playerinfo[playerid][Score], Playerinfo[playerid][Tokens]);
					PlayerTextDrawSetString(playerid, Scoredraw[playerid], string);
				}
			}
		}
	}
	case 14:
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 1: PlayAudioStreamForPlayer(playerid, "http://icy3.abacast.com/pulse87-pulse87mp3-64",0,0,0,0,0);
	            case 2: PlayAudioStreamForPlayer(playerid, "http://stream.friskyradio.com:8000/frisky_mp3_hi?icy=http",0,0,0,0,0);
	            case 3: PlayAudioStreamForPlayer(playerid, "http://148.251.91.15:7004/;?icy=http", 0,0,0,0,0);
	            case 4: PlayAudioStreamForPlayer(playerid, "http://89.105.32.8:8110/;?icy=http", 0,0,0,0,0);
	            case 5: PlayAudioStreamForPlayer(playerid, "http://205.164.35.70/;?icy=http", 0,0,0,0,0);
	            case 6: PlayAudioStreamForPlayer(playerid, "http://205.164.35.135/;?icy=http", 0,0,0,0,0);
	            case 7: PlayAudioStreamForPlayer(playerid, "http://streaming.radionomy.com/Radiospakcom?icy=http", 0,0,0,0,0);
	            case 9: PlayAudioStreamForPlayer(playerid, "http://k007.kiwi6.com/hotlink/34dmby9lzz/Best2013MC.mp3", 0,0,0,0,0);
	        }
	    }
	}
 	case 17:
  	{
    	if(response)
    	{
			switch(listitem)
			{
		    	case 0: DSP{playerid} = 0, gTeam[playerid] =0, SetPlayerHealth(playerid, 0), Playerinfo[playerid][Deaths] -= 1, SetPlayerVirtualWorld(playerid, 0);
		    	case 1: ShowPlayerDialog(playerid, 20, DIALOG_STYLE_INPUT,"Insert SkinID","Please insert the skin id below (a list of skinIDs with their previews is available on the forums)","Apply","Cancel");
		    	case 2:
		    	{
		       	 	new string[100];
		       	 	mysql_format(mysqldb, string, sizeof(string),"SELECT Refers FROM SRVRPlayers WHERE `ID` = %d", Playerinfo[playerid][dbID]);
		       	 	new Cache:result = mysql_query(mysqldb, string);
		        	format(string, sizeof(string),"Your VIP Details:\nVIP Rank: %s\nDonation Sum:N/A\nReferred Players:%d", GetVIPRank(GetPVarInt(playerid,"Viplevel")), cache_get_field_content_int(0, "Refers"));
		        	ShowPlayerDialog(playerid, 21, DIALOG_STYLE_MSGBOX,"VIP Details", string, "Ok","");
		        	cache_delete(result);
				}
			}
		}
  	}
  	case 16:
  	{
    	if(response)
		{
			 if(listitem == 0 || listitem == 1 || listitem == 2) return SendClientMessage(playerid, COLOUR_RED,"Slot is locked!(Used by server entities)");
			 SetPVarInt(playerid, "CAttachSlot", listitem), ShowPlayerDialog(playerid, 18, DIALOG_STYLE_LIST,"Choose Body-Part","Back\nHead\nLeft Upper Arm\nRight Upper Arm\nLeft Hand\nRight Hand\nLeft thigh\nRight Thigh\nLeft foot\nRight foot\nRight Calf\nLeft Calf\nLeft forearm\nRight forearm\nLeft Shoulder\nRight Shoulder\nNeck\nJaw","Select","Cancel");
		}
  	}
  	case 18:
  	{
    	if(response) SetPVarInt(playerid, "CAttachBone", listitem+1), ShowPlayerDialog(playerid, 19,DIALOG_STYLE_INPUT,"Insert ObjectID","Please insert the ObjectID you wish to attach below(a list of ObjectIDs and their previews is available on forums)","Attach","Cancel");
  	}
  	case 19:
  	{
   		 if(response)
		 {
			SetPlayerAttachedObject(playerid, GetPVarInt(playerid, "CAttachSlot"), strval(inputtext), GetPVarInt(playerid, "CAttachBone"), 0, 0, 0, 1,1,1, 0);
			EditAttachedObject(playerid, GetPVarInt(playerid, "CAttachSlot"));
			SendClientMessage(playerid, COLOUR_GREEN,"Object has been attached successfully! You can edit its position now and save it");
		}
  	}
  	case 20:
  	{
    	if(response)
		{
			new skinid = strval(inputtext);
			if(0 <= skinid < 300) SetPlayerSkin(playerid, skinid), SetPVarInt(playerid, "VIPskin", skinid);
			else SendClientMessage(playerid, COLOUR_RED,"Invalid SkinID!");
		}
  	}
  	case 22:
  	{
  	    if(listitem == 0 || listitem == 1 || listitem == 2) return SendClientMessage(playerid, COLOUR_RED,"Slot is locked!(Used by server entities)");
  	    if(!IsPlayerAttachedObjectSlotUsed(playerid, listitem)) return SendClientMessage(playerid, COLOUR_RED,"Slot is free!");
  	    EditAttachedObject(playerid, listitem);
  	    SendClientMessage(playerid, COLOUR_GREEN,"Press 'ESCAPE' to remove object, or use the UI to edit it");
  	}
  }
  return 0;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	//Team Empty Slot Check will be done on Player Press DEPLOY
	if(_:clickedid != INVALID_TEXT_DRAW)
	{
		    if(clickedid == Teambutton[0])
			{
		 			SetPlayerCameraPos(playerid, 285.5769,1840.7185,65.6286);
	 				SetPlayerCameraLookAt(playerid,210.5712,1913.9818,17.6406);
	 				SetPlayerPos(playerid, 210.5712,1913.9818,16.6406);
	 				TextDrawBoxColor(Teambutton[gTeam[playerid]], 0x15151555);
	 				TextDrawColor(Teambutton[gTeam[playerid]], 0xFFFFFFFF);
	 				TextDrawSetOutline(Teambutton[gTeam[playerid]], 1);
	 				TextDrawShowForPlayer(playerid, Teambutton[gTeam[playerid]]);
	 				gTeam[playerid] = TEAM_US;
 					TextDrawBoxColor(clickedid, 0xFFFFFFBB);
	 				TextDrawColor(clickedid, 0x000000FF);
	 				TextDrawSetOutline(clickedid, 0);
	 				TextDrawShowForPlayer(playerid, clickedid);
			}
   			else if(clickedid == Teambutton[1])
			{
		 			SetPlayerCameraPos(playerid, -1451.5300,1574.1058,87.8148);
		 			SetPlayerCameraLookAt(playerid, -1336.3359,1618.4006,8.7259);
		 			SetPlayerPos(playerid, -1336.3359,1618.4006,7.7259);
	 				TextDrawBoxColor(Teambutton[gTeam[playerid]], 0x15151555);
	 				TextDrawColor(Teambutton[gTeam[playerid]], 0xFFFFFFFF);
	 				TextDrawSetOutline(Teambutton[gTeam[playerid]], 1);
	 				TextDrawShowForPlayer(playerid, Teambutton[gTeam[playerid]]);
	 				gTeam[playerid] = TEAM_EU;
 					TextDrawBoxColor(clickedid, 0xFFFFFFBB);
	 				TextDrawColor(clickedid, 0x000000FF);
	 				TextDrawSetOutline(clickedid, 0);
	 				TextDrawShowForPlayer(playerid, clickedid);
			}
			else if(clickedid == Teambutton[2])
			{
				SetPlayerCameraPos(playerid, -265.9770,2746.3123,128.9751);
			 	SetPlayerCameraLookAt(playerid, -242.1593,2653.9507,62.6666);
			  	SetPlayerPos(playerid, -242.1593,2653.9507,61.6666);
	 			TextDrawBoxColor(Teambutton[gTeam[playerid]], 0x15151555);
	 			TextDrawColor(Teambutton[gTeam[playerid]], 0xFFFFFFFF);
	 			TextDrawSetOutline(Teambutton[gTeam[playerid]], 1);
	 			TextDrawShowForPlayer(playerid, Teambutton[gTeam[playerid]]);
	 			gTeam[playerid] = TEAM_IN;
 				TextDrawBoxColor(clickedid, 0xFFFFFFBB);
	 			TextDrawColor(clickedid, 0x000000FF);
	 			TextDrawSetOutline(clickedid, 0);
	 			TextDrawShowForPlayer(playerid, clickedid);
			}
			else if(clickedid == Teambutton[3])
			{
				SetPlayerCameraPos(playerid, 946.0139,2076.9597,81.6750);
			 	SetPlayerCameraLookAt(playerid, 854.7843,2156.9734,10.9000);
			  	SetPlayerPos(playerid, 854.7843,2156.9734,10.9000);
	 			TextDrawBoxColor(Teambutton[gTeam[playerid]], 0x15151555);
	 			TextDrawColor(Teambutton[gTeam[playerid]], 0xFFFFFFFF);
	 			TextDrawSetOutline(Teambutton[gTeam[playerid]], 1);
	 			TextDrawShowForPlayer(playerid, Teambutton[gTeam[playerid]]);
	 			gTeam[playerid] = TEAM_RU;
 				TextDrawBoxColor(clickedid, 0xFFFFFFBB);
	 			TextDrawColor(clickedid, 0x000000FF);
	 			TextDrawSetOutline(clickedid, 0);
	 			TextDrawShowForPlayer(playerid, clickedid);
			}
			else if(clickedid == Classicon[ASSAULT_CLASS])
			{
	 			TextDrawBoxColor(Classicon[Pclass[playerid]], 0x15151555);
	 			TextDrawColor(Classicon[Pclass[playerid]], 0xFFFFFFFF);
	 			TextDrawSetOutline(Classicon[Pclass[playerid]], 1);
	 			TextDrawColor(SnipeIcon, 0xFFFFFFFF);
 				TextDrawSetOutline(SnipeIcon, 1);
	 			TextDrawShowForPlayer(playerid, Classicon[Pclass[playerid]]);
	 			TextDrawShowForPlayer(playerid, SnipeIcon);
	 			Pclass[playerid] = ASSAULT_CLASS;
 				TextDrawBoxColor(clickedid, 0xFFFFFFBB);
	 			TextDrawColor(clickedid, 0x000000FF);
	 			TextDrawSetOutline(clickedid, 0);
	 			TextDrawShowForPlayer(playerid, clickedid);
	 			PlayerTextDrawSetString(playerid,Spawnclass[playerid],"ASSAULT");
 				PlayerTextDrawSetString(playerid, ClassStats[playerid],"   M4A1      D-EAGLE      MP5      No Perk~n~ ~n~");
	 			PlayerTextDrawSetString(playerid, SpawnNotice[playerid],"~n~");
			}
			else if(clickedid == Classicon[MEDIC_CLASS])
			{
			    if(Playerinfo[playerid][RankID] < 1) PlayerTextDrawSetString(playerid,SpawnNotice[playerid],"LOCKED CLASS!");
				else
				{
	 				TextDrawBoxColor(Classicon[Pclass[playerid]], 0x15151555);
	 				TextDrawColor(Classicon[Pclass[playerid]], 0xFFFFFFFF);
	 				TextDrawSetOutline(Classicon[Pclass[playerid]], 1);
	 				TextDrawColor(SnipeIcon, 0xFFFFFFFF);
 					TextDrawSetOutline(SnipeIcon, 1);
	 				TextDrawShowForPlayer(playerid, Classicon[Pclass[playerid]]);
	 				TextDrawShowForPlayer(playerid, SnipeIcon);
	 				Pclass[playerid] = MEDIC_CLASS;
 					TextDrawBoxColor(clickedid, 0xFFFFFFBB);
	 				TextDrawColor(clickedid, 0x000000FF);
	 				TextDrawSetOutline(clickedid, 0);
	 				TextDrawShowForPlayer(playerid, clickedid);
	 				PlayerTextDrawSetString(playerid,Spawnclass[playerid],"MEDIC");
	 				PlayerTextDrawSetString(playerid, ClassStats[playerid],"   M4A1      D-EAGLE      N/A      Heal Perk~n~ ~n~");
	 				PlayerTextDrawSetString(playerid, SpawnNotice[playerid],"~n~");
				}
			}
			else if(clickedid == Classicon[SUPPORT_CLASS])
			{
			    if(Playerinfo[playerid][RankID] < 2) PlayerTextDrawSetString(playerid,SpawnNotice[playerid],"LOCKED CLASS!");
				else
				{
	 				TextDrawBoxColor(Classicon[Pclass[playerid]], 0x15151555);
	 				TextDrawColor(Classicon[Pclass[playerid]], 0xFFFFFFFF);
	 				TextDrawSetOutline(Classicon[Pclass[playerid]], 1);
	 				TextDrawColor(SnipeIcon, 0xFFFFFFFF);
 					TextDrawSetOutline(SnipeIcon, 1);
	 				TextDrawShowForPlayer(playerid, Classicon[Pclass[playerid]]);
	 				TextDrawShowForPlayer(playerid, SnipeIcon);
	 				Pclass[playerid] = SUPPORT_CLASS;
 					TextDrawBoxColor(clickedid, 0xFFFFFFBB);
	 				TextDrawColor(clickedid, 0x000000FF);
	 				TextDrawSetOutline(clickedid, 0);
	 				TextDrawShowForPlayer(playerid, clickedid);
	 				PlayerTextDrawSetString(playerid,Spawnclass[playerid],"SUPPORT");
	 				PlayerTextDrawSetString(playerid, ClassStats[playerid],"   M4A1      N/A      MP5      AMMO RESUPPLY~n~ ~n~");
	 				PlayerTextDrawSetString(playerid, SpawnNotice[playerid],"~n~");
				}
			}
			else if(clickedid == Classicon[SNIPER_CLASS] || clickedid == SnipeIcon)
			{
			    if(Playerinfo[playerid][RankID] < 3) PlayerTextDrawSetString(playerid,SpawnNotice[playerid],"LOCKED CLASS!");
				else
				{
	 				TextDrawBoxColor(Classicon[Pclass[playerid]], 0x15151555);
	 				TextDrawColor(Classicon[Pclass[playerid]], 0xFFFFFFFF);
	 				TextDrawSetOutline(Classicon[Pclass[playerid]], 1);
	 				TextDrawShowForPlayer(playerid, Classicon[Pclass[playerid]]);
	 				Pclass[playerid] = SNIPER_CLASS;
 					TextDrawBoxColor(Classicon[SNIPER_CLASS], 0xFFFFFFBB);
	 				TextDrawColor(Classicon[SNIPER_CLASS], 0x000000FF);
	 				TextDrawColor(SnipeIcon, 0x000000FF);
	 				TextDrawSetOutline(SnipeIcon, 0);
	 				TextDrawSetOutline(Classicon[SNIPER_CLASS], 0);
	 				TextDrawShowForPlayer(playerid, Classicon[SNIPER_CLASS]);
	 				TextDrawShowForPlayer(playerid, SnipeIcon);
	 				PlayerTextDrawSetString(playerid,Spawnclass[playerid],"SNIPER");
	 				PlayerTextDrawSetString(playerid, ClassStats[playerid],"   Sniper      D-EAGLE      N/A      Radar Stealth~n~ ~n~");
	 				PlayerTextDrawSetString(playerid, SpawnNotice[playerid],"~n~");
				}
			}
			else if(clickedid == Classicon[CQ_CLASS])
			{
			    if(Playerinfo[playerid][RankID] < 4) PlayerTextDrawSetString(playerid,SpawnNotice[playerid],"LOCKED CLASS!");
				else
				{
	 				TextDrawBoxColor(Classicon[Pclass[playerid]], 0x15151555);
	 				TextDrawColor(Classicon[Pclass[playerid]], 0xFFFFFFFF);
	 				TextDrawSetOutline(Classicon[Pclass[playerid]], 1);
	 				TextDrawColor(SnipeIcon, 0xFFFFFFFF);
 					TextDrawSetOutline(SnipeIcon, 1);
	 				TextDrawShowForPlayer(playerid, Classicon[Pclass[playerid]]);
	 				TextDrawShowForPlayer(playerid, SnipeIcon);
	 				Pclass[playerid] = CQ_CLASS;
 					TextDrawBoxColor(clickedid, 0xFFFFFFBB);
	 				TextDrawColor(clickedid, 0x000000FF);
	 				TextDrawSetOutline(clickedid, 0);
	 				TextDrawShowForPlayer(playerid, clickedid);
	 				PlayerTextDrawSetString(playerid,Spawnclass[playerid],"CLOSE QUARTERS");
	 				PlayerTextDrawSetString(playerid, ClassStats[playerid],"   SPAS-12      D-EAGLE      N/A      No Perk~n~ ~n~");
	 				PlayerTextDrawSetString(playerid, SpawnNotice[playerid],"~n~");
				}
			}
			else if(clickedid == Classicon[ENGINEER_CLASS])
			{
			    if(Playerinfo[playerid][RankID] < 5) PlayerTextDrawSetString(playerid,SpawnNotice[playerid],"LOCKED CLASS!");
				else
				{
	 				TextDrawBoxColor(Classicon[Pclass[playerid]], 0x15151555);
	 				TextDrawColor(Classicon[Pclass[playerid]], 0xFFFFFFFF);
	 				TextDrawSetOutline(Classicon[Pclass[playerid]], 1);
	 				TextDrawColor(SnipeIcon, 0xFFFFFFFF);
 					TextDrawSetOutline(SnipeIcon, 1);
	 				TextDrawShowForPlayer(playerid, Classicon[Pclass[playerid]]);
	 				TextDrawShowForPlayer(playerid, SnipeIcon);
	 				Pclass[playerid] = ENGINEER_CLASS;
 					TextDrawBoxColor(clickedid, 0xFFFFFFBB);
	 				TextDrawColor(clickedid, 0x000000FF);
	 				TextDrawSetOutline(clickedid, 0);
	 				TextDrawShowForPlayer(playerid, clickedid);
	 				PlayerTextDrawSetString(playerid,Spawnclass[playerid],"ENGINEER");
	 				PlayerTextDrawSetString(playerid, ClassStats[playerid],"   M4A1      D-EAGLE      HRPG      No Perk~n~ ~n~");
	 				PlayerTextDrawSetString(playerid, SpawnNotice[playerid],"~n~");
				}
			}
			else if(clickedid == Classicon[AIRFORCE_CLASS])
			{
			    if(Playerinfo[playerid][RankID] < 8) PlayerTextDrawSetString(playerid,SpawnNotice[playerid],"LOCKED CLASS!");
				else
				{
	 				TextDrawBoxColor(Classicon[Pclass[playerid]], 0x15151555);
	 				TextDrawColor(Classicon[Pclass[playerid]], 0xFFFFFFFF);
	 				TextDrawSetOutline(Classicon[Pclass[playerid]], 1);
	 				TextDrawColor(SnipeIcon, 0xFFFFFFFF);
 					TextDrawSetOutline(SnipeIcon, 1);
	 				TextDrawShowForPlayer(playerid, Classicon[Pclass[playerid]]);
	 				TextDrawShowForPlayer(playerid, SnipeIcon);
	 				Pclass[playerid] = AIRFORCE_CLASS;
 					TextDrawBoxColor(clickedid, 0xFFFFFFBB);
	 				TextDrawColor(clickedid, 0x000000FF);
	 				TextDrawSetOutline(clickedid, 0);
	 				TextDrawShowForPlayer(playerid, clickedid);
	 				PlayerTextDrawSetString(playerid,Spawnclass[playerid],"AIRFORCE");
	 				PlayerTextDrawSetString(playerid, ClassStats[playerid],"   N/A      D-EAGLE      PARA      Aircrafts~n~ ~n~");
	 				PlayerTextDrawSetString(playerid, SpawnNotice[playerid],"~n~");
				}
			}
			else if(clickedid == Classicon[VIP_CLASS])
			{
	 			TextDrawBoxColor(Classicon[Pclass[playerid]], 0x15151555);
	 			TextDrawColor(Classicon[Pclass[playerid]], 0xFFFFFFFF);
	 			TextDrawSetOutline(Classicon[Pclass[playerid]], 1);
	 			TextDrawColor(SnipeIcon, 0xFFFFFFFF);
 				TextDrawSetOutline(SnipeIcon, 1);
	 			TextDrawShowForPlayer(playerid, Classicon[Pclass[playerid]]);
	 			TextDrawShowForPlayer(playerid, SnipeIcon);
	 			Pclass[playerid] = VIP_CLASS;
 				TextDrawBoxColor(clickedid, 0xFFFFFFBB);
	 			TextDrawColor(clickedid, 0x000000FF);
	 			TextDrawSetOutline(clickedid, 0);
	 			TextDrawShowForPlayer(playerid, clickedid);
	 			PlayerTextDrawSetString(playerid,Spawnclass[playerid],"VIP UNIT");
 				PlayerTextDrawSetString(playerid, ClassStats[playerid],"   M4A1+M320G.L    GLDN-D-EAGLE    MP5    TBs~n~ ~n~");
	 			PlayerTextDrawSetString(playerid, SpawnNotice[playerid],"~n~");
			}
			else if(clickedid == DeployButton)
			{
			    	new Team = gTeam[playerid];
			    	for(new i= 0; i < MAX_TEAM_PLAYERS; i++)
					{
	   					 if(Tplayers[Team][i] == INVALID_PLAYER_ID)
					     {
		 					Tplayers[Team][i] = playerid;
	    					break;
						 }
						 if(i == (MAX_TEAM_PLAYERS-1)) return PlayerTextDrawSetString(playerid, SpawnNotice[playerid],"TEAM IS FULL!");
					}
					TeamTime[playerid] = gettime();
					ClassTime[playerid] = gettime();
					StopAudioStreamForPlayer(playerid);
					TextDrawHideForPlayer(playerid, Teamdraw);
    				TextDrawHideForPlayer(playerid, Teambutton[0]);
    				TextDrawHideForPlayer(playerid, Teambutton[1]);
   				 	TextDrawHideForPlayer(playerid, Teambutton[2]);
    				TextDrawHideForPlayer(playerid, Teambutton[3]);
			  		TextDrawHideForPlayer(playerid, Deploydrawbg);
				  	TextDrawHideForPlayer(playerid, Deploydraw);
  					TextDrawHideForPlayer(playerid, Basebox);
  					TextDrawHideForPlayer(playerid, BaseDepdrawbg);
    				TextDrawHideForPlayer(playerid, BaseDepdraw);
    				TextDrawHideForPlayer(playerid, DeployAsdraw);
    				TextDrawHideForPlayer(playerid, Classicon[0]);
    				TextDrawHideForPlayer(playerid, Classicon[1]);
    				TextDrawHideForPlayer(playerid, Classicon[4]);
    				TextDrawHideForPlayer(playerid, SnipeIcon);
    				TextDrawHideForPlayer(playerid, Classicon[2]);
    				TextDrawHideForPlayer(playerid, Classicon[6]);
    				TextDrawHideForPlayer(playerid, Classicon[3]);
    				TextDrawHideForPlayer(playerid, Classicon[5]);
    				TextDrawHideForPlayer(playerid, Classicon[7]);
    				TextDrawHideForPlayer(playerid, DeployButton);
    				PlayerTextDrawHide(playerid, Spawnclass[playerid]);
    				PlayerTextDrawHide(playerid, SpawnNotice[playerid]);
					TextDrawHideForPlayer(playerid, Spawnbg);
					TextDrawHideForPlayer(playerid, ClassStatsbg);
					PlayerTextDrawHide(playerid, ClassStats[playerid]);
					SetSpawnInfo(playerid, Team, Teaminfo[Team][Skin],Teaminfo[Team][TX],Teaminfo[Team][TY],Teaminfo[Team][TZ],Teaminfo[Team][TAngle],0,0,0,0,0,0);
					TogglePlayerSpectating(playerid, 0);
					CancelSelectTextDraw(playerid);
					SendClientMessage(playerid, COLOUR_GREEN,"Welcome to the Battlefield! Press 'F4' if you want to be promoted to the Spawn Selection Window upon your next death.");
			}
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:MapX, Float:MapY, Float:MapZ)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInVehicle(playerid, USMRL) || IsPlayerInVehicle(playerid, EUMRL) || IsPlayerInVehicle(playerid, INMRL) || IsPlayerInVehicle(playerid, RUMRL))
	{
	    if(RocketsReload[vehicleid] < gettime())
	    {
	    	new Float:X, Float:Y, Float:Z;
			GetVehiclePos(vehicleid, X, Y, Z);
			new Float:Angle=-(90+(atan2(MapY-Y,MapX-X)));
			if(IsPlayerInRangeOfPoint(playerid, 210, MapX, MapY, Z))
			{
  				for(new i= 0; i < 5; i++)
    			{
	    			gMapX[vehicleid][i] = MapX + MRLrocketD[i][0];
					gMapY[vehicleid][i] = MapY + MRLrocketD[i][1];
     				MRLrocket[vehicleid][i] = CreateObject(3790,X + MRLrocketD[i][0],Y + MRLrocketD[i][1],Z + MRLrocketD[i][2], Angle,MRLrocketD[i][4], MRLrocketD[i][5]);
       				MoveObject(MRLrocket[vehicleid][i], gMapX[vehicleid][i] , gMapY[vehicleid][i] , 75, 120, Angle, 60, -90);
       				SetTimerEx("MRLredirect", 2000, 0, "ii", playerid, vehicleid);
				}
				SendClientMessage(playerid, 0x00A615FF, "Target designated! Rockets enroute to registered Co-ordinates");
				RocketsReload[vehicleid] = gettime() + 20;
				MRLParticle[vehicleid] = CreateObject(18682, X, Y, Z+1, 0, 0, 0);
				CreateExplosion(X, Y, Z-6, 1, 7);
			}
			else
			{
			    SendClientMessage(playerid, 0x868686FF, "Target out of range");
			}
		}
		else
		{
		    SendClientMessage(playerid, 0x868686FF, "Rockets are still being reloaded");
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    new Float:KDratio = floatdiv(Playerinfo[clickedplayerid][Kills], Playerinfo[clickedplayerid][Deaths]);
	new string[124];
	format(string, sizeof(string),"Kills: %d\nDeaths: %d\nK/D ratio: %.3f\nScore: %d\nRank: %s\nCaptures: %d",Playerinfo[clickedplayerid][Kills], Playerinfo[clickedplayerid][Deaths], KDratio, Playerinfo[clickedplayerid][Score], GetRankNameFromID(Playerinfo[clickedplayerid][RankID]), Playerinfo[clickedplayerid][Captures]);
	ShowPlayerDialog(playerid, 13, DIALOG_STYLE_MSGBOX,"Stats", string,"Ok","");
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	new Float:th, Float:ta;
	new string[40];
	GetPlayerHealth(playerid, th);
	GetPlayerArmour(playerid, ta);
	new Float:extdam;
	if(ta > 0)
	{
	    if(issuerid != INVALID_PLAYER_ID && gTeam[issuerid] != gTeam[playerid])
	    {
			format(string, sizeof(string),"-----------------~n~Armr. %03.0f~n~-----------------", ta-amount);
			PlayerTextDrawSetString(playerid, Armrdraw[playerid], string);
		}
		else
		{
            format(string, sizeof(string),"----------~n~+ %03.0f~n~----------", th-amount);
            PlayerTextDrawSetString(playerid, Hdraw[playerid], string);
		}
	}
	else
	{
	    if(weaponid == 24)
	    {
	        if(Pclass[issuerid] == VIP_CLASS)
			{
			 extdam = 34.0;
			 SetPlayerHealth(playerid, th-amount-extdam);
	        }
	    }
		if((th-amount-extdam) <= 0 && bodypart == 9)
		{
	    	Playerinfo[issuerid][Score] += 2;
	    	SetPlayerScore(issuerid, Playerinfo[issuerid][Score]);
	    	PlayerTextDrawSetString(issuerid, Secondaryreward[issuerid], "Headshot  2XP");
			PlayerTextDrawShow(issuerid, Secondaryreward[issuerid]);
			Rewardtime[playerid] = SetTimerEx("Rewardhide", 2000, 0, "i", issuerid);
		}
		if(issuerid == INVALID_PLAYER_ID)
		{
			format(string, sizeof(string),"----------~n~+ %03.0f~n~----------", th-amount);
			PlayerTextDrawSetString(playerid, Hdraw[playerid], string);
		}
		else if(gTeam[issuerid] != gTeam[playerid])
		{
			format(string, sizeof(string),"----------~n~+ %03.0f~n~----------", th-amount-extdam);
			PlayerTextDrawSetString(playerid, Hdraw[playerid], string);
		}
	}
	return 1;
}

//MySQL Threads
public OnAccountSearch(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, mysqldb);
	if(rows)
	{
 		// Login Dialog
	    ShowPlayerDialog(playerid, 3,DIALOG_STYLE_PASSWORD,"Login","This account is registered. Please enter your password to proceed","Login","Cancel");
	    Playerinfo[playerid][dbID] = cache_get_field_content_int(0, "ID", mysqldb);
	}
	else
	{
 		// Registration Dialog
	    ShowPlayerDialog(playerid, 2, DIALOG_STYLE_PASSWORD, "Register", "You are not registered, please enter your password below to register.","Register","Cancel");
	}
	return 1;
}

public OnAccountRegister(playerid)
{
	Playerinfo[playerid][dbID] = cache_insert_id();
	ShowPlayerDialog(playerid, 4,DIALOG_STYLE_MSGBOX,"Important Notes!"," 1. Check out /help and /rules BEFORE playing\n 2. Use /ask if you need extra help \n 3. Commands are fully available on /help \n 4. Use /report in case you find a hacker \n 5. Sniper class is invisible on the map!\n","Ok","");
	return 1;
}

public OnPlayerAttemptLogin(playerid, inputtext[])
{
	new rows, fields, password[140];
	cache_get_data(rows, fields, mysqldb);
	cache_get_field_content(0, "Password", password, mysqldb, sizeof(password));
	for(new i = 0; i < strlen(inputtext); i++)
	{
	   		 inputtext[i] = inputtext[i] + 10;
	}
	WP_Hash(inputtext, 140, inputtext);
	strdel(password, 0, 3);
	strdel(password, 31, 34);
	if(!strcmp(inputtext, password, 0))
	{
 		Playerinfo[playerid][Score] = cache_get_field_content_int(0, "Score");
		Playerinfo[playerid][Kills] = cache_get_field_content_int(0, "Kills");
		Playerinfo[playerid][Deaths] = cache_get_field_content_int(0, "Deaths");
		Playerinfo[playerid][Captures] = cache_get_field_content_int(0, "Captures");
		Playerinfo[playerid][Adminlevel] = cache_get_field_content_int(0, "Adlevel");
		Playerinfo[playerid][Tokens] = cache_get_field_content_int(0, "Tokens");
		Playerinfo[playerid][dbID] = cache_get_field_content_int(0, "ID");
		DSP{playerid} = cache_get_field_content_int(0, "DSP");
		Logged{playerid} = 1;
  		StopAudioStreamForPlayer(playerid);
  		TogglePlayerSpectating(playerid, 0);
		SetPlayerScore(playerid, Playerinfo[playerid][Score]);
		SetPlayerRankFromScore(playerid, Playerinfo[playerid][Score]);
		Update3DTextLabelText(Labels[playerid], 0xD7D7D7FF, GetRankNameFromID(Playerinfo[playerid][RankID]));
		Attach3DTextLabelToPlayer(Labels[playerid], playerid, 0, 0, 0.3);
		PlayerTextDrawSetString(playerid, Rankdraw[playerid], GetRankNameFromID(Playerinfo[playerid][RankID]));
		new string[50];
		format(string, sizeof(string),"Score: %d~n~BattlePoints: %d", Playerinfo[playerid][Score], Playerinfo[playerid][Tokens]);
		PlayerTextDrawSetString(playerid, Scoredraw[playerid], string);
		mysql_format(mysqldb, password, sizeof(password),"SELECT * FROM VIPs WHERE `ID` = %d LIMIT 1", Playerinfo[playerid][dbID]);
		mysql_tquery(mysqldb, password, "OnAccountVIPcheck", "i", playerid);
		if(!DSP{playerid})
		{
			  //  TextDrawShowForPlayer(playerid, SAmap);
			  //  TextDrawShowForPlayer(playerid, SAmap1);
			  	TextDrawHideForPlayer(playerid, HUDbg);
				PlayerTextDrawHide(playerid, Magdraw[playerid]);
				PlayerTextDrawHide(playerid, Ammodraw[playerid]);
				PlayerTextDrawHide(playerid, Armrdraw[playerid]);
				PlayerTextDrawHide(playerid, Hdraw[playerid]);
				PlayerTextDrawHide(playerid, Wstate[playerid]);
				PlayerTextDrawHide(playerid, Rankdraw[playerid]);
				PlayerTextDrawHide(playerid, Scoredraw[playerid]);
				TextDrawHideForPlayer(playerid, Logodraw);
			  	TextDrawBoxColor(Teambutton[0], 0xFFFFFFBB);
				TextDrawColor(Teambutton[0], 0x000000FF);
				TextDrawSetOutline(Teambutton[0], 0);
				TextDrawBoxColor(Teambutton[1], 0x15151577);
				TextDrawColor(Teambutton[1], -1);
				TextDrawSetOutline(Teambutton[1], 1);
				TextDrawBoxColor(Teambutton[2], 0x15151577);
				TextDrawColor(Teambutton[2], -1);
				TextDrawSetOutline(Teambutton[2], 1);
				TextDrawBoxColor(Teambutton[3], 0x15151577);
				TextDrawColor(Teambutton[3], -1);
				TextDrawSetOutline(Teambutton[3], 1);
				TextDrawBoxColor(Classicon[0], 0xFFFFFFBB);
				TextDrawColor(Classicon[0], 0x000000FF);
				TextDrawSetOutline(Classicon[0], 0);
				TextDrawBoxColor(Classicon[1], 0x15151555);
				TextDrawColor(Classicon[1], 0xFFFFFFFF);
				TextDrawSetOutline(Classicon[1], 1);
				TextDrawBoxColor(Classicon[2], 0x15151555);
				TextDrawColor(Classicon[2], 0xFFFFFFFF);
				TextDrawSetOutline(Classicon[2], 1);
				TextDrawBoxColor(Classicon[3], 0x15151555);
				TextDrawColor(Classicon[3], 0xFFFFFFFF);
				TextDrawSetOutline(Classicon[3], 1);
				TextDrawBoxColor(Classicon[4], 0x15151555);
				TextDrawColor(Classicon[4], 0xFFFFFFFF);
				TextDrawSetOutline(Classicon[4], 1);
				TextDrawBoxColor(Classicon[5], 0x15151555);
				TextDrawColor(Classicon[5], 0xFFFFFFFF);
				TextDrawSetOutline(Classicon[5], 1);
				TextDrawBoxColor(Classicon[6], 0x15151555);
				TextDrawColor(Classicon[6], 0xFFFFFFFF);
				TextDrawSetOutline(Classicon[6], 1);
				TextDrawBoxColor(Classicon[7], 0x15151555);
				TextDrawColor(Classicon[7], 0xFFFFFFFF);
				TextDrawSetOutline(Classicon[7], 1);
				TextDrawColor(SnipeIcon, 0xFFFFFFFF);
				TextDrawSetOutline(SnipeIcon, 1);
				PlayerTextDrawSetString(playerid,Spawnclass[playerid], "ASSAULT");
				PlayerTextDrawSetString(playerid,ClassStats[playerid],"   M4A1      D-EAGLE      MP5      No Perk~n~ ~n~");
				PlayerTextDrawSetString(playerid, SpawnNotice[playerid],"~n~");
			    TextDrawShowForPlayer(playerid, Teamdraw);
			    TextDrawShowForPlayer(playerid, Teambutton[0]);
			    TextDrawShowForPlayer(playerid, Teambutton[1]);
			    TextDrawShowForPlayer(playerid, Teambutton[2]);
			    TextDrawShowForPlayer(playerid, Teambutton[3]);
			    TextDrawShowForPlayer(playerid, Deploydrawbg);
			    TextDrawShowForPlayer(playerid, Deploydraw);
			    TextDrawShowForPlayer(playerid, Basebox);
			    TextDrawShowForPlayer(playerid, BaseDepdrawbg);
			    TextDrawShowForPlayer(playerid, BaseDepdraw);
			    TextDrawShowForPlayer(playerid, DeployAsdraw);
			    TextDrawShowForPlayer(playerid, Classicon[0]);
			    TextDrawShowForPlayer(playerid, Classicon[1]);
			    TextDrawShowForPlayer(playerid, Classicon[4]);
			    TextDrawShowForPlayer(playerid, SnipeIcon);
			    TextDrawShowForPlayer(playerid, Classicon[2]);
			    TextDrawShowForPlayer(playerid, Classicon[6]);
			    TextDrawShowForPlayer(playerid, Classicon[3]);
			    TextDrawShowForPlayer(playerid, Classicon[5]);
			    if(GetPVarInt(playerid,"Viplevel") > 1)TextDrawShowForPlayer(playerid, Classicon[7]);
			    TextDrawShowForPlayer(playerid, DeployButton);
			    PlayerTextDrawShow(playerid, Spawnclass[playerid]);
			    PlayerTextDrawShow(playerid, SpawnNotice[playerid]);
				TextDrawShowForPlayer(playerid, Spawnbg);
				TextDrawShowForPlayer(playerid, ClassStatsbg);
				PlayerTextDrawShow(playerid, ClassStats[playerid]);
				SelectTextDraw(playerid, 0xFFFFFF55);
				TogglePlayerSpectating(playerid, 1);
				SetTimerEx("SpectateDebug", 200, 0, "i", playerid);
				PlayAudioStreamForPlayer(playerid,"http://k007.kiwi6.com/hotlink/0i3ec1jcvb/Switch-SFX.mp3",0,0,0,0,0);
				for(new i = 0; i < 10; i++)
				{
				    SendClientMessage(playerid, -1, " ");
				}
				for(new i =0; i < MAX_TEAM_PLAYERS; i++)
				{
				    if(Tplayers[gTeam[playerid]][i] == playerid)
					{
					 	Tplayers[gTeam[playerid]][i] = INVALID_PLAYER_ID;
				    	break;
					}
				}
			 	gTeam[playerid] = TEAM_US;
			    Pclass[playerid] = ASSAULT_CLASS;
		}
		else if(DSP{playerid} == 1)
		{
					for(new i =0; i < MAX_TEAM_PLAYERS; i++)
					{
					    if(Tplayers[gTeam[playerid]][i] == playerid)
						{
						 	Tplayers[gTeam[playerid]][i] = INVALID_PLAYER_ID;
					    	break;
						}
					}
					gTeam[playerid] = TEAM_NULL;
					Pclass[playerid] = ASSAULT_CLASS;
		        	SetSpawnInfo(playerid, 4, Teaminfo[4][Skin],Teaminfo[4][TX],Teaminfo[4][TY],Teaminfo[4][TZ],Teaminfo[4][TAngle],0,0,0,0,0,0);
		        	SetPlayerSkin(playerid, GetPVarInt(playerid, "VIPskin"));
		        	SpawnPlayer(playerid);
		        	OnPlayerRequestSpawn(playerid);
		}
	}
	else
	{
 		if(LoginAttempts{playerid} == 2) return Kick(playerid);
   		LoginAttempts{playerid} += 1;
		SendClientMessage(playerid,0xD70000FF, "Wrong Password");
 		ShowPlayerDialog(playerid, 3,DIALOG_STYLE_PASSWORD,"Login","Please enter your password to proceed","Login","Cancel");
	}
	return 1;
}

public OnAccountSaveStats(playerid, viplevel)
{
	Logged{playerid} = 0;
	Playerinfo[playerid][Adminlevel] = 0;
	Playerinfo[playerid][Capzone] = 0;
	Czone[playerid] = 0;
	Playerinfo[playerid][pmreject] = false;
	Playerinfo[playerid][pjammed] = false;
	Playerinfo[playerid][Tokens] = 0;
	Playerinfo[playerid][Kills] = 0;
	Playerinfo[playerid][Deaths] = 0;
	Playerinfo[playerid][Score] = 0;
	Playerinfo[playerid][Captures] = 0;
	Playerinfo[playerid][jammed] = false;
	Playerinfo[playerid][muted] = false;
	LoginAttempts{playerid} = 0;
	DSP{playerid} = 0;
	ClassTime[playerid] = 0;
	TeamTime[playerid] = 0;
	if(viplevel == 0) Playerinfo[playerid][dbID] = 0;
	return 1;
}

public OnAccountVIPcheck(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, mysqldb);
	if(rows)
	{
	    new query[72];
		SetPVarInt(playerid, "Viplevel", cache_get_field_content_int(0, "Viplevel"));
		SetPVarInt(playerid, "VIPskin", cache_get_field_content_int(0, "Vipskin"));
		SetPVarFloat(playerid, "DonationSum", cache_get_field_content_int(0, "DonationSum"));
		mysql_format(mysqldb, query, sizeof(query), "SELECT * FROM AttachObjs WHERE `ID` = %d", Playerinfo[playerid][dbID]);
		mysql_tquery(mysqldb, query, "OnVIPObjectsRetrieval", "i", playerid);
	}
	return 1;
}

public OnVIPObjectsRetrieval(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, mysqldb);
	if(rows)
	{
		new Objects = cache_get_row_count();
		new query[50];
		for(new i = 0; i < Objects; i++)
		{
			new index = cache_get_field_content_int(i, "ObjIndex");
		    new string[15];
		    format(string ,sizeof(string), "AttachObj%d", index);
		    SetPVarInt(playerid, string, cache_get_field_content_int(i, "ObjID"));
		    format(string, sizeof(string),"ObjBone%d", index);
		    SetPVarInt(playerid ,string, cache_get_field_content_int(i, "Bone"));
		    format(string ,sizeof(string),"ObjRotX%d", index);
		    SetPVarFloat(playerid, string, cache_get_field_content_float(i, "RotX"));
		    format(string, sizeof(string),"ObjRotY%d", index);
		    SetPVarFloat(playerid, string, cache_get_field_content_float(i, "RotY"));
		    format(string, sizeof(string),"ObjRotZ%d", index);
		    SetPVarFloat(playerid, string, cache_get_field_content_float(i, "RotZ"));
		    format(string, sizeof(string),"ObjOffX%d", index);
		    SetPVarFloat(playerid, string, cache_get_field_content_float(i, "OffX"));
		    format(string, sizeof(string),"ObjOffY%d", index);
		    SetPVarFloat(playerid, string, cache_get_field_content_float(i, "OffY"));
		    format(string, sizeof(string),"ObjOffZ%d", index);
		    SetPVarFloat(playerid, string, cache_get_field_content_float(i, "OffZ"));
		}
		mysql_format(mysqldb, query, sizeof(query), "DELETE FROM AttachObjs WHERE `ID` = %d", Playerinfo[playerid][dbID]);
		new Cache:deletion = mysql_query(mysqldb, query);
		cache_delete(deletion);
	}
	return 1;
}

public OnReferredCheck(playerid, path[], params[])
{
	if(cache_get_row_count() < 2)
	{
	    format(path, 95, "Username is not found in Database!");
	    SendClientMessage(playerid, COLOUR_RED, path);
	    return 1;
	}
	new PlayerRow, TargetRow;
	if(cache_get_field_content_int(0, "ID") == Playerinfo[playerid][dbID]) PlayerRow = 0, TargetRow = 1;
	else PlayerRow = 1, TargetRow = 0;
	if(cache_get_field_content_int(PlayerRow, "Referred") == 1)
	{
		format(path, 95, "You have already been referred!");
		SendClientMessage(playerid, COLOUR_RED, path);
	 	return 1;
	}
	new refers = cache_get_field_content_int(TargetRow, "Refers");
	mysql_format(mysqldb, path, 95, "UPDATE SRVRPlayers SET Refers = %d WHERE Username = '%e'", refers+1,  params);
	mysql_query(mysqldb, path, false);
	mysql_format(mysqldb, path, 95, "UPDATE SRVRPlayers SET Referred = 1 WHERE ID = %d", Playerinfo[playerid][dbID]);
	mysql_query(mysqldb, path, false);
    format(path, 95,"You have been referred successfully by %s!", params);
	SendClientMessage(playerid, COLOUR_GREEN, path);
	return 1;
}

public OnPlayerRequestNewUsername(playerid, inputpassword[])
{
	new rowcount = cache_get_row_count();
	if(rowcount > 1) return SendClientMessage(playerid, COLOUR_RED, "Username is already in Database!");
	new password[140];
	cache_get_field_content(0, "Password", password, mysqldb, sizeof(password));
	for(new i = 0, len=strlen(inputpassword); i < len; i++)
	{
	    inputpassword[i] = inputpassword[i] + 10;
	}
	WP_Hash(inputpassword, 140, inputpassword);
	strdel(password, 0, 3);
	strdel(password, 31, 34);
	if(strcmp(inputpassword, password, false)) return SendClientMessage(playerid, COLOUR_RED,"Wrong password");
	new name[25];
	GetPVarString(playerid, "NewUsername", name, sizeof(name));
	mysql_format(mysqldb, password, sizeof(password), "UPDATE SRVRPlayers SET Username = '%e' WHERE ID = %d", name, Playerinfo[playerid][dbID]);
	mysql_tquery(mysqldb, password);
	SendClientMessage(playerid, COLOUR_GREEN, "Username changed successfully.Please relog with your new username");
	return 1;
}

public OnPlayerRequestNewPass(playerid, newpassword[])
{
	new Hash[200], oldpass[140], newHash[140];
	GetPVarString(playerid, "OldPass", oldpass, 140);
	cache_get_field_content(0, "Password", Hash, mysqldb, 140);
	for(new i = 0; i < strlen(oldpass); i++)
	{
	   		 oldpass[i] = oldpass[i] + 10;
	}
	WP_Hash(oldpass, 140, oldpass);
	strdel(Hash, 0, 3);
	strdel(Hash, 31, 34);
	printf("Old Pass after Hash: %s", oldpass);
	printf("Password Retrieved from DB: %s", Hash);
	if(strcmp(oldpass, Hash, 0)) return SendClientMessage(playerid, COLOUR_RED, "Wrong Password");
	for(new i = 0; i < strlen(newpassword); i++)
	{
	   		 newpassword[i] = newpassword[i] + 10;
	}
	strins(newHash, newpassword, 0, 140);
	printf("New pass b4 Hash: %s", newpassword);
	WP_Hash(newHash, 140, newHash);
	printf("New pass after Hash: %s", newHash);
	new ran[4];
	for(new i = 0; i < 3; i++)
	{
		   ran[i] = random(25) +65;
	}
	strins(newHash, ran, 0, 3);
	for(new i = 0;i < 3; i++)
	{
			 ran[i] = random(25) +65;
	}
	strins(newHash, ran, 34, 3);
	SendClientMessage(playerid, COLOUR_GREEN,"Password successfully changed, please relog");
	mysql_format(mysqldb, Hash, sizeof(Hash), "UPDATE SRVRPlayers SET Password = '%e' WHERE ID = %d", newHash, Playerinfo[playerid][dbID]);
	printf("Query: %s", Hash);
	mysql_tquery(mysqldb, Hash);
	return 1;
}

AntiDeAMX()
{
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}
