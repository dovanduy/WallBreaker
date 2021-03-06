require "util"
require "func"

-- Util func
function diag_click()
	local x, y = findColor({0, 0, 1135, 639},
		"0|0|0xfde8e8,-17|0|0xffebeb,15|0|0xfde8e8,0|-18|0x12100c",
		95, 0, 0, 0)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,"对话",20,"0xff000000","0xffffffff",0,100,0,300,32)
		random_touch(0, x, y, 20, 20)
	end
	return x, y
end

function new_char()
	local x, y = findColor({1056, 49, 1058, 51},
		"0|0|0x3c5857,35|-21|0x385553,11|-7|0x2e3d44,23|-14|0x35444a",
		95, 0, 0, 0)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,"人物",20,"0xff000000","0xffffffff",0,100,0,300,32)
		random_touch(0, x, y, 50, 50)
	end
	return x, y
end

function bypass_click()
	local x, y = findColor({748, 468, 750, 470},
		"0|0|0x7555dd,-4|8|0x7d61e1,29|-4|0x3640ac",
		70, 0, 0, 0)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,"跳过",20,"0xff000000","0xffffffff",0,100,0,300,32)
		random_touch(0, x+40, y+10, 20, 10)
	end
	return x, y
end

function speed_click()
	local x, y = findColor({1044, 49, 1046, 51},
		"0|0|0xd3ac85,-19|0|0xd4ad86,-114|0|0x8e7967,-125|1|0xd1a882",
		80, 0, 0, 0)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,"快进",20,"0xff000000","0xffffffff",0,100,0,300,32)
		random_touch(0, x, y, 20, 20)
	end
	return x, y
end

function fight_click()
	local x, y = findColor({0, 0, 1135, 639},
		"0|0|0xd2d4f9,8|15|0x232755,-3|-22|0xf3aeb8,-8|-5|0x5b6daa",
		95, 1, 0, 0)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,"战斗",20,"0xff000000","0xffffffff",0,100,0,300,32)
		random_touch(0, x, y, 20, 20)
	end
	return x, y
end

function eye_click()
	local x, y = findColor({0, 0, 1135, 639},
		"0|0|0xfcfcfc,-22|-8|0xcbd5dc,19|10|0xdce3e7,15|-39|0x2f2623,-18|32|0x473e48",
		95, 0, 0, 0)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,"眼睛",20,"0xff000000","0xffffffff",0,100,0,300,32)
		random_touch(0, x, y, 20, 20)
	end
	return x, y
end

function questionmark_click()
	local x, y = findColor({0, 0, 1135, 639},
		"0|0|0xffefdd,0|-21|0xffefdd,18|5|0x12100c,-20|6|0x12100c,0|18|0xffefdd",
		95, 0, 0, 0)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,"问号",20,"0xff000000","0xffffffff",0,100,0,300,32)
		random_touch(0, x, y, 20, 20)
	end
	return x, y
end

-- Main func
function autostory()
	print_global_config()
	local time_cnt = 0
	local rd
	local x, y
	
	while (1) do
		while (1) do
			mSleep(1000)
			-- 对话
			x, y = diag_click() if (x > -1) then time_cnt = 0 break end
			-- 新任务
			x, y = new_char() if (x > -1) then time_cnt = 0 break end
			-- 问号
			x, y = questionmark_click() if (x > -1) then time_cnt = 0 break end
			-- 快进
			x, y = speed_click() if (x > -1) then time_cnt = 0 break end
			-- 战斗
			x, y = fight_click() if (x > -1) then time_cnt = 0 break end
			-- 眼睛
			x, y = eye_click() if (x > -1) then time_cnt = 0 break end
			-- 跳过
			x, y = bypass_click() if (x > -1) then time_cnt = 0 break end
			-- 战斗准备
			x, y = fight_ready() if (x > -1) then time_cnt = 0 break end
			-- 战斗进行
			x, y = fight_ongoing() if (x > -1) then break end
			-- 战斗胜利
			x, y = fight_success()
			if (x > -1) then
				win_cnt.global = win_cnt.global + 1
				show_win_fail(win_cnt.global, fail_cnt.global)
				time_cnt = 0
				break
			end
			-- 战斗失败
			x, y = fight_failed()
			if (x > -1) then
				fail_cnt.global = fail_cnt.global + 1
				show_win_fail(win_cnt.global, fail_cnt.global)
				time_cnt = 0
				break
			end
			time_cnt = time_cnt + 1
			if time_cnt > 20 then
				HUD_show_or_hide(HUD,hud_info,"移动",20,"0xff000000","0xffffffff",0,100,0,300,32)
				rd = math.random(1, 2)
				if (rd % 2 == 0) then
					random_move(0, 300, 300, 800, 300, 20, 20)
				else
					random_move(0, 800, 300, 300, 300, 10, 10)
				end
				mSleep(1000)
				time_cnt = 0
			end
			-- 关闭频道
			x, y = close_channel() if x > -1 then break end
			break
		end
	end
	return RET_ERR
end